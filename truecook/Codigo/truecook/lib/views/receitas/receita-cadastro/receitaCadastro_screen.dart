import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/models/receita_has_ingrediente.dart';
import 'package:truecook/provider/ReceitaCadastroForm_Provider.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/receita_has_igrediente_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/services/image_uploader.dart';
import 'package:truecook/shared/enums/folderPathsImage.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/receitas/receita-cadastro/components/categoriasCadastro_card.dart';
import 'package:truecook/views/receitas/receita-cadastro/components/igredientesCadastro_card.dart';
import 'package:truecook/views/receitas/receita-cadastro/components/obervacoesCadastro_card.dart';
import 'package:truecook/views/receitas/receita-cadastro/components/preparoCadastro_card.dart';
import 'package:truecook/views/receitas/receita-cadastro/components/topBarReceita.dart';

class ReceitaCadastroScreen extends StatefulWidget {
  @override
  State<ReceitaCadastroScreen> createState() => _ReceitaCadastroScreenState();
}

class _ReceitaCadastroScreenState extends State<ReceitaCadastroScreen> {
  double _uploadProgress = 0.0; // 0.0 a 1.0
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TagProvider>(context, listen: false).carregarTodos();
    });
  }

  final picker = ImagePicker();

  final List<Ingrediente> igredientes = [];
  final List<String> preparo = [];
  final List<String> obserrvacoes = [];
  final List<String> categorias = [];
  List<String> categoriasOptions = [];

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ReceitaCadastroFormProvider>(
        context,
        listen: false,
      ).setImagem(File(pickedFile.path));
    }
  }

  Widget _cardSobreposto({List<Widget> children = const []}) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map(
                (e) => Padding(padding: EdgeInsets.only(bottom: 10), child: e),
              )
              .toList(),
        ),
      ),
    );
  }

  // --- Widget Novo: Mostra o Progresso do Upload ---
  Widget _buildUploadStatus() {
    final percentual = (_uploadProgress * 100).toInt();

    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 40),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ocupa só o espaço necessário
            children: [
              // 1. Ícone ou Loader
              if (_uploadProgress >= 1.0)
                const CircularProgressIndicator(
                  color: AppColors.greenDefault,
                ) // Processando banco
              else
                Icon(
                  Icons.cloud_upload,
                  size: 50,
                  color: AppColors.greenDefault,
                ),

              const SizedBox(height: 20),

              // 2. Texto de Status
              Text(
                _uploadProgress >= 1.0
                    ? "Finalizando cadastro..."
                    : "Enviando Receita...",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // 3. Barra de Progresso Linear
              LinearProgressIndicator(
                value: _uploadProgress, // Aqui entra o valor dinâmico!
                backgroundColor: Colors.grey[200],
                color: AppColors.greenDefault,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),

              const SizedBox(height: 10),

              // 4. Porcentagem em Texto
              Text(
                "$percentual%",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveReceita() async {
    final formProvider = Provider.of<ReceitaCadastroFormProvider>(
      context,
      listen: false,
    );

    if (!formProvider.formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios!')),
      );
      return;
    }

    formProvider.formKey.currentState!.save();

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      String imageUrl = "";

      if (formProvider.imagem != null) {
        // Aqui chamamos o service passando o callback para atualizar a tela
        imageUrl = await ImageUploader.uploadImage(
          imageFile: formProvider.imagem!,
          titulo: formProvider.titulo,
          folderPath: FolderPathsImage.receitas,
          onProgress: (progress) {
            // Atualiza a barra de progresso em tempo real
            setState(() {
              _uploadProgress = progress;
            });
          },
        );
      } else {
        imageUrl = AppAssets.DefaultImage;
      }

      // Se chegou aqui, upload 100%. Garante que a barra encha.
      setState(() => _uploadProgress = 1.0);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final receitaProvider = Provider.of<ReceitaProvider>(
        context,
        listen: false,
      );
      final receitaHasIgredienteProvider =
          Provider.of<ReceitaHasIgredienteProvider>(context, listen: false);

      final novaReceita = Receita(
        titulo: formProvider.titulo,
        descricao: 'Receita criada com TrueCook',
        passo_a_passo: preparo.join('\n'),
        tempo_preparo: formProvider.tempoPreparo,
        observacoes: obserrvacoes.join('\n'),
        imagem: imageUrl,
        usuario_id: await authProvider.getLoggedUserId() ?? 0,
        data_publicacao: DateTime.now(),
      );

      final id = await receitaProvider.adicionarReceita(novaReceita);

      if (id != -1) {
        for (Ingrediente ingrediente in igredientes) {
          await receitaHasIgredienteProvider.adicionar(
            ReceitaHasIngrediente(
              receitaId: id,
              ingrediente_id: ingrediente.id!,
            ),
          );
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita criada com sucesso! 😋')),
        );

        await receitaProvider.carregarTodos();
        Navigator.pop(context);
      } else {
        throw Exception("Erro ao inserir receita no banco");
      }
    } catch (e) {
      print("Erro ao salvar: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar receita: $e')));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
    formProvider.formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final tagProvider = Provider.of<TagProvider>(context);
    final formProvider = Provider.of<ReceitaCadastroFormProvider>(context);
    categoriasOptions = tagProvider.items.map((tag) => tag.nome).toList();

    Widget _buildHeaderImage() {
      return GestureDetector(
        onTap: () => _selectImage(context),
        child: Container(
          height: 220,
          width: double.infinity,
          color: Colors.grey[300],
          child: formProvider.imagem != null
              ? Image.file(formProvider.imagem!, fit: BoxFit.cover)
              : Image.asset(AppAssets.DefaultImage2, fit: BoxFit.cover),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: topBarReceita(context),
      ),
      body: _isUploading
          ? _buildUploadStatus() // Mostra o card com a barra de progresso
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderImage(),
                  Form(
                    key: formProvider.formKey,
                    child: _cardSobreposto(
                      children: [
                        TextFormField(
                          initialValue: formProvider.titulo,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Informe o título'
                              : null,
                          onSaved: (v) => formProvider.titulo = v!,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Nome da Receita',
                            prefixIcon: Icon(Icons.restaurant_menu),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Informe o tempo' : null,
                          onSaved: (v) =>
                              formProvider.tempoPreparo = int.parse(v!),
                          decoration: const InputDecoration(
                            labelText: 'Tempo (min)',
                            hintText: 'Ex: 45',
                            prefixIcon: Icon(Icons.timer),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        CategoriasCadastroListCards(
                          categorias: categorias,
                          categoriasOptions: categoriasOptions,
                        ),
                        IgredientescadastroCard(
                          title: "Ingredientes",
                          igredientes: igredientes,
                        ),
                        ObervacoescadastroCard(
                          title: "Modo de Preparo",

                          obserrvacoes: preparo,
                        ),

                        PreparocadastroCard(
                          title: "Observações",

                          etapas: obserrvacoes,
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isUploading
          ? null // Esconde botões durante upload
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redDefault,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveReceita,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenDefault,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Criar Receita',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}