import 'package:sqflite/sqflite.dart';
import 'package:truecook/data/seeds/ingredientes.seed.dart';
import 'package:truecook/data/seeds/receita_has_ingrediente.seed.dart';
import 'package:truecook/data/seeds/receita_has_tag.seed.dart';
import 'package:truecook/data/seeds/tags.seed.dart';
import 'package:truecook/data/seeds/usuario_receita_favorita.seed.dart';
import 'package:truecook/data/seeds/usuarios.seed.dart';
import 'package:truecook/data/seeds/receitas.seed.dart';
import 'package:truecook/data/seeds/comentarios.seed.dart';
import 'package:truecook/data/seeds/comercios.seed.dart';
import 'package:truecook/data/seeds/visualizacao_receita.seed.dart';

Future<void> runAllSeeds(Database db) async {
  print('----------------------------------------------');
  print('🌱 Rodando seeds... 🌱');

  await seedUsuarios(db);

  await seedComercios(db);

  await seedReceitas(db);

  await seedIngredientes(db);

  await seedComentarios(db);

  await seedTags(db);

  await seedReceitaHasIngrediente(db);

  await seedReceitaHasTag(db);

  await seedUsuarioReceitaFavorita(db);

  await seedVisualizacaoReceita(db);

  print('✅ Seeds concluídas!. ✅');
  print('----------------------------------------------');
}
