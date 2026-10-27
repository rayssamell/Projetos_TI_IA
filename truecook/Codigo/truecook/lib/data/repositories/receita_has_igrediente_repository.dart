import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/receita_has_ingrediente.dart';
import 'package:truecook/shared/enums/enumTables.dart';

/// Repositório responsável por guardar par usuario, tags
/// - Persistência de dados locais ou via API.

class ReceitaHasIgredienteRepository extends CrudRespository<ReceitaHasIngrediente> {
  ReceitaHasIgredienteRepository() : super(tableName: AppTables.RECEITA_HAS_INGREDIENTE);

  @override
  ReceitaHasIngrediente fromMap(Map<String, dynamic> map) => ReceitaHasIngrediente.fromMap(map);

  @override
  Map<String, dynamic> toMap(ReceitaHasIngrediente entity) => entity.toMap();
}
