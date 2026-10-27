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
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/home/home_screen.dart';
import 'package:truecook/views/questionario/restricoes.dart';

// Modelo para representar cada meta
class Goal {
  final String title;
  final String image;

  Goal({required this.title, required this.image});
}

class QuestionarioPerfil extends StatefulWidget {
  const QuestionarioPerfil({super.key});

  @override
  _QuestionarioPerfilState createState() => _QuestionarioPerfilState();
}

class _QuestionarioPerfilState extends State<QuestionarioPerfil> {
  // Lista de todas as opções disponíveis
  final List<Goal> _allGoals = [
    Goal(
      title: 'Alimentar de forma segura',
      image: "assets/icons/Comida-Segura.png",
    ),
    Goal(
      title: 'Alimentar de forma saudável',
      image: "assets/icons/Comida-Saudavel.png",
    ),
    Goal(
      title: 'Descobrir novas receitas',
      image: "assets/icons/Buscando-Receitas.png",
    ),
    Goal(title: 'Alimentar de forma fitness', image: "assets/icons/Muscle.png"),
    Goal(
      title: 'Alimentação Vegana ou\nVegetariana',
      image: "assets/icons/Vegetariano.png",
    ),
  ];

  // Lista para armazenar as opções selecionadas pelo usuário
  final List<Goal> _selectedGoals = [];

  @override
  void initState() {
    super.initState();
    // Carrega a lista completa de tags em segundo plano
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TagProvider>(context, listen: false).carregarTags();
    });
  }

  // Função para construir cada card de seleção
  Widget _buildGoalCard(Goal goal) {
    final bool isSelected = _selectedGoals.contains(goal);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGoals.remove(goal);
          } else {
            _selectedGoals.add(goal);
          }
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shadowColor: AppColors.redDefault.withValues(),
        color: isSelected
            ? const Color.fromARGB(255, 241, 139, 43)
            : AppColors.orangeDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: isSelected
              ? const BorderSide(
                  color: Color.fromARGB(255, 226, 112, 36),
                  width: 3,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Image.asset(goal.image, width: 80),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  goal.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenDefault,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nos diga sobre você, o que busca em nosso aplicativo?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.redDefault,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Isso vai nos ajudar a recomendar conteúdos que fazem sentido para você.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),

                  // Lista de cards
                  ..._allGoals.map((goal) => _buildGoalCard(goal)),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.redDefault,
                              width: 2,
                            ),

                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: AppColors.redDefault,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: (){
                            print('Para tela inicial');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Pular',
                            style: TextStyle(color: AppColors.redDefault),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () async {
                            // 1. Pegue os providers
                            final tagProvider = Provider.of<TagProvider>(
                              context,
                              listen: false,
                            );
                            final userTagProvider =
                                Provider.of<UsuarioHasTagProvider>(
                                  context,
                                  listen: false,
                                );
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );

                          
                            final int? userId = await authProvider
                                .getLoggedUserId();
                           // final String? token = await authProvider
                             //   .getLoggedUserToken(); 

                            // Verificar se o usuário está logado
                            if (userId == null) {
                              print('Erro: Usuário não logado ou token nulo.');
                              // Opcional: mostrar snackbar de erro
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erro: Você não está logado.',
                                    ),
                                  ),
                                );
                              }
                              return; // Pare a execução
                            }

                            final selectedGoalTitles = _selectedGoals
                                .map((g) => g.title)
                                .toList();

                            final Map<String, List<String>> goalToTagMap = {
                              'Alimentar de forma saudável': [
                                'Saudável', 
                                'Rico em Fibras', 
                                'Baixa Caloria'
                              ],
                              'Descobrir novas receitas': [
                                'Fácil e Rápida'
                              ],
                              'Alimentar de forma fitness': [
                                'Alto proteína',
                                'Low Carb'
                              ],
                              'Alimentação Vegana ou\nVegetariana': [
                                'Vegano', 
                                'Vegetariano'
                              ],
                            };

                            final List<String> tagNamesToSave = [];
                            for (String goalTitle in selectedGoalTitles) {
                              if (goalToTagMap.containsKey(goalTitle)) {
                                tagNamesToSave.addAll(goalToTagMap[goalTitle]!);
                              }
                            }

                            final List<Tag> tagsToSave = tagProvider.items
                                .where(
                                  (tag) => tagNamesToSave.contains(tag.nome),
                                )
                                .toList();

                            // Salvar tags (COM O TOKEN)
                            try {
                              if (tagsToSave.isNotEmpty) {
                             
                                await userTagProvider.adicionarUserTagsQuest(
                                  userId,
                                  tagsToSave,
                                  //token, //
                                );
                                print(
                                  'Tags implícitas salvas: ${tagsToSave.map((t) => t.nome).toList()}',
                                );
                              }

                              if (!context.mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestricoesAlimentares(),
                                ),
                              );
                            } catch (e) {
                              print('Erro ao salvar tags implícitas: $e');
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
              ),
            ),
          ),
        ),
      );
  }
}
