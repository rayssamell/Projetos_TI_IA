import 'package:flutter/material.dart';

class MetricasSection extends StatelessWidget {
  final int visualizacoes;
  final int tempo;
  final double estrelas;

  const MetricasSection({super.key, 
    required this.visualizacoes,
    required this.tempo,
    required this.estrelas,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Visualizações
        SizedBox(
          width: 90,
          child: Column(
            children: [
              Icon(Icons.remove_red_eye_outlined, size: 30),
              SizedBox(height: 4),
              Text(
                visualizacoes.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Tempo
        SizedBox(
          width: 90,
          child: Column(
            children: [
              Icon(Icons.timer_outlined, size: 30),
              SizedBox(height: 4),
              Text(
                "${tempo.toString()} min",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Estrelas
        SizedBox(
          width: 90,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    estrelas >= 1 ? Icons.star : Icons.star_border,
                    color: estrelas >= 1 ? Colors.orange : Colors.orange,
                    size: 18,
                  ),
                  Icon(
                    estrelas >= 2 ? Icons.star : Icons.star_border,
                    color: estrelas >= 2 ? Colors.orange : Colors.orange,
                    size: 18,
                  ),
                  Icon(
                    estrelas >= 3 ? Icons.star : Icons.star_border,
                    color: estrelas >= 3 ? Colors.orange : Colors.orange,
                    size: 18,
                  ),
                  Icon(
                    estrelas >= 4 ? Icons.star : Icons.star_border,
                    color: estrelas >= 4 ? Colors.orange : Colors.orange,
                    size: 18,
                  ),
                  Icon(
                    estrelas >= 5 ? Icons.star : Icons.star_border,
                    color: estrelas >= 5 ? Colors.orange : Colors.orange,
                    size: 18,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "${estrelas.toString()}/5",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
