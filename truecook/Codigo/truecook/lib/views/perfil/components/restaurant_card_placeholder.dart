// ARQUIVO: restaurant_card_placeholder.dart

import 'package:flutter/material.dart';

// --- Constantes de Cor (baseado na imagem) ---
const kBackgroundColor = Color(0xFFFBF3E0); // Cor do texto e ícones

class RestaurantCardPlaceholder extends StatelessWidget {
  final String title;
  final String distance;
  final int rating; // Rating de 1 a 5

  const RestaurantCardPlaceholder({
    super.key,
    required this.title,
    required this.distance,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo do Restaurante
        const CircleAvatar(
          radius: 30,
          backgroundColor: kBackgroundColor,
          child: Icon(Icons.store, color: Color(0xFF6D4C41), size: 30),
          // backgroundImage: NetworkImage('URL_DO_LOGO'),
        ),
        const SizedBox(width: 16),

        // Infos do Restaurante
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kBackgroundColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 14,
                  color: kBackgroundColor,
                ),
              ),
            ],
          ),
        ),

        // Ícone de Salvar/Pin
        const Icon(
          Icons.push_pin,
          color: kBackgroundColor,
          size: 28,
        ),
      ],
    );
  }
}