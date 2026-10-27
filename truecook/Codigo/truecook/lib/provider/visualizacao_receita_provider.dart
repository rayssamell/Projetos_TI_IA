import 'package:truecook/data/repositories/visualizacao_receita_repository.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/models/visualizacao_receita.dart';
import 'package:truecook/provider/crud_provider.dart';

class VisualizacaoReceitaProvider
    extends CrudProvider<VisualizacaoReceita, VisualizacaoReceitaRepository> {
  VisualizacaoReceitaProvider() : super(VisualizacaoReceitaRepository());

  Future<void> adicionarVisualizacao(Receita receita, int userId) async {
    final item = VisualizacaoReceita(
      receita_id: receita.id!,
      usuario_id: userId,
      data_visualizacao: DateTime.now(),
    );
    print('🌱 Adicionando visualização de receita... ($item)');
    super.adicionar(item);
  }

  Future<int> buscarVisualizacoes(int receitaId) async {
    print('🌱 Buscando visualização de receita... ($receitaId)');
    return await repository.buscarVisualizacoes(receitaId);
  }
}
