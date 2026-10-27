import 'package:flutter/material.dart';
import '../../models/comercio.dart';

class DetalhesOverlay extends StatelessWidget {
  final Comercio comercio;

  const DetalhesOverlay({
    super.key,
    required this.comercio,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // Altura inicial (40% da tela)
      minChildSize: 0.2,     // Altura mínima (20%)
      maxChildSize: 0.95,    // Altura máxima (quase tela cheia)
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController, // importante!
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador visual para arrastar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Nome
                Text(
                  comercio.nome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Tipo e Avaliação
                if (comercio.tipo != null || comercio.avaliacao != null)
                  Row(
                    children: [
                      if (comercio.tipo != null)
                        Text(
                          comercio.tipo!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      if (comercio.tipo != null && comercio.avaliacao != null)
                        const Text(' • ', style: TextStyle(color: Colors.grey)),
                      if (comercio.avaliacao != null)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            Text(
                              comercio.avaliacao!.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                    ],
                  ),

                const SizedBox(height: 8),

                // Localização
                Text(
                  comercio.localizacao,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 8),

                // Horário
                if (comercio.horarioFuncionamento != null)
                  Text(
                    'Horário: ${comercio.horarioFuncionamento!}',
                    style: const TextStyle(fontSize: 14),
                  ),

                const SizedBox(height: 8),

                // Descrição
                if (comercio.descricao != null &&
                    comercio.descricao!.trim().isNotEmpty)
                  Text(
                    comercio.descricao!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
