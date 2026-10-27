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
import 'package:truecook/views/questionario/alergias.dart';

class RestricoesAlimentares extends StatefulWidget {
  const RestricoesAlimentares({super.key});

  @override
  _RestricoesAlimentaresState createState() => _RestricoesAlimentaresState();
}

class _RestricoesAlimentaresState extends State<RestricoesAlimentares> {
  // Lista de todas as opções disponíveis
  final Map<String, String> _tagImages = {
    'Celíaco': "assets/icons/1-Celiaco.png",
    'Intolerante a Lactose': "assets/icons/2-Int-Lactose.png",
    'Diabético': "assets/icons/3-Diabetes.png",
    'Colesterol Alto': "assets/icons/4-Colesterol.png",
    'Alergias': "assets/icons/5-Alergias.png",
    'Vegetariano': "assets/icons/6-Vegetariano.png",
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

                //Tags para esta tela
                final List<String> nomesTagsPrincipais = [
                  'Celíaco',
                  'Intolerante a Lactose',
                  'Diabético',
                  'Colesterol Alto',
                  'Vegetariano',
                  'Alergias',
                ];

                final List<Tag> tagsParaMostrar = tagProvider.items
                    .where((tag) => nomesTagsPrincipais.contains(tag.nome))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Você possui alguma restrição alimentar?',
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
                              //  Pega o ID do usuário
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final int? userId = await authProvider.getLoggedUserId();

                              final bool vaiParaAlergias = _selectedTags.any(
                                (tag) => tag.nome == 'Alergias',
                              );

                              final List<Tag> tagsParaSalvar = _selectedTags
                                  .where((tag) => tag.nome != 'Alergias')
                                  .toList();


                              try {
                                
                                if (tagsParaSalvar.isNotEmpty && userId != null) {
                                  await Provider.of<UsuarioHasTagProvider>(
                                    context,
                                    listen: false,
                                  ).adicionarUserTagsQuest(
                                    userId,
                                    tagsParaSalvar, 
                                  );
                                }

                                if (!context.mounted) return;

                                if (vaiParaAlergias) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => Alergias(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.HOME);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao salvar: ${e.toString()}',
                                      ),
                                    ),
                                  );
                                }
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
