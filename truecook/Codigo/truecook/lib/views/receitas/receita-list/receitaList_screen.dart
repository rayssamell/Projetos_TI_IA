// lib/receitalistScreen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/components/custom_Scaffold.dart';
import 'package:truecook/shared/components/receitaHome_card.dart';
import 'package:truecook/shared/enums/heroTags.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/shared/utils/auth.dart';

// ALTERAÇÃO 1: Convertido para StatefulWidget para gerenciar o estado da navbar.
class ReceitaListScreen extends StatefulWidget {
  const ReceitaListScreen({super.key});

  @override
  State<ReceitaListScreen> createState() => _ReceitaListScreenState();
}

class _ReceitaListScreenState extends State<ReceitaListScreen> {
  Future<void> isLoggedVerify(VoidCallback action) async {
    isLoggedIn(action, context, mounted);
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    final receitaProvider = Provider.of<ReceitaProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return CustomScaffold(
      selectedIndex: 1,
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
            Navigator.pushReplacementNamed(context, AppRoutes.PERFIL);
            break;
        }
      },
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'O que você quer comer?',
                    hintStyle: GoogleFonts.poppins(color: AppColors.redDefault),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.redDefault,
                    ),
                    suffixIcon: const Icon(
                      Icons.filter_list,
                      color: AppColors.redDefault,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.redDefault,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.redDefault,
                        width: 3.0,
                      ),
                    ),
                  ),
                  onChanged: (query) => receitaProvider.buscarReceitas(query),
                ),
                const SizedBox(height: 24),
                Text(
                  'Receitas em Destaque',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.purpleDefault,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: receitaProvider.filteredItems.length,
                  itemBuilder: (context, index) {
                    var receita = receitaProvider.filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          print("Card clicado: ${receita.titulo}");
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            navigator.pushNamed(
                              AppRoutes.RECEITAS_DETALHES,
                              arguments: receita,
                            );
                          },
                          child: ReceitaHomeCard(
                            receita: receitaProvider.filteredItems[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: AppHeroTags.receitas2Fab,
            onPressed: () {
              isLoggedVerify(() {
                navigator.pushNamed(AppRoutes.RECEITAS_CADASTRO);
              });
            },
            backgroundColor: const Color(0xFFE85D4A),
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: AppHeroTags.receitasFab,
            onPressed: () {
              navigator.pushNamed(AppRoutes.GERADOR_RECEITAS);
            },
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            child: Icon(Icons.auto_awesome, color: AppColors.redDefault),
          ),
        ],
      ),
    );
  }

  // Método para construir a barra do topo com a logo
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Image.asset('assets/images/logo.png', height: 70),
        const Icon(Icons.person_outline, color: Colors.black54, size: 28),
      ],
    );
  }
}
