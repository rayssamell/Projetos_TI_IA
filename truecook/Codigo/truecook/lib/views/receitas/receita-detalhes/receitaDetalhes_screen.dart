import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/comentario.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/provider/comentario_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/provider/visualizacao_receita_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/actionsButtons.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/comentarios_scroll.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/ingredientes_list_card.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/metricas_section.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/categorias_list_cards.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/write_list_card.dart';
import 'package:truecook/views/receitas/receita-detalhes/components/topBarReceita.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/shared/utils/auth.dart';

class ReceitaDetalhesScreen extends StatefulWidget {
  final Receita receita;
  const ReceitaDetalhesScreen({Key? key, required this.receita})
    : super(key: key);

  @override
  State<ReceitaDetalhesScreen> createState() => _ReceitaDetalhesScreenState();
}

class _ReceitaDetalhesScreenState extends State<ReceitaDetalhesScreen> {
  int _visualizacoes = 0;
  List<Comentario> _comentarios = [];
  bool _isLoading = true;

  // Estados de interação
  bool isFavorited = false;
  bool isLiked = false;
  bool isShared = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosReceita();
    });
  }

  Future<void> _carregarDadosReceita() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final visualizacaoProvider = Provider.of<VisualizacaoReceitaProvider>(
      context,
      listen: false,
    );
    final comentarioProvider = Provider.of<ComentarioProvider>(
      context,
      listen: false,
    );
    final receitaProvider = Provider.of<ReceitaProvider>(
      context,
      listen: false,
    ); // Adicionado

    final userId = await authProvider.getLoggedUserId();
    bool isReceitaFavoritadaNoBanco = false;

    if (userId != null) {
      // 1. Registra visualização
      visualizacaoProvider.adicionarVisualizacao(widget.receita, userId);

      // 2. NOVO: Verifica se já é favorito (Liked)
      // Assumindo que sua função no provider se chama 'receitaIsFavorite'
      isReceitaFavoritadaNoBanco = await receitaProvider.receitaIsFavorite(
        userId: userId,
        receitaId: widget.receita.id!,
      );
    }

    // Busca dados em paralelo
    final results = await Future.wait([
      visualizacaoProvider.buscarVisualizacoes(widget.receita.id!),
      comentarioProvider.buscarComentariosReceita(widget.receita.id!),
    ]);

    if (mounted) {
      setState(() {
        _visualizacoes = results[0] as int;
        _comentarios = (results[1] as List<Comentario>?) ?? [];

        // 3. Atualiza o estado do botão Like
        isLiked = isReceitaFavoritadaNoBanco;

        _isLoading = false;
      });
    }
  }

  void _checkLoginAndExecute(VoidCallback action) {
    isLoggedIn(action, context, mounted);
  }

  void _abrirComentarios() {
    _checkLoginAndExecute(() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ComentariosScroll(
                  comentarios: _comentarios,
                  onEnviarComentario: (texto, avaliacao) async {
                    await _adicionarComentario(texto, avaliacao);
                    Navigator.pop(ctx);
                    _abrirComentarios();
                  },
                  onClose: () => Navigator.pop(ctx),
                ),
              );
            },
          );
        },
      );
    });
  }

  Future<void> _adicionarComentario(String texto, double avaliacao) async {
    final comentarioProvider = Provider.of<ComentarioProvider>(
      context,
      listen: false,
    );
    int userId = await AuthProvider.getLoggedUserIdStatic() ?? 0;

    await comentarioProvider.adicionarComentario(
      texto,
      avaliacao,
      userId,
      widget.receita.id!,
    );

    final novosComentarios = await comentarioProvider.buscarComentariosReceita(
      widget.receita.id!,
    );
    if (mounted && novosComentarios != null) {
      setState(() {
        _comentarios = novosComentarios;
      });
    }
  }

  // Função de Ação do Botão Like
  Future<void> _toggleLikeAction() async {
    final receitaProvider = Provider.of<ReceitaProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await authProvider.getLoggedUserId();

    if (userId != null) {
      // Efeito visual imediato (Optimistic UI)
      setState(() {
        isLiked = !isLiked;
      });

      // Chama o backend
      await receitaProvider.toggleFavoriteReceita(
        userId: userId,
        receitaId: widget.receita.id!,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faça o cadastro para curtir uma receita'),
          action: SnackBarAction(
            label: 'Cadastrar',
            textColor: AppColors.greenDefault,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.CADASTRO);
            },
          ),
        ),
      );
    }
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 280,
      width: double.infinity,
      child: widget.receita.imagem != null && widget.receita.imagem!.isNotEmpty
          ? Image.network(
              widget.receita.imagem!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(AppAssets.DefaultImage2, fit: BoxFit.cover),
            )
          : Image.asset(AppAssets.DefaultImage2, fit: BoxFit.cover),
    );
  }

  Widget _cardSobreposto({required List<Widget> children}) {
    return Transform.translate(
      offset: Offset(0, -40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: topBarReceita(context),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.greenDefault),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderImage(),

                  _cardSobreposto(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.receita.titulo,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      MetricasSection(
                        visualizacoes: _visualizacoes,
                        tempo: widget.receita.tempo_preparo,
                        estrelas: widget.receita.avaliacoes,
                      ),

                      Column(
                        children: [
                          CategoriasListCards(
                            categorias: widget.receita.tags
                                .map((e) => e.nome)
                                .toList(),
                          ),
                          SizedBox(
                            height: 10,
                          ), // Adicionado espaçamento manual já que removeu spacing
                          IngredientesListCard(
                            title: "Ingredientes",
                            etapas: widget.receita.ingredientes,
                          ),
                          SizedBox(height: 10),
                          ListwriteCard(
                            title: "Modo de Preparo",
                            etapas: widget.receita.passo_a_passo,
                          ),
                          SizedBox(height: 10),
                          ListwriteCard(
                            title: "Observações",
                            etapas: widget.receita.observacoes,
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      ActionsButtons(
                        isCommented: false,
                        isLiked: isLiked, // Agora reflete o banco de dados
                        isFavorited:
                            isFavorited, // Este botão ficou separado (Favorito vs Curtir)
                        isShared: isShared,

                        onCommentPressed: _abrirComentarios,

                        isFavoritedPressed: () => _checkLoginAndExecute(() {
                          setState(() => isFavorited = !isFavorited);
                        }),

                        // Aqui chamamos a nova função unificada
                        isLikedPressed: () => _checkLoginAndExecute(() {
                          _toggleLikeAction();
                        }),

                        isSharedPressed: () => _checkLoginAndExecute(() {
                          setState(() => isShared = !isShared);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}