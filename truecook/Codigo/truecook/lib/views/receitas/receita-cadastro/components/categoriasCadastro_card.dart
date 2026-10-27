import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class CategoriasCadastroListCards extends StatefulWidget {
  final List<String> categoriasOptions;
  final List<String> categorias;

  const CategoriasCadastroListCards({super.key, 
    required this.categorias,
    required this.categoriasOptions,

  });

  @override
  State<CategoriasCadastroListCards> createState() =>
      _CategoriasCadastroListCardsState();
}

class _CategoriasCadastroListCardsState
    extends State<CategoriasCadastroListCards> {
  void _adicionarCategoria(String categoria) {
    if (!widget.categorias.contains(categoria)) {
      setState(() {
        widget.categorias.add(categoria);
      });
    }
  }

  Widget _CardCategoria({required String categoria}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purpleDefault,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        categoria,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildAddCategoriaButton(
    List<DropdownMenuItem<String>> dropdownItems,
  ) {
    return DropdownButton<String>(
      icon: const SizedBox.shrink(),
      focusColor: AppColors.orangeQuest,
      dropdownColor: AppColors.backgroundPrimary.withOpacity(0.5),
      underline: Container(),
      hint: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.purpleDefault,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "+",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      items: dropdownItems.map((item) {
        return DropdownMenuItem(
          value: item.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // muda cor ao passar o mouse (ou highlight em mobile)
              color: AppColors.purpleDefault.withOpacity(0.7),
            ),
            child: Text(
              item.value!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          _adicionarCategoria(value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcula os itens do dropdown sempre no build para pegar dados atualizados
    final dropdownItems = widget.categoriasOptions
        .map(
          (categoria) =>
              DropdownMenuItem(value: categoria, child: Text(categoria)),
        )
        .toList();

    return Container(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categorias",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5.0,
              runSpacing: 4.0,
              children: [
                // Mostra categorias selecionadas
                for (var categoria in widget.categorias)
                  _CardCategoria(categoria: categoria),
                // Botão dropdown para adicionar nova categoria
                _buildAddCategoriaButton(dropdownItems),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
