import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

/// Tela de Detalhes de Receita.
/// - Mostra ingredientes, preparo e comentários.
/// - Permite favoritar, curtir e comentar.

class topBarReceita extends StatelessWidget {
  const topBarReceita(BuildContext context, {super.key});

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundPrimary,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        color: Colors.black,
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Detalhes da Receita",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            // ação do botão perfil
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: AppColors.backgroundPrimary, height: 1.0),
      ),
    );
  }
}
