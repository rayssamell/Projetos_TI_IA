import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:truecook/models/tag.dart';
import 'package:truecook/models/usuario_has_tag.dart';

class UsuarioHasTagProvider with ChangeNotifier {

  final String _getTagsUrl =
      'https://us-central1-truecook-dev.cloudfunctions.net/get_user_tags';
  final String _addBatchUrl =
      'https://us-central1-truecook-dev.cloudfunctions.net/add_user_tags_batch';
  
  final String _addTagUrl =
      'https://us-central1-truecook-dev.cloudfunctions.net/add_user_tag';
  final String _deleteTagUrl =
      'https://us-central1-truecook-dev.cloudfunctions.net/delete_user_tag';

  List<UsuarioHasTag> _items = [];
  List<UsuarioHasTag> get items => [..._items];
  List<UsuarioHasTag> _filteredItems = [];
  List<UsuarioHasTag> get filteredItems => [..._filteredItems];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _hasError = false;
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _isLoading = false;
    _hasError = true;
    _errorMessage = error;
    notifyListeners();
  }

  //Carregar tags associadas a um usuário específico
  Future<void> carregarTagsPorUsuario(int usuarioId) async {
    _setLoading(true);
    try {
    
      final uri = Uri.parse('$_getTagsUrl?user_id=$usuarioId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items = data.map((json) => UsuarioHasTag.fromJson(json)).toList();
        _filteredItems = _items;
        _setLoading(false);
      } else {
        _setError('Erro ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _setError('Erro de conexão: ${e.toString()}');
    }
  }

  // Adicionar múltiplas tags para um usuário (usado no questionário)
  Future<void> adicionarUserTagsQuest(int userId, List<Tag> tags) async {
    try {
      final List<int> tagIds =
          tags.where((tag) => tag.id != null).map((tag) => tag.id!).toList();

      if (tagIds.isEmpty) {
        print('⚠️ Nenhuma tag válida para salvar.');
        return;
      }

      final uri = Uri.parse('$_addBatchUrl?user_id=$userId');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tag_ids': tagIds}),
      );

      if (response.statusCode == 200) {
        print('✅ ${tags.length} tags salvas no backend para o usuário $userId');
        await carregarTagsPorUsuario(userId);
      } else {
        _setError('Erro ao adicionar tags do questionário: ${response.body}');
      }
    } catch (e) {
      _setError('Erro de conexão: ${e.toString()}');
      print('❌ ERRO ao salvar tags do questionário: $e');
    }
  }

 // Adicionar uma única tag para um usuário 
  Future<void> adicionarUsuarioTag(int userId, int tagId) async {
    try {
      final uri = Uri.parse('$_addTagUrl?user_id=$userId');
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tag_id': tagId}),
      );

      if (response.statusCode == 200) {
        await carregarTagsPorUsuario(userId);
      } else {
        _setError('Erro ao adicionar tag: ${response.body}');
      }
    } catch (e) {
      _setError('Erro de conexão: ${e.toString()}');
    }
  }

  // Deletar uma tag de um usuário
  Future<void> deletarTag(int userId, int tagId) async {
    try {
      final uri = Uri.parse('$_deleteTagUrl?user_id=$userId&tag_id=$tagId');
      
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        _items.removeWhere((r) => r.tag_id == tagId && r.usuario_id == userId);
        _filteredItems = _items;
        notifyListeners();
      } else {
        _setError('Erro ao deletar tag: ${response.body}');
      }
    } catch (e) {
      _setError('Erro de conexão: ${e.toString()}');
    }
  }
}