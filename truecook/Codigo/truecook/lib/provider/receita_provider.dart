
import 'package:truecook/data/repositories/receita_repository.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/provider/crud_provider.dart';

class ReceitaProvider extends CrudProvider<Receita, ReceitaRepository> {
  ReceitaProvider() : super(ReceitaRepository());

  // Carrega todas as receitas
  Future<void> carregarReceitas() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    print('🌱 Carregando receitas...');
    try {
      items = await repository.findAll();
      print('✅ Receitas carregadas: ${items.length}');
      filteredItems = items;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      print('🌱 Erro ao carregar receitas: $e');
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Carrega receitas por usuário
  Future<void> carregarReceitasPorUsuario(int usuarioId) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      items = await repository.buscarPorUsuario(usuarioId);
      filteredItems = items;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Carrega receitas rápidas
  Future<void> carregarReceitasRapidas() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      items = await repository.buscarPorTempoMaximo(30);
      filteredItems = items;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Adiciona uma nova receita
  Future<int> adicionarReceita(Receita receita) async {
    try {
      int id = await repository.insert(receita);
      await carregarReceitas(); // Recarrega a lista
      return id;
    } catch (e) {
      hasError = true;
      errorMessage = 'Erro ao adicionar receita: ${e.toString()}';
      notifyListeners();
      return -1;
    }
  }

  // Atualiza uma receita existente
  Future<void> atualizarReceita(Receita receita) async {
    try {
      await repository.update(receita);
      // Atualiza na lista local
      final index = items.indexWhere((r) => r.id == receita.id);
      if (index != -1) {
        items[index] = receita;
        filteredItems = items;
        notifyListeners();
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Erro ao atualizar receita: ${e.toString()}';
      notifyListeners();
    }
  }

  // Deleta uma receita
  Future<void> deletarReceita(int id) async {
    try {
      await repository.delete(id);
      // Remove da lista local
      items.removeWhere((r) => r.id == id);
      filteredItems = items;
      notifyListeners();
    } catch (e) {
      hasError = true;
      errorMessage = 'Erro ao deletar receita: ${e.toString()}';
      notifyListeners();
    }
  }

  // Busca receitas por título
  void buscarReceitas(String query) {
    if (query.isEmpty) {
      filteredItems = items;
    } else {
      filteredItems = items.where((receita) {
        return receita.titulo.toLowerCase().contains(query.toLowerCase()) ||
            receita.descricao!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Busca receita por ID
  Future<Receita?> buscarReceitaPorId(int id) async {
    try {
      return await repository.findById(id);
    } catch (e) {
      hasError = true;
      errorMessage = 'Erro ao buscar receita: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  // Limpa filtros
  @override
  void limparFiltros() {
    filteredItems = items;
    notifyListeners();
  }

  // Limpa erros
  @override
  void limparErro() {
    hasError = false;
    errorMessage = null;
    notifyListeners();
  }

  // Estatísticas
  int get totalReceitas => items.length;

  int contarReceitasPorUsuario(int usuarioId) {
    return items.where((r) => r.usuario_id == usuarioId).length;
  }

  // Receitas recentes (ordenadas por data)
  List<Receita> get receitasRecentes {
    return List.from(filteredItems)
      ..sort((a, b) => b.data_publicacao.compareTo(a.data_publicacao));
  }

  // Receitas mais rápidas (ordenadas por tempo)
  List<Receita> get receitasMaisRapidas {
    return List.from(filteredItems)
      ..sort((a, b) => a.tempo_preparo.compareTo(b.tempo_preparo));
  }

  // Receitas por tempo máximo
  List<Receita> receitasPorTempoMaximo(int tempoMaximo) {
    return filteredItems.where((r) => r.tempo_preparo <= tempoMaximo).toList();
  }

  List<Receita> _receitasFavoritas = [];
  List<Receita> get receitasFavoritas => _receitasFavoritas;
  final ReceitaRepository _repository = ReceitaRepository();

  // Carregar Recitas favoritas do usuario
  Future<void> carregarReceitasFavoritas(int userId) async {
    notifyListeners();

    try {
      _receitasFavoritas = await _repository.buscarReceitasFavoritas(userId);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void filtrarPorTags(Set<Tag> tagsSelecionadas) {
    // Se nenhuma tag estiver selecionada, limpa o filtro
    if (tagsSelecionadas.isEmpty) {
      limparFiltros();
      return;
    }

    final Set<String> nomesDasTags = tagsSelecionadas
        .map((tag) => tag.nome.toLowerCase())
        .toSet();

    // Filtra a lista principal 'items'
    filteredItems = items.where((receita) {
      // Verifica se a receita tem pelo menos uma tag
      return receita.tags.any(
        (tagDaReceita) =>
            nomesDasTags.contains(tagDaReceita.nome.toLowerCase()),
      );
    }).toList();

    notifyListeners();
  }

  Future<bool> toggleFavoriteReceita({
    required int userId,
    required int receitaId,
  }) async {
    return await _repository.toggleFavoriteReceita(
      userId: userId,
      receitaId: receitaId,
    );
  }

  Future<bool> receitaIsFavorite({
    required int userId,
    required int receitaId,
  }) async {
    return await _repository.receitaIsFavorite(
      userId: userId,
      receitaId: receitaId,
    );
  }
}
