import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:truecook/data/repositories/tag_repository.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/provider/crud_provider.dart';
import 'package:truecook/models/regra.dart';
class TagProvider extends CrudProvider<Tag, TagRepository> {
  TagProvider() : super(TagRepository());

  List<Regra> _regras = [];
  List<Regra> get regras => _regras;

  Future<void> carregarTags() async {
    
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    print('🌱 Carregando tags (do provider)...');
    try {
      items = await repository.findAll(); // Carrega do SQLite
      print('✅ Tags carregadas (do provider): ${items.length}');
      filteredItems = items;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      print('🌱 Erro ao carregar tags (do provider): $e');
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  List<Tag> _tagsDoUsuario = [];
  List<Tag> get tagsDoUsuario => _tagsDoUsuario;

  Future<void> carregarTagsPorIds(List<int> ids) async {
    print('🌱 Carregando tags do usuário por IDs...');

    if (ids.isEmpty) {
      _tagsDoUsuario = [];
      notifyListeners();
      return;
    }

    if (items.isEmpty) {
      await carregarTags();
    }

    _tagsDoUsuario = items.where((tag) => ids.contains(tag.id)).toList();
    
    print('✅ Tags do usuário filtradas: ${_tagsDoUsuario.length}');
    notifyListeners();
  }


  Future<void> carregarRegras() async {
    if (_regras.isNotEmpty) return;

    print('☁️ Buscando regras da IA na nuvem...');
    try {
      final uri = Uri.parse('https://get-rules-ykhznb7oaq-uc.a.run.app');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _regras = data.map((json) => Regra.fromJson(json)).toList();
        print('✅ Regras da IA carregadas: ${_regras.length} regras.');
      } else {
        print('❌ Erro ao carregar regras: ${response.statusCode} ${response.body}');
        _regras = [];
      }
    } catch (e) {
      print('❌ Erro de conexão ao carregar regras: $e');
      _regras = [];
    }
  }
}