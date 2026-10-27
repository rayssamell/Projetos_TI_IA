import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class ObervacoescadastroCard extends StatefulWidget {
  final List<String> obserrvacoes;
  final String title;

  const ObervacoescadastroCard({
    required this.obserrvacoes,
    required this.title,
    super.key,
  });

  @override
  State<ObervacoescadastroCard> createState() => _ObervacoescadastroCardState();
}

class _ObervacoescadastroCardState extends State<ObervacoescadastroCard> {
  final TextEditingController _controller = TextEditingController();

  void _adicionarObservacao(String obs) {
    if (!widget.obserrvacoes.contains(obs)) {
      setState(() {
        widget.obserrvacoes.add(obs);
      });
    }
  }

  void _removerObservacao(String obs) {
    setState(() {
      widget.obserrvacoes.remove(obs);
    });
  }

  Widget _buildAddObservacao() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: "Adicionar observação",
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.purpleDefault,
            onPressed: () {
              final value = _controller.text.trim();
              if (value.isNotEmpty) {
                _adicionarObservacao(value);
                _controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _CardObservacao(int index, String obs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto da observação
          Expanded(
            child: Text(
              "$index. $obs",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          // Botão de remover
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () => _removerObservacao(obs),
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
          _buildAddObservacao(),
          // lista de observações
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.obserrvacoes.length,
            itemBuilder: (context, index) =>
                _CardObservacao(index + 1, widget.obserrvacoes[index]),
          ),
        ],
      ),
    );
  }
}
