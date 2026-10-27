import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class CategoriasListCards extends StatelessWidget {

  final List<String> categorias;

  const CategoriasListCards({super.key, required this.categorias});

  Widget _CardCategoria(String categoria) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: SizedBox(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categorias",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Wrap(
                spacing: 5.0,
                runSpacing: 4.0,
                children: [
                  for(var categoria in categorias)
                  _CardCategoria(categoria),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
