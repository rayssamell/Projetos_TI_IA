import 'dart:io';
import 'package:flutter/material.dart';

class ReceitaCadastroFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Campos do formulário
  String titulo = '';
  String descricao = '';
  String passoAPasso = '';
  String observacoes = '';
  int tempoPreparo = 0;
  File? imagem = null;
  List<String> categorias = [];
  List<String> ingredientes = [];

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setImagem(File file) {
    imagem = file;
    notifyListeners();
  }

  void toggleCategoria(String categoria) {
    if (categorias.contains(categoria)) {
      categorias.remove(categoria);
    } else {
      categorias.add(categoria);
    }
    notifyListeners();
  }
}
