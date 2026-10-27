// lib/provider/comercio_provider.dart

import 'package:truecook/provider/crud_provider.dart';
import 'package:truecook/data/repositories/comercio_repository.dart';
import 'package:truecook/models/comercio.dart';
import 'package:geolocator/geolocator.dart';

class ComercioProvider extends CrudProvider<Comercio, ComercioRepository> {
  ComercioProvider() : super(ComercioRepository());

  // --- NOVOS ESTADOS PARA OS FILTROS ---
  bool _filtroProximidadeAtivo = true; // Começa mostrando só os próximos
  String _queryBusca = '';
  
  // Getter para a UI saber qual botão está selecionado
  bool get filtroProximidadeAtivo => _filtroProximidadeAtivo;

  // Raio em KM para o filtro "Próximos"
  static const double _distanciaMaximaKm = 25.0;


  // Helper de localização (igual ao que já temos)
  Future<Position> _getPosicaoAtual() async {
    bool servicoHabilitado;
    LocationPermission permissao;

    servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('Serviços de localização estão desabilitados.');
    }
    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização foi negada.');
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // syncComercios continua igual, ele apenas chama fetchComercios
  Future<void> syncComercios() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();
    print(' Sincronizando com o Gist...');
    try {
      await repository.syncFromApi();
      print(' Sincronização do Gist concluída.');
      await fetchComercios(); // Este método vai aplicar os filtros
    } catch (e) {
      isLoading = false;
      hasError = true;
      print(' Erro GERAL ao sincronizar: $e');
      errorMessage = "Falha ao buscar dados: $e";
      notifyListeners();
    }
  }

  // --- MÉTODO 'fetchComercios' ATUALIZADO ---
  // Agora ele calcula a distância para TODOS, mas só aplica o filtro
  // de proximidade se _filtroProximidadeAtivo for true.
  @override
  Future<void> fetchComercios() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }
    print(' Carregando comercios do banco local...');
    try {
      // 1. Pega a localização
      final Position posicaoUsuario = await _getPosicaoAtual();
      print('Localização obtida: ${posicaoUsuario.latitude}, ${posicaoUsuario.longitude}');

      // 2. LÊ TODOS OS DADOS DO BANCO
      final List<Comercio> todosComercios = await repository.findAll();
      print('Comércios carregados do BD: ${todosComercios.length}');

      // 3. CALCULA A DISTÂNCIA PARA *TODOS*
      final List<Comercio> listaCalculada = [];
      for (var comercio in todosComercios) {
        final double distanciaEmMetros = Geolocator.distanceBetween(
          posicaoUsuario.latitude,
          posicaoUsuario.longitude,
          comercio.latitude,
          comercio.longitude,
        );
        final double distanciaEmKm = distanciaEmMetros / 1000;
        // Adiciona o comércio com a distância calculada
        listaCalculada.add(comercio.copyWith(distanciaDoUsuario: distanciaEmKm));
      }

      // 4. ORDENA *TODOS* PELA DISTÂNCIA
      listaCalculada.sort((a, b) => 
        a.distanciaDoUsuario!.compareTo(b.distanciaDoUsuario!));

      // 5. Salva a lista completa (e ordenada) na 'items'
      items = listaCalculada; 

      // 6. Aplica os filtros (de proximidade e de busca)
      _aplicarFiltros(); 

      isLoading = false;
      hasError = false;
      errorMessage = null;
    } catch (e) {
      isLoading = false;
      hasError = true;
      print(' Erro ao carregar/filtrar comercios: $e');
      errorMessage = "Erro ao buscar comércios: $e";
    } finally {
      // Apenas notifica se ainda estiver carregando (evita notificação dupla)
      if(isLoading) isLoading = false;
      notifyListeners();
    }
  }

  // --- MÉTODO DE BUSCA ATUALIZADO ---
  // Agora ele só guarda a query e chama o filtro central
  @override
  void searchComercios(String query) {
    _queryBusca = query;
    _aplicarFiltros();
  }

  // --- NOVO MÉTODO ---
  // A UI vai chamar este método para trocar entre "Próximos" e "Todos"
  void setFiltroProximidade(bool filtroAtivo) {
    _filtroProximidadeAtivo = filtroAtivo;
    _aplicarFiltros(); // Re-aplica os filtros com a nova seleção
  }

  // --- NOVO MÉTODO CENTRAL ---
  // Este método aplica AMBOS os filtros (proximidade e busca)
  void _aplicarFiltros() {
    List<Comercio> temp = List.from(items); // Começa com todos (já ordenados)

    // 1. FILTRO DE PROXIMIDADE
    if (_filtroProximidadeAtivo) {
      temp = temp.where((c) => 
        c.distanciaDoUsuario! <= _distanciaMaximaKm
      ).toList();
    }

    // 2. FILTRO DE BUSCA (query)
    if (_queryBusca.isNotEmpty) {
      final queryLower = _queryBusca.toLowerCase();
      temp = temp.where((comercio) {
        return comercio.nome.toLowerCase().contains(queryLower);
      }).toList();
    }

    // Define a lista final que a UI vai exibir
    filteredItems = temp;
    notifyListeners();
  }
}