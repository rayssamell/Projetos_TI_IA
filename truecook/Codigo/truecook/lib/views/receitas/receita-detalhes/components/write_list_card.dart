import 'package:flutter/material.dart';

class ListwriteCard extends StatelessWidget {
  final dynamic etapas; // Pode ser String ou List<String>
  final String title;

  const ListwriteCard({super.key, required this.etapas, required this.title});

  Widget _Card(int index, String etapa) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        "$index. $etapa",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (etapas == null ||
        (etapas is String && etapas.isEmpty) ||
        (etapas is List && etapas.isEmpty)) {
      content = Text("Nada cadastrado");
    } else if (etapas is String) {
      content = Text(
        etapas,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      );
    } else if (etapas is List<String>) {
      content = ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: etapas.length,
        itemBuilder: (context, index) => _Card(index + 1, etapas[index]),
      );
    } else {
      content = Text("Formato de etapas inválido");
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content,
        ],
      ),
    );
  }
}
