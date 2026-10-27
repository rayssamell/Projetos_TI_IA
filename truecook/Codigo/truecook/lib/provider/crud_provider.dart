import 'package:flutter/foundation.dart';
import 'package:truecook/data/repositories/crud_repository.dart';

class CrudProvider<T, typeRepository extends CrudRespository<T>> with ChangeNotifier {
  final typeRepository repository;

  CrudProvider(this.repository);

  // Estado geral
  List<T> items = [];
  List<T> filteredItems = [];
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;


  // Métodos genéricos
  Future<void> carregarTodos() async {
    _setLoading(true);
    try {
      items = await repository.findAll();
      filteredItems = items;
      _setLoading(false);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> adicionar(T item) async {
    try {
      print(await repository.insert(item));
      await carregarTodos();
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> atualizar(T item) async {
    try {
      await repository.update(item);
      await carregarTodos();
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> deletar(int id) async {
    try {
      await repository.delete(id);
      items.removeWhere((i) => getItemId(i) == id);
      filteredItems = items;
      notifyListeners();
    } catch (e) {
      _setError(e);
    }
  }

  Future<T?> buscarPorId(int id) async {
    try {
      return await repository.findById(id);
    } catch (e) {
      _setError(e);
      return null;
    }
  }

  // Métodos utilitários
  void filtrar(bool Function(T) predicate) {
    filteredItems = items.where(predicate).toList();
    notifyListeners();
  }

  void limparFiltros() {
    filteredItems = items;
    notifyListeners();
  }

  void limparErro() {
    hasError = false;
    errorMessage = null;
    notifyListeners();
  }

  // Métodos internos auxiliares
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(Object e) {
    isLoading = false;
    hasError = true;
    errorMessage = e.toString();
    notifyListeners();
  }

  // Cada provider concreto precisa dizer como pegar o ID de um item
  int getItemId(T item) {
    throw UnimplementedError();
  }
}
