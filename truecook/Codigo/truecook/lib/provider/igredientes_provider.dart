import 'package:truecook/data/repositories/igrediente_repository.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/provider/crud_provider.dart';


class IngredientesProvider extends CrudProvider<Ingrediente, IngredienteRepository> {
  IngredientesProvider() : super(IngredienteRepository());
}
