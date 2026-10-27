import 'package:truecook/data/repositories/receita_has_igrediente_repository.dart';
import 'package:truecook/models/receita_has_ingrediente.dart';
import 'package:truecook/provider/crud_provider.dart';

class ReceitaHasIgredienteProvider
    extends
        CrudProvider<ReceitaHasIngrediente, ReceitaHasIgredienteRepository> {
  ReceitaHasIgredienteProvider() : super(ReceitaHasIgredienteRepository());


  ReceitaHasIngrediente getItemReceitaId(int receitaId) {
    return items.where((item) => item.receitaId == receitaId).first;
  }
}
