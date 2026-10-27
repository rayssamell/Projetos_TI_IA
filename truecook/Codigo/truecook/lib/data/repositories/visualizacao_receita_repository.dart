import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/visualizacao_receita.dart';
import 'package:truecook/shared/enums/enumTables.dart';

/// Repositório responsável por guardar par usuario, tags
/// - Persistência de dados locais ou via API.

class VisualizacaoReceitaRepository
    extends CrudRespository<VisualizacaoReceita> {
  VisualizacaoReceitaRepository()
    : super(tableName: AppTables.VISUALIZACAO_RECEITA);

  @override
  VisualizacaoReceita fromMap(Map<String, dynamic> map) =>
      VisualizacaoReceita.fromMap(map);

  @override
  Map<String, dynamic> toMap(VisualizacaoReceita entity) => entity.toMap();

  Future<int> buscarVisualizacoes(int receitaId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName WHERE receita_id = ?',
      [receitaId],
    );
    print(maps.first.values.first as int);
    return maps.first.values.first as int;
  }
}
