/// ReceitaHome_card.
/// - Exibe uma receita no formato de card na tela de home.
/// - Inclui imagem, título e avaliação.
library;

import 'package:flutter/material.dart';

// O widget TagCard representa um botão de tag com um icone e um texto.
// Ele é reutilizável para a se\u00E7\u00E3o "Escolha por tags".
class TagCard extends StatelessWidget {
  final IconData icon; // O \u00EDcone a ser exibido na tag.
  final String label; // O texto da tag.
  final Color backgroundColor; // A cor de fundo da tag.
  final Color foregroundColor; // A cor do \u00EDcone e do texto.

  const TagCard({
    super.key,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
