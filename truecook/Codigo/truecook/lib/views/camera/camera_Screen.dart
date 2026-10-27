import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:truecook/data/db/db.dart';
import 'package:truecook/provider/igredientes_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/components/receitaHome_card.dart';

// Seus Modelos
import 'package:truecook/models/receita.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/models/comentario.dart'; // ✅ IMPORTAR O NOVO MODELO

class GeradorReceitasView extends StatefulWidget {
  const GeradorReceitasView({super.key});

  @override
  State<GeradorReceitasView> createState() => _GeradorReceitasViewState();
}

class _GeradorReceitasViewState extends State<GeradorReceitasView> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  XFile? _capturedImage;
  bool _isLoading = false;
  String? _apiResponse;

  List<Receita> _receitas = [];

  final String _apiKey = 'AIzaSyCwzcik0umqSNZMdZl1bufoTJIm3a0nxz0'; // Cuidado

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
      );
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Erro ao inicializar câmera: $e");
    }
  }

  @override
  void dispose() {
    if (_isCameraInitialized && _cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || !_cameraController.value.isInitialized) return;
    try {
      final XFile image = await _cameraController.takePicture();
      setState(() => _capturedImage = image);
    } catch (e) {
      debugPrint("Erro ao tirar foto: $e");
    }
  }

  // ----------------------------------------------
  // 🤖 Envia imagem ao Gemini e analisa ingredientes
  // ----------------------------------------------
  Future<void> _sendToGemini() async {
    if (_capturedImage == null) return;

    setState(() {
      _isLoading = true;
      _apiResponse = null;
      _receitas = [];
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: _apiKey,
      );

      final Uint8List imageBytes = await File(
        _capturedImage!.path,
      ).readAsBytes();

      final igredientesProvider = Provider.of<IngredientesProvider>(
        context,
        listen: false,
      );

      final prompt = TextPart('''
        Analise esta imagem e identifique os ingredientes visíveis.
        Retorne APENAS um JSON no formato:
        {"ingredientes": ["nome_ingrediente1","nome_ingrediente2", ...]}
        Os nomes devem ser o mais próximo possível dos nomes do meu
         banco de dados e todas no singular (ex: ${igredientesProvider.items.map((ele) => ele.nome).join(', ')}.).
        Responda em português do Brasil.
      ''');

      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      final rawText = (response.text ?? '').trim();
      log('🧠 Gemini raw: $rawText');

      final parsed = _tryExtractJson(rawText);

      if (parsed == null || parsed['ingredientes'] == null) {
        setState(() {
          _apiResponse =
              '⚠️ Não foi possível interpretar JSON com "ingredientes".\nResposta recebida:\n$rawText';
          _isLoading = false;
        });
        return;
      }

      final List<String> ingredientes = List<String>.from(
        parsed['ingredientes'],
      );
      log('🏷️ Ingredientes extraídos: $ingredientes');

      // Esta função agora "hidrata" as receitas
      final List<Receita> receitas = await _buscarReceitasPorIngredientes(
        ingredientes,
      );

      setState(() {
        _receitas = receitas;
        _isLoading = false;
        _apiResponse = ingredientes.isNotEmpty
            ? 'Ingredientes identificados: ${ingredientes.join(', ')}'
            : '⚠️ Nenhuma ingrediente identificada na imagem.';
      });
    } catch (e, st) {
      debugPrint('Erro ao chamar Gemini: $e\n$st');
      setState(() {
        _apiResponse = 'Erro ao analisar a imagem: $e';
        _isLoading = false;
      });
    }
  }

  // ----------------------------------------------
  // 🔍 FUNÇÃO DE BUSCA (ALTERADA)
  // ----------------------------------------------
  Future<List<Receita>> _buscarReceitasPorIngredientes(
    List<String> ingredientes,
  ) async {
    if (ingredientes.isEmpty) return [];

    final sql.Database? database = await DB.instance.database;
    if (database == null) {
      debugPrint("Banco de dados não inicializado!");
      return [];
    }

    // Criamos a lista em minúsculas
    final List<String> cleanedIngredientes = ingredientes
        .map((e) => e.toLowerCase())
        .toList();

    final placeholders = List.filled(cleanedIngredientes.length, '?').join(',');

    // A query principal calcula as MÉDIAS e TOTAIS.
    final sqlQuery =
        '''
      SELECT 
        r.*, 
        COALESCE(AVG(c.avaliacao), 0.0) as media_avaliacoes,
        COUNT(DISTINCT v.usuario_id) as total_visualizacoes
      FROM receita r
      JOIN receita_has_ingrediente ri ON r.id = ri.receita_id
      JOIN ingrediente i ON i.id = ri.ingrediente_id
      LEFT JOIN comentario c ON r.id = c.receita_id
      LEFT JOIN visualizacao_receita v ON r.id = v.receita_id
      WHERE LOWER(i.nome) IN ($placeholders)
      GROUP BY r.id
    ''';

    try {
      final List<Map<String, dynamic>> results = await database.rawQuery(
        sqlQuery,
        cleanedIngredientes,
      );

      final List<Receita> receitasCompletas = [];

      // Loop para "Hidratar" cada receita encontrada
      for (final map in results) {
        // 1. Cria a receita base (O fromMap vai ignorar os campos calculados)
        final receitaBase = Receita.fromMap(map);

        // ✅ ADAPTANDO AO MODELO: Lemos os valores calculados manualmente do map
        final double mediaAvaliacoes = (map['media_avaliacoes'] ?? 0.0)
            .toDouble();
        final int totalVisualizacoes = map['total_visualizacoes'] ?? 0;

        // 2. Busca as listas relacionadas (hidratação)
        final ingredientesCompletos = await _getIngredientesDaReceita(
          database,
          receitaBase.id!,
        );
        final tagsCompletas = await _getTagsDaReceita(
          database,
          receitaBase.id!,
        );

        // 3. ✅ BUSCA A LISTA DE COMENTÁRIOS
        final comentariosCompletos = await _getComentariosDaReceita(
          database,
          receitaBase.id!,
        );

        // 4. Cria a receita final completa
        receitasCompletas.add(
          receitaBase.copyWith(
            ingredientes: ingredientesCompletos,
            tags: tagsCompletas,
            comentarios: comentariosCompletos, // ✅ ADICIONA A LISTA
            // ✅ ADAPTANDO AO MODELO: Injetamos os valores manualmente
            avaliacoes: mediaAvaliacoes,
            visualizacoes: totalVisualizacoes,
          ),
        );
      }

      log("Receitas encontradas: ${receitasCompletas.length}");
      for (var r in receitasCompletas) {
        log(r.toString()); // Agora vai imprimir o num_comentarios
      }

      return receitasCompletas;
    } catch (e, st) {
      debugPrint('Erro ao buscar/hidratar receitas: $e\n$st');
      return [];
    }
  }

  // ----------------------------------------------
  // 💧 Funções Helper para "Hidratar" a Receita
  // ----------------------------------------------

  /// Busca a lista de ingredientes (com quantidade e unidade) de uma receita específica.
  Future<List<Ingrediente>> _getIngredientesDaReceita(
    sql.Database database,
    int receitaId,
  ) async {
    try {
      final List<Map<String, dynamic>> maps = await database.rawQuery(
        '''
        SELECT i.*, ri.quantidade, ri.observacoes 
        FROM ingrediente i
        JOIN receita_has_ingrediente ri ON i.id = ri.ingrediente_id
        WHERE ri.receita_id = ?
      ''',
        [receitaId],
      );

      // Usa o 'Ingrediente.fromMap' (que criámos no passo 2)
      return maps.map((map) => Ingrediente.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar ingredientes da receita $receitaId: $e');
      return [];
    }
  }

  /// Busca a lista de tags de uma receita específica.
  Future<List<Tag>> _getTagsDaReceita(
    sql.Database database,
    int receitaId,
  ) async {
    try {
      final List<Map<String, dynamic>> maps = await database.rawQuery(
        '''
        SELECT t.* FROM tag t 
        JOIN receita_has_tag rt ON t.id = rt.tag_id
        WHERE rt.receita_id = ?
      ''',
        [receitaId],
      );

      // (Assumindo que 'Tag.fromMap' existe e está correto)
      return maps.map((map) => Tag.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar tags da receita $receitaId: $e');
      return [];
    }
  }

  // ✅ NOVA FUNÇÃO HELPER PARA BUSCAR COMENTÁRIOS
  /// Busca a lista de comentários (com dados do usuário) de uma receita específica.
  Future<List<Comentario>> _getComentariosDaReceita(
    sql.Database database,
    int receitaId,
  ) async {
    try {
      // Faz JOIN com 'usuario' para ir buscar nome e foto
      final List<Map<String, dynamic>> maps = await database.rawQuery(
        '''
        SELECT 
          c.*, 
          u.nome as usuario_nome, 
          u.foto as usuario_foto 
        FROM comentario c
        LEFT JOIN usuario u ON c.usuario_id = u.id
        WHERE c.receita_id = ?
        ORDER BY c.data_publicacao DESC
      ''',
        [receitaId],
      );

      // Usa o 'Comentario.fromMap' (que criámos no passo 1)
      return maps.map((map) => Comentario.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar comentários da receita $receitaId: $e');
      return [];
    }
  }

  // ----------------------------------------------
  // ⚙️ Funções utilitárias (sem alteração)
  // ----------------------------------------------

  Map<String, dynamic>? _tryExtractJson(String text) {
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1 || end <= start) return null;
      final jsonString = text.substring(start, end + 1);
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (e) {
      debugPrint('Erro ao parsear JSON: $e');
      return null;
    }
  }

  void _resetView() {
    setState(() {
      _capturedImage = null;
      _apiResponse = null;
      _receitas = [];
      _isLoading = false;
    });
  }

  // ----------------------------------------------
  // 🎨 Widgets de câmera e botões (sem alteração)
  // ----------------------------------------------
  Widget _buildCameraButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE9934B),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 40),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCameraView(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.845,
      height: MediaQuery.of(context).size.height * 0.505,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9934B), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }

  // ----------------------------------------------
  // 🍲 LISTA DE RECEITAS ENCONTRADAS (sem alteração)
  // ----------------------------------------------
  Widget _buildReceitaList() {
    final receitas = _receitas;

    if (receitas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          "Nenhuma receita encontrada para esses ingredientes 😕",
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      // ✅ Alterado para SingleChildScrollView no _buildBody
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.RECEITAS_DETALHES, arguments: receita);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: ReceitaHomeCard(receita: receita),
          ),
        );
      },
    );
  }

  // ----------------------------------------------
  // 🌆 Corpo da tela (renderização dinâmica) (sem alteração)
  // ----------------------------------------------
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFFE9934B)),
            ),
            SizedBox(height: 20),
            Text(
              "Analisando ingredientes...",
              style: TextStyle(
                color: Color(0xFFE9934B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    // --- Se temos receitas ou resposta positiva ---
    if (_receitas.isNotEmpty ||
        (_apiResponse != null &&
            _apiResponse!.contains('Ingredientes identificados'))) {
      // ✅ Envolvido com SingleChildScrollView para evitar overflow
      return SingleChildScrollView(
        child: Column(
          children: [
            if (_apiResponse != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Text(
                  _apiResponse!,
                  style: const TextStyle(
                    color: Color(0xFFE9934B),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Lista de receitas (que agora está com shrinkWrap)
            _buildReceitaList(),

            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
              child: ElevatedButton(
                onPressed: _resetView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9934B),
                ),
                child: const Text("Tirar Nova Foto"),
              ),
            ),
          ],
        ),
      );
    }

    // --- Se temos resposta de erro ou "nenhuma receita" ---
    if (_apiResponse != null && _receitas.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _apiResponse!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9934B),
                ),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // --- Se a imagem foi capturada, mas não analisada ---
    if (_capturedImage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCameraView(
            Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _resetView,
                icon: const Icon(Icons.refresh),
                label: const Text('Tirar Outra'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFE9934B),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _sendToGemini,
                icon: const Icon(Icons.send),
                label: const Text('Analisar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9934B),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // --- Estado inicial (câmera ao vivo) ---
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCameraView(
          (!_isCameraInitialized || !_cameraController.value.isInitialized)
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController),
        ),
        const SizedBox(height: 50),
        _buildCameraButton(onPressed: _takePicture, icon: Icons.camera_alt),
      ],
    );
  }

  // ----------------------------------------------
  // 🏗️ Scaffold principal (sem alteração)
  // ----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDECDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE9934B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gerador de Receitas',
          style: TextStyle(
            color: Color(0xFFE9934B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildBody()),
    );
  }
}
