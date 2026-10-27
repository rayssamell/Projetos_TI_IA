import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/shared/enums/enumTables.dart';

class IngredienteRepository extends CrudRespository<Ingrediente> {
  IngredienteRepository() : super(tableName: AppTables.INGREDIENTE);

  @override
  Ingrediente fromMap(Map<String, dynamic> map) => Ingrediente.fromMap(map);

  @override
  Map<String, dynamic> toMap(Ingrediente entity) => entity.toMap();
}
