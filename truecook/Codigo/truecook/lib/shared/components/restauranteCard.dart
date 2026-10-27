// lib/shared/components/restaurante_card.dart

import 'package:flutter/material.dart';
import '../../models/comercio.dart';

class RestauranteCard extends StatelessWidget {
  final Comercio restaurante;
  final VoidCallback? onLocationTap; // Para o ícone de localização
  final VoidCallback? onDetailsTap; // Para o clique no card
  
  // --- PARÂMETRO ADICIONADO ---
  final String? distancia; // Recebe o "1.2 km" da tela

  const RestauranteCard({
    super.key,
    required this.restaurante,
    this.onLocationTap,
    this.onDetailsTap,
    this.distancia, // --- PARÂMETRO ADICIONADO ---
  });

  @override
  Widget build(BuildContext context) {
    // Lógica da imagem para evitar erro com 'null'
    ImageProvider? backgroundImage;
    if (restaurante.foto != null && restaurante.foto!.isNotEmpty) {
      backgroundImage = NetworkImage(restaurante.foto!);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: backgroundImage,
          backgroundColor: Colors.grey[300], // Usa a imagem processada
          child: (backgroundImage == null) ? const Icon(Icons.restaurant, color: Colors.white) : null, // Cor de fundo para o ícone
        ),
        title: Text(
          restaurante.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2, // Evita quebra de layout com nomes longos
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AVALIAÇÃO ---
            if (restaurante.avaliacao != null && restaurante.avaliacao! > 0)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(restaurante.avaliacao.toString()),
                ],
              ),
            
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                // Usa a variável 'distancia' que veio do construtor
                Text(
                  distancia ?? '...', // Mostra '...' enquanto calcula
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        // O trailing agora é o IconButton com a ação onLocationTap
        trailing: IconButton(
          icon: const Icon(Icons.map_outlined, color: Colors.orange, size: 30),
          onPressed: onLocationTap, // <-- Chama a função do ícone
        ),
        onTap: onDetailsTap, // <-- Chama a função de detalhes
      ),
    );
  }
}