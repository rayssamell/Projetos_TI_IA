/// ReceitaHome_card.
/// - Exibe uma receita no formato de card na tela de home.
/// - Layout moderno com imagem em destaque, título e avaliação.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/shared/utils/constants.dart';

// O widget ReceitaHomeCard representa um cartão de receita na tela inicial.
// Ele foi redesenhado para ter um apelo visual maior, com a imagem em destaque.
class ReceitaHomeCard extends StatelessWidget {
  final Receita receita;
  // final String imagePath; // O caminho da imagem da receita.
  // final String title; // O titulo da receita.
  // final double rating; // A classificacao da receita (0.0 a 5.0).
  // final List<String> tags; // A lista de tags da receita.

  const ReceitaHomeCard({
    super.key,
    required this.receita,
    // required this.imagePath,
    // required this.title,
    // required this.rating,
    // required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Usamos um Container externo para aplicar a margem e a sombra
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.backgroundPrimary)],
      ),
      // O Card interno gerencia o conteúdo e o corte da imagem
      child: Card(
        clipBehavior: Clip
            .antiAlias, // Garante que a imagem respeite as bordas arredondadas
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da receita em destaque
            Image.network(
              receita.imagem ?? '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Widget de erro caso a imagem não carregue
                return Container(
                  height: 150,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
            // Padding para os detalhes da receita
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna expandida para o texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titulo da receita com fonte customizada
                        Text(
                          receita.titulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.redDefault,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tags da receita
                        Text(
                          // receita.tags.join(', '),
                          receita.tags.map((t) => t.nome).join(', '),
                          style: GoogleFonts.poppins(
                            color: AppColors.purpleDefault,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Classificacao por estrelas
                        Row(
                          children: [
                            _estrela(receita.avaliacoes, 1.0),
                            _estrela(receita.avaliacoes, 2.0),
                            _estrela(receita.avaliacoes, 3.0),
                            _estrela(receita.avaliacoes, 4.0),
                            _estrela(receita.avaliacoes, 5.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Icone de seta mais sutil
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.redDefault,
                    size: 21,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _estrela(double avaliacao, double parametro) {
  return Icon(
    avaliacao >= parametro ? Icons.star : Icons.star_border,
    color: avaliacao >= parametro ? Colors.orange : Colors.orange,
    size: 20,
  );
}
