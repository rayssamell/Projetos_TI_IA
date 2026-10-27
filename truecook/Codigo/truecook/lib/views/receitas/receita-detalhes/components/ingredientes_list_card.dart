import 'package:flutter/material.dart';
import 'package:truecook/models/ingrediente.dart';

class IngredientesListCard extends StatelessWidget {
  final List<Ingrediente> etapas;
  final String title;

  IngredientesListCard({required this.etapas, required this.title});

  @override
  Widget build(BuildContext context) {
    // Função auxiliar para criar a linha do ingrediente
    Widget _buildItem(int index, Ingrediente etapa) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$index. ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Text(
                etapa.nome,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          // LÓGICA CORRIGIDA:
          if (etapas.isEmpty)
            Text("Nada cadastrado", style: TextStyle(color: Colors.grey))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: etapas.asMap().entries.map((entry) {
                int index = entry.key + 1;
                Ingrediente item = entry.value;
                return _buildItem(index, item);
              }).toList(),
            ),
        ],
      ),
    );
  }
}