import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/provider/igredientes_provider.dart';

class IgredientescadastroCard extends StatefulWidget {
  final List<Ingrediente> igredientes;
  final String title;

  const IgredientescadastroCard({
    required this.igredientes,
    required this.title,
    super.key,
  });

  @override
  State<IgredientescadastroCard> createState() =>
      _IgredientescadastroCardState();
}

class _IgredientescadastroCardState extends State<IgredientescadastroCard> {
  @override
  void initState() {
    super.initState();
    Provider.of<IngredientesProvider>(context, listen: false).carregarTodos();
  }

  Ingrediente? _ingredienteSelecionado;

  void _adicionarIngrediente(Ingrediente ingrediente) {
    if (!widget.igredientes.contains(ingrediente)) {
      setState(() {
        widget.igredientes.add(ingrediente);
      });
    }
  }

  void _removerIngrediente(Ingrediente ingrediente) {
    setState(() {
      widget.igredientes.remove(ingrediente);
    });
  }

  Widget _CardIngrediente(int index, Ingrediente ingrediente) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$index. ${ingrediente.nome}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
            onPressed: () => _removerIngrediente(ingrediente),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientesProvider = Provider.of<IngredientesProvider>(context);
    final List<Ingrediente> ingredientesDisponiveis =
        ingredientesProvider.items;

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

          // dropdown para selecionar ingrediente existente
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: DropdownButtonFormField<Ingrediente>(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Selecionar ingrediente",
              ),
              initialValue: _ingredienteSelecionado,
              items: ingredientesDisponiveis
                  .map((i) => DropdownMenuItem(value: i, child: Text(i.nome)))
                  .toList(),
              onChanged: (ingrediente) {
                if (ingrediente != null) {
                  _adicionarIngrediente(ingrediente);
                  setState(() => _ingredienteSelecionado = null);
                }
              },
            ),
          ),

          // lista de ingredientes adicionados
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.igredientes.length,
            itemBuilder: (context, index) =>
                _CardIngrediente(index + 1, widget.igredientes[index]),
          ),
        ],
      ),
    );
  }
}
