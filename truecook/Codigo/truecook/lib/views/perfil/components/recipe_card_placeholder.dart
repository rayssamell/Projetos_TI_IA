// ARQUIVO: recipe_card_placeholder.dart
// (Este é um placeholder. Substitua pelo seu card real)

import 'package:flutter/material.dart';

// --- Constantes de Cor (baseado na imagem) ---
const kCardColor = Color(0xFFFCAE7C);
const kTextColor = Color(0xFF3E2723);

class RecipeCardPlaceholder extends StatelessWidget {
  final String title;
  final String rating;
  final String tags;

  const RecipeCardPlaceholder({
    super.key,
    required this.title,
    required this.rating,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Imagem da Receita
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade400, // Placeholder de imagem
            ),
            child: const Icon(Icons.image, color: Colors.white, size: 40),
            // Substitua por:
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(8.0),
            //   child: Image.network('URL_DA_IMAGEM', fit: BoxFit.cover),
            // ),
          ),
          const SizedBox(width: 12),

          // Informações da Receita
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(fontSize: 12, color: kTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tags,
                  style: TextStyle(fontSize: 12, color: kTextColor.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Seta
          const Icon(
            Icons.arrow_forward_ios,
            color: kTextColor,
            size: 18,
          ),
        ],
      ),
    );
  }
}