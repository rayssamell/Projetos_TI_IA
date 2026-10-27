import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class PreparocadastroCard extends StatefulWidget {
  final List<String> etapas;
  final String title;

  const PreparocadastroCard({
    required this.etapas,
    required this.title,
    super.key,
  });

  @override
  State<PreparocadastroCard> createState() => _PreparocadastroCardState();
}

class _PreparocadastroCardState extends State<PreparocadastroCard> {
  final TextEditingController _controller = TextEditingController();

  void _adicionarPreparo(String etapa) {
    if (!widget.etapas.contains(etapa)) {
      setState(() {
        widget.etapas.add(etapa);
      });
    }
  }

  void _removerPreparo(String etapa) {
    setState(() {
      widget.etapas.remove(etapa);
    });
  }

  Widget _buildAddPreparo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: "Adicionar etapa de preparo",
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.purpleDefault,
            onPressed: () {
              final value = _controller.text.trim();
              if (value.isNotEmpty) {
                _adicionarPreparo(value);
                _controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _CardEtapa(int index, String etapa) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto da etapa
          Expanded(
            child: Text(
              "$index. $etapa",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          // Botão de remover
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () => _removerPreparo(etapa),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // título
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // campo de adicionar
          _buildAddPreparo(),
          // lista de etapas
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.etapas.length,
            itemBuilder: (context, index) =>
                _CardEtapa(index + 1, widget.etapas[index]),
          ),
        ],
      ),
    );
  }
}
