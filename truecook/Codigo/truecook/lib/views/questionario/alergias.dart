/// Tela de Questionário.
/// - Coleta preferências e restrições alimentares do usuário.
/// - Ajuda a personalizar recomendações futuras.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/provider/usuario_has_tag_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';

class Alergias extends StatefulWidget {
  const Alergias({super.key});

  @override
  _AlergiasState createState() => _AlergiasState();
}

class _AlergiasState extends State<Alergias> {
  // Lista de todas as opções disponíveis
  final Map<String, String> _tagImages = {
    'Alergia a Amendoim': "assets/icons/Alergia-Amendoim.png",
    'Alergia a Frutos do Mar': "assets/icons/Alergia-Frutos-do-Mar.png",
    'Alergia a Peixe': "assets/icons/Alergia-Peixe.png",
    'Alergia a Ovo': "assets/icons/Alergia-Ovo.png",
    'Alergia a Soja': "assets/icons/Alergia-Soja.png",
    'Alergia a Nozes e Castanhas': "assets/icons/Alergia-Nozes.png",
  };

  final List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TagProvider>(context, listen: false).carregarTags();
    });
  }

  // Função para construir cada card de seleção
  Widget _buildGoalCard(Tag tag) {
    final bool isSelected = _selectedTags.contains(tag);

    // pegar imagem correspondente usando o Map
    final imagePath = _tagImages[tag.nome] ?? "assets/icons/default.png";

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTags.remove(tag);
          } else {
            _selectedTags.add(tag);
          }
        });
      },
      child: Card(
        elevation: isSelected ? 6 : 4,
        color: isSelected
            ? const Color.fromARGB(255, 241, 139, 43)
            : AppColors.orangeDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(
                  color: Color.fromARGB(255, 226, 112, 36),
                  width: 3,
                )
              : BorderSide.none,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // calcula tamanhos relativos ao espaço disponível do card
            final availableWidth = constraints.maxWidth;
            final imageSize = (availableWidth * 0.45).clamp(40.0, 85.0);
            final fontSize = (availableWidth / 10).clamp(12.0, 16.0);

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tag.nome,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenDefault,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // largura desejada por item
    const desiredItemMaxWidth = 180.0;
    final availableWidth = screenWidth - (20.0 * 2);
    // calcula quantas colunas cabem (mín 1, máx 3)
    int crossAxisCount = (availableWidth / desiredItemMaxWidth).floor();
    if (crossAxisCount < 1) crossAxisCount = 1;
    if (crossAxisCount > 3) crossAxisCount = 3;

    // ajusta proporção do card com base no itemWidth estimado
    final spacing = 16.0;
    final itemWidth =
        (availableWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
    // estimativa de altura (imagem + texto);
    final itemHeight = itemWidth * 1.0 + 20;
    final childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
        title: SizedBox(
          width: 80,
          child: Image.asset('assets/images/logo.png'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<TagProvider>(
              builder: (context, tagProvider, child) {
                if (tagProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tagProvider.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar tags: ${tagProvider.errorMessage}',
                    ),
                  );
                }

                final List<String> nomesTagsAlergias = [
                  'Alergia a Amendoim',
                  'Alergia a Frutos do Mar',
                  'Alergia a Peixe',
                  'Alergia a Ovo',
                  'Alergia a Soja',
                  'Alergia a Nozes e Castanhas',
                ];

                final List<Tag> tagsParaMostrar = tagProvider.items
                    .where((tag) => nomesTagsAlergias.contains(tag.nome))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Você possui alergia a algum desses itens?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.redDefault,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Se sim, marque todas que se aplicam a você.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    //Cards
                    GridView.builder(
                      itemCount: tagsParaMostrar.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        // pegue 'tag' do provider
                        final tag = tagsParaMostrar[index];
                        return _buildGoalCard(tag);
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: AppColors.redDefault,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: BorderSide(
                                color: AppColors.redDefault,
                                width: 2,
                              ),
                            ),
                            onPressed: () {
                              // ação pular
                              Navigator.of(context).pushNamed(AppRoutes.HOME);
                            },
                            child: Text(
                              'Pular',
                              style: TextStyle(color: AppColors.redDefault),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: () async {
                              //tester id user
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final int? userId = await authProvider.getLoggedUserId();
                              try {
                                if (_selectedTags.isNotEmpty && userId != null) { 
                                  await Provider.of<UsuarioHasTagProvider>(
                                    context,
                                    listen: false,
                                  ).adicionarUserTagsQuest(
                                    userId,
                                    _selectedTags,
                                  );
                                }
                              } catch (e) {
                                print('🌱 Erro ao salvar UsuarioTag: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao salvar alergias: ${e.toString()}',
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }

                              print(
                                'Selecionados: ${_selectedTags.map((g) => g.nome).toList()}',
                              );

                              // Navega para a HOME
                              if (context.mounted) {
                                Navigator.of(context).pushNamed(AppRoutes.HOME);
                              }
                            },
                            child: const Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
