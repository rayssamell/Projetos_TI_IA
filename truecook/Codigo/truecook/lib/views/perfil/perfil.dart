import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/models/usuario.dart';
import 'package:truecook/views/home/components/tagChip.dart';
import 'package:truecook/views/perfil/components/tag_card.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/provider/user_provider.dart';
import 'package:truecook/provider/usuario_has_tag_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/shared/components/custom_Scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     _carregarDadosDoPerfil(recarregarDoBanco: true);
    });
  }

  Future<void> _carregarDadosDoPerfil({bool recarregarDoBanco = true}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final receitaProvider = Provider.of<ReceitaProvider>(context, listen: false);
    final userTagProvider = Provider.of<UsuarioHasTagProvider>(context, listen: false);
    final tagProvider = Provider.of<TagProvider>(context, listen: false);

    try {
      final int? userId = await authProvider.getLoggedUserId();
      if (userId != null) {
        
        if (recarregarDoBanco) {
          print("🔄 Buscando dados do servidor...");
          await userProvider.carregarPerfilUsuario(userId);
          await receitaProvider.carregarReceitasFavoritas(userId);
          await receitaProvider.carregarReceitasPorUsuario(userId);
          await tagProvider.carregarTags();
          await userTagProvider.carregarTagsPorUsuario(userId);
        } else {
          print("✨ Usando dados locais atualizados...");
        }
    
        final List<int> tagIds = userTagProvider.items
            .map((usuarioTag) => usuarioTag.tag_id)
            .toList();

        print("IDs ativos para exibir: $tagIds");

        if (tagIds.isNotEmpty) {
          await tagProvider.carregarTagsPorIds(tagIds);
        } else {
          await tagProvider.carregarTagsPorIds([]); 
        }

      } else {
        userProvider.setError("Usuário não está logado.");
      }
    } catch (e) {
      print("Erro no perfil: $e");
      userProvider.setError("Erro: $e");
    }
  }

  void _fazerLogout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.LOGIN,
      (Route<dynamic> route) => false,
    );
  }

  // Função para deletar tag com confirmação
  Future<void> _removerTag(int userId, Tag tag) async {
    final userTagProvider = Provider.of<UsuarioHasTagProvider>(context, listen: false);
    final tagProvider = Provider.of<TagProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remover Tag"),
        content: Text("Deseja remover '${tag.nome}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Remover", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {

        await userTagProvider.deletarTag(userId, tag.id!);

        final tagsAtuais = tagProvider.tagsDoUsuario;

        final novosIds = tagsAtuais
            .where((t) => t.id != tag.id) 
            .map((t) => t.id!)
            .toList();

        await tagProvider.carregarTagsPorIds(novosIds);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${tag.nome} removido!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
    }
  }
  
  void _onItemTapped(int index) {
    final NavigatorState navigator = Navigator.of(context);

    if (index == _selectedIndex) {
      return;
    }

    if (index == 0) {
      navigator.pushReplacementNamed(AppRoutes.HOME);
    } else if (index == 1) {
      navigator.pushReplacementNamed(AppRoutes.RECEITAS_MOSTRAR);
    } else if (index == 2) {
      navigator.pushReplacementNamed(AppRoutes.COMERCIO);
    } else if (index == 3) {
      navigator.pushReplacementNamed(AppRoutes.PERFIL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final usuario = userProvider.usuarioSelecionado;

        if (userProvider.isLoading && usuario == null) {
          return const Scaffold(
            backgroundColor: AppColors.kPrimaryColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (userProvider.hasError && usuario == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            body: Center(
              child: Text(
                'Erro ao carregar perfil: ${userProvider.errorMessage}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (usuario == null) {
          return const Scaffold(
            backgroundColor: AppColors.kPrimaryColor,
            body: Center(child: Text('Usuário não encontrado.')),
          );
        }

        return DefaultTabController(
          length: 3,
          child: CustomScaffold(
            body: SafeArea(
              child: Column(
                children: [
                  _buildProfileHeader(context, usuario),
                  _buildTabBar(),
                  Expanded(
                    child: Container(
                      color: AppColors.backgroundPrimary,
                      child: TabBarView(
                        children: [
                          // --- ABA 1: FAVORITOS ---
                          Consumer<ReceitaProvider>(
                            builder: (context, receitaProvider, child) {
                              final favoritas =
                                  receitaProvider.receitasFavoritas;
                              if (favoritas.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Nenhuma receita favorita ainda.',
                                    style: TextStyle(
                                      color: AppColors.kTextColor,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: favoritas.length,
                                itemBuilder: (ctx, index) {
                                  final receita = favoritas[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        receita.titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        receita.descricao ?? 'Sem descrição',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: const Icon(
                                        Icons.restaurant_menu,
                                        color: AppColors.kPrimaryColor,
                                      ), // Ícone na frente
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.RECEITAS_DETALHES,
                                          arguments: receita,
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // --- ABA 2: MINHAS RECEITAS ---
                          Consumer<ReceitaProvider>(
                            builder: (context, receitaProvider, child) {
                              final minhasReceitas = receitaProvider.items;
                              if (receitaProvider.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors
                                        .kPrimaryColor, // Cor do indicador
                                  ),
                                );
                              }
                              if (minhasReceitas.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Você ainda não criou nenhuma receita.',
                                    style: TextStyle(
                                      color: AppColors.kTextColor,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: minhasReceitas.length,
                                itemBuilder: (ctx, index) {
                                  final receita = minhasReceitas[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        receita.titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        receita.descricao ?? 'Sem descrição',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: const Icon(
                                        Icons.receipt_long,
                                        color: AppColors.kPrimaryColor,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // --- ABA 3: LOCAIS SALVOS ---
                          const Center(
                            child: Text(
                              'Nenhum local salvo ainda.',
                              style: TextStyle(color: AppColors.kTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

 Widget _buildProfileHeader(BuildContext context, Usuario usuario) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: AppColors.backgroundPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Sair"),
                    content: const Text("Tem certeza que deseja sair da conta?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); 
                          _fazerLogout(); 
                        },
                        child: const Text("Sair", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.redDefault),
              tooltip: 'Sair da conta',
            ),
          ),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.kIconColor,
                  backgroundImage: usuario.foto != null
                      ? NetworkImage(usuario.foto!)
                      : null,
                  child: usuario.foto == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.backgroundPrimary,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.redDefault,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showEditProfilePopup(context, usuario);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.allWhite,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  usuario.nome,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  usuario.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.kEmailColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Suas Tags',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.kTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<TagProvider>(
            builder: (context, tagProvider, child) {
              final List<Tag> userTags = tagProvider.tagsDoUsuario;
               if (userTags.isEmpty) {
                return const Text(
                  'Nenhuma tag selecionada.',
                  style: TextStyle(color: AppColors.kEmailColor),
                );
              }
              return SizedBox(
                height: 45.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Botão de Adicionar (ícone +)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () => _showAddTagsPopup(context, usuario.id!),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.kBackgroundColor,
                          child: Icon(Icons.add, size: 25, color: AppColors.greenLight),
                        ),
                      ),
                    ),

                    // Lista das Tags do Usuário
                    ...userTags.map((tag) {
                      final ui = tagUiDetails[tag.nome] ?? tagUiDetails['default']!;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onLongPress: () {
                            _removerTag(usuario.id!, tag);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: TagCard(
                            label: tag.nome,
                            icon: ui['icon'] as IconData,
                            backgroundColor: ui['fg'],
                            foregroundColor: ui['bg'],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color:
          AppColors.backgroundPrimary, 
      child: TabBar(
        // ALTERAÇÃO: Cores das abas
        labelColor:
            AppColors.kPrimaryColor, 
        unselectedLabelColor:
            AppColors.kTextColor, 
        indicatorColor: AppColors.kPrimaryColor,
        indicatorWeight: 3.0,
        tabs: const [
          Tab(icon: Icon(Icons.push_pin_outlined)),
          Tab(icon: Icon(Icons.receipt_long_outlined)),
          Tab(icon: Icon(Icons.location_on_outlined)),
        ],
      ),
    );
  }

  void _showEditProfilePopup(BuildContext context, Usuario usuario) {
    final nameController = TextEditingController(text: usuario.nome);
    final telefoneController = TextEditingController(text: usuario.telefone);
    final enderecoController = TextEditingController(text: usuario.endereco);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Editar Perfil', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.kIconColor,
                      backgroundImage: usuario.foto != null
                          ? NetworkImage(usuario.foto!)
                          : null,
                      child: usuario.foto == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.backgroundPrimary,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementar lógica de upload/seleção de foto
                        },
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.kPrimaryColor,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const Divider(height: 24, thickness: 1),
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha Atual',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nova Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.kPrimaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
              ),
              child: const Text('Salvar'),
              onPressed: () {
                final usuarioAtualizado = usuario.copyWith(
                  nome: nameController.text,
                  telefone: telefoneController.text.isNotEmpty
                      ? telefoneController.text
                      : null,
                  endereco: enderecoController.text.isNotEmpty
                      ? enderecoController.text
                      : null,
                );
                userProvider.atualizarUsuario(usuarioAtualizado);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTagsPopup(BuildContext context, int userId) {
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    final usuarioTagProvider = Provider.of<UsuarioHasTagProvider>(context, listen: false);

    List<Tag> getTagsDisponiveis() {
      final allTags = tagProvider.items;
      final userTags = tagProvider.tagsDoUsuario;
      final userTagIds = userTags.map((t) => t.id).toSet();
      return allTags.where((tag) => !userTagIds.contains(tag.id)).toList();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, popupSetState) {
            final availableTags = getTagsDisponiveis();

            return AlertDialog(
              title: const Text('Adicionar Novas Tags'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: availableTags.isEmpty
                    ? const Center(child: Text("Você já possui todas as tags!"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: availableTags.length,
                        itemBuilder: (context, index) {
                          final tag = availableTags[index];
                        
                          final ui = tagUiDetails[tag.nome] ?? tagUiDetails['default']!;

                          return ListTile(
                            leading: Icon(ui['icon'], color: AppColors.kPrimaryColor),
                            title: Text(tag.nome),
                            trailing: const Icon(Icons.add_circle_outline, color: AppColors.greenDefault),
                            onTap: () async {
                             
                              await usuarioTagProvider.adicionarUsuarioTag(userId, tag.id!);
                              
                              final tagsAtuais = tagProvider.tagsDoUsuario;
                              final novosIds = tagsAtuais.map((t) => t.id!).toList();
                              
                              novosIds.add(tag.id!);
                              
                              await tagProvider.carregarTagsPorIds(novosIds);
                              
                              popupSetState(() {});
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  child: const Text('Concluir', style: TextStyle(color: AppColors.kPrimaryColor)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
