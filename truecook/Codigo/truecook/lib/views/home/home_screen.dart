/// Tela Home.
/// - Exibe feed inicial de receitas recomendadas.
/// - Acesso rápido a filtros e categorias.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/regra.dart'; // Importa o modelo de Regra
import 'package:truecook/models/tag.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/provider/usuario_has_tag_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/components/custom_Scaffold.dart';
import 'package:truecook/shared/components/receitaHome_card.dart';
import 'package:truecook/shared/enums/heroTags.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/perfil/components/tag_card.dart';
import 'package:truecook/views/receitas/receita-list/receitaList_screen.dart';
import 'package:truecook/views/home/components/tagChip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<Tag> _selectedFilterTags = {};
  bool _isLoadingData = true;
  String _loadingError = '';

  // Lista para guardar as sugestões da IA
  List<Tag> _sugestoesIA = [];

  // verificar se o usuário está logadop
  Future<void> _verificarLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool estaLogado = await authProvider.isLoggedIn();
    final NavigatorState navigator = Navigator.of(context);

    if (!mounted) return;

    if (estaLogado) {
      navigator.pushNamed(AppRoutes.PERFIL);
    } else {
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.LOGIN,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReceitaProvider>(context, listen: false).carregarReceitas();
      _carregarDadosIniciais();
    });
  }

  Future<void> _carregarDadosIniciais() async {
    if (!mounted) return;
    setState(() {
      _isLoadingData = true;
      _loadingError = '';
      _sugestoesIA = [];
    });

    try {
      // ... (Mantém toda a parte de carregar providers e userId igualzinho estava) ...
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      final usuarioTagProvider = Provider.of<UsuarioHasTagProvider>(context, listen: false);
      final int? userId = await authProvider.getLoggedUserId();

      await Future.wait([
        tagProvider.carregarTags(),
        tagProvider.carregarRegras(),
        if (userId != null) usuarioTagProvider.carregarTagsPorUsuario(userId),
      ]);

      // Carrega tags do usuário logado para a lista inicial
      if (userId != null && usuarioTagProvider.items.isNotEmpty) {
        final idsTagsDoUsuario = usuarioTagProvider.items.map((u) => u.tag_id).toList();
        if (idsTagsDoUsuario.isNotEmpty) {
          await tagProvider.carregarTagsPorIds(idsTagsDoUsuario);
          
          _selectedFilterTags.clear();
          _selectedFilterTags.addAll(tagProvider.tagsDoUsuario);
        }
      }

      Provider.of<ReceitaProvider>(context, listen: false)
          .filtrarPorTags(_selectedFilterTags);
      
      // Chama a IA para analisar o estado inicial carregado
      _atualizarSugestoesIA(); 

    } catch (e) {
      print("Erro ao carregar dados iniciais: $e");
      // ... tratamento de erro ...
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  // --- Recalcula sugestões baseado no que está selecionado 
  void _atualizarSugestoesIA() {
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    final regras = tagProvider.regras;
    
    // Lista de IDs das tags que estão ATIVAS pelo usuário
    final List<int?> idsAtivos = _selectedFilterTags.map((t) => t.id).toList();
    final Set<int> novosIdsSugeridos = {}; 

    // Percorre todas as regras do Python
    for (var regra in regras) {
      bool gatilhoAtivado = regra.antecedents.isNotEmpty && regra.antecedents.every(
        (idAntecedente) => idsAtivos.contains(idAntecedente),
      );

      if (gatilhoAtivado) {
        for (var idConsequente in regra.consequents) {
          // Só sugere se o usuário JÁ NÃO TIVER selecionado essa tag
          if (!idsAtivos.contains(idConsequente)) {
            novosIdsSugeridos.add(idConsequente);
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        // Converte os IDs sugeridos em objetos Tag reais
        _sugestoesIA = tagProvider.items
            .where((tag) => novosIdsSugeridos.contains(tag.id))
            .toList();
      });
      
      if (_sugestoesIA.isNotEmpty) {
        print("IA Recalculou: Sugerindo ${_sugestoesIA.map((t) => t.nome).toList()}");
      }
    }
  }
  
  // Função para lidar com o clique em uma tag
  void _handleFilterTagClick(Tag tag, bool isCurrentlySelected) {
      setState(() {
        if (isCurrentlySelected) {
          _selectedFilterTags.removeWhere((t) => t.id == tag.id);
        } else {
          _selectedFilterTags.add(tag);
        }
      });

      Provider.of<ReceitaProvider>(
        context,
        listen: false,
      ).filtrarPorTags(_selectedFilterTags);

      _atualizarSugestoesIA();

      print("Filtros Ativos: ${_selectedFilterTags.map((t) => t.nome).toList()}");
  }
  @override
  Widget build(BuildContext context) {
    final NavigatorState _navigator = Navigator.of(context);
    final receitaProvider = Provider.of<ReceitaProvider>(context, listen: true);

    Widget buildSearchBar(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.redDefault, width: 2),
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: AppColors.redDefault),
            suffixIcon: Icon(Icons.filter_list, color: AppColors.redDefault),
            hintText: "O que você vai comer hoje?",
            hintStyle: TextStyle(color: AppColors.redDefault.withOpacity(0.5)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (query) {
            receitaProvider.buscarReceitas(query);
          },
        ),
      );
    }

    Widget buildReceitaList() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: receitaProvider.filteredItems.length,
        itemBuilder: (context, index) {
          var receita = receitaProvider.filteredItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _navigator.pushNamed(
                  AppRoutes.RECEITAS_DETALHES,
                  arguments: receita,
                );
              },
              child: ReceitaHomeCard(receita: receita),
            ),
          );
        },
      );
    }

    return CustomScaffold(
      selectedIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, AppRoutes.HOME);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, AppRoutes.RECEITAS_MOSTRAR);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, AppRoutes.COMERCIO);
            break;
          case 3:
            _verificarLogin();
            break;
        }
      },
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildAppBar(),
                const SizedBox(height: 20),
                Text(
                  "Boas-vindas!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.redDefault,
                      ),
                ),
                const SizedBox(height: 20),
                buildSearchBar(context),
                const SizedBox(height: 20),
                _buildTagsSection(),

                // widget de Sugestões da IA
                _buildSugestoesIA(),

                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: _buildPromoBanner(),
                ),
                const SizedBox(height: 20),
                _buildReceitasEmAltaSection(context),
                const SizedBox(height: 10),
                buildReceitaList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: AppHeroTags.homeFab,
        onPressed: () async { 
          
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          
          final bool estaLogado = await authProvider.isLoggedIn();

          if (!mounted) return; 

          if (estaLogado) {
            print("Botão de IA da Home clicado! (Usuário Logado)");
            Navigator.pushNamed(context, AppRoutes.GERADOR_RECEITAS);
          } else {
            print("Botão de IA da Home clicado! (Bloqueado, mandando para login)");
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.LOGIN,
              (Route<dynamic> route) => false,
            );
          }
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Icon(Icons.auto_awesome, color: AppColors.redDefault),
      ),
    );
  }

  Widget _buildReceitasEmAltaSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Receitas para Você",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.greenDefault),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReceitaListScreen()),
            );
          },
          child: const Row(
            children: [
              Text(
                "Ver mais",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redDefault,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.redDefault,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo.png', height: 70),
      ],
    );
  }

  Widget _buildTagsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Text(
          "Filtros Ativos",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.redDefault,
          ),
        ),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 45, 
        child: Consumer<TagProvider>(
          builder: (context, tagProvider, child) {
            if (_isLoadingData) {
              return Center(child: CircularProgressIndicator());
            }

            final List<Tag> tagsAtivas = _selectedFilterTags.toList();

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              
              itemCount: tagsAtivas.length + 1,
              itemBuilder: (context, index) {
                
                if (index == tagsAtivas.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () {
                        // CHAMA O POP-UP
                        _showAddFilterModal(context, tagProvider);
                      },
                      child: CircleAvatar(
                        radius: 20, // Raio para caber na altura de 45
                        backgroundColor: AppColors.kBackgroundColor, // Cor de fundo
                        child: Icon(
                          Icons.add,
                          size: 25,
                          color: AppColors.greenLight, // Cor do ícone
                        ),
                      ),
                    ),
                  );
                }

                final tag = tagsAtivas[index];
                final ui =
                    tagUiDetails[tag.nome] ?? tagUiDetails['default']!;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      
                      _handleFilterTagClick(tag, true);
                    },
                    child: TagCard( 
                      label: tag.nome,
                      icon: ui['icon'] as IconData,
                      backgroundColor: ui['fg'], 
                      foregroundColor: ui['bg'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildPromoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset('assets/images/bannerHomeAD.png', fit: BoxFit.cover),
    );
  }

  // Mostra as sugestões da IA
  Widget _buildSugestoesIA() {
    // Se não houver sugestões, não mostra nada
    if (_sugestoesIA.isEmpty || _isLoadingData) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Text(
            "Sugestões para você",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.greenDefault,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _sugestoesIA.length,
            itemBuilder: (context, index) {
              final tagSugerida = _sugestoesIA[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  avatar: Icon(Icons.auto_awesome_outlined,
                      size: 18, color: AppColors.redDefault),
                  label: Text(
                    tagSugerida.nome,
                    style: TextStyle(
                        color: AppColors.redDefault,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: AppColors.orangeDefault.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: AppColors.orangeDefault),
                  ),
                  onPressed: () {
                    print("Usuário aceitou a sugestão: ${tagSugerida.nome}");
                    _handleFilterTagClick(tagSugerida, false);
                    setState(() {
                      _sugestoesIA.removeWhere((t) => t.id == tagSugerida.id);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  void _showAddFilterModal(BuildContext context, TagProvider tagProvider) {
  
  // Pega todas as tags que podem ser filtradas
  final List<String> filterableTagNames = [
    'Celíaco', 'Vegano', 'Vegetariano', 'Low Carb', 'Baixo Calorias',
    'Saudável', 'Fácil e Rápida', 'Diabético', 'Intolerante a Lactose',
    'Colesterol alto', 'Fitness', 'Rico em Fibras', 'Cetogenica', 'Alto proteína',
    'Alergia a Ovo', 'Alergia a Amendoim', 'Alergia a Peixe', 'Alergia a Soja',
    'Alergia a Nozes e Castanhas', 'Alergia a Frutos do Mar',
  ];
  final List<Tag> availableTags = tagProvider.items.where((tag) {
    bool isFilterable = filterableTagNames.contains(tag.nome);
    bool isAlreadySelected = _selectedFilterTags.any((t) => t.id == tag.id);
    return isFilterable && !isAlreadySelected;
  }).toList();

  availableTags.sort((a, b) => a.nome.compareTo(b.nome)); // Ordena

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) {

      return StatefulBuilder(
        builder: (context, modalSetState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adicionar Filtros",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.redDefault,
                      ),
                ),
                SizedBox(height: 15),

                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap( 
                      spacing: 8.0, 
                      runSpacing: 8.0,
                      children: availableTags.map((tag) {
                  
                        return TagChip(
                          tagName: tag.nome,
                          isSelected: false, 
                          onSelected: (bool _) {
                        
                            _handleFilterTagClick(tag, false);
                            
                            Navigator.pop(modalContext); 
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botão para fechar
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(modalContext);
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}
}