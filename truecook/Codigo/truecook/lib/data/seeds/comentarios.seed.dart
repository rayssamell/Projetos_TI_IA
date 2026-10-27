// Inserts de comentários iniciais
import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedComentarios(Database db) async {
  print('🌱 Rodando seeds Comentarios...');

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Um bolo fofinho de cenoura sem glúten, ideal para celíacos.',
    'data_publicacao': '2025-09-01',
    'avaliacao': 5,
    'curtidas': 0,
    'usuario_id': 1,
    'receita_id': 1,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Panqueca nutritiva feita com banana, aveia e sem ovos.',
    'data_publicacao': '2025-09-02',
    'avaliacao': 4,
    'curtidas': 0,
    'usuario_id': 2,
    'receita_id': 2,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Salada refrescante e rica em proteínas vegetais.',
    'data_publicacao': '2025-09-03',
    'avaliacao': 5,
    'curtidas': 0,
    'usuario_id': 3,
    'receita_id': 3,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Receita prática e deliciosa! Adorei o resultado.',
    'data_publicacao': '2025-09-04',
    'avaliacao': 4,
    'curtidas': 0,
    'usuario_id': 1,
    'receita_id': 2,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Gostei bastante, mas poderia ser um pouco menos doce.',
    'data_publicacao': '2025-09-05',
    'avaliacao': 3,
    'curtidas': 0,
    'usuario_id': 2,
    'receita_id': 1,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Fiz aqui em casa e todos adoraram, parabéns pela receita!',
    'data_publicacao': '2025-09-06',
    'avaliacao': 5,
    'curtidas': 0,
    'usuario_id': 3,
    'receita_id': 2,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Achei a receita muito criativa e saudável!',
    'data_publicacao': '2025-09-07',
    'avaliacao': 4,
    'curtidas': 0,
    'usuario_id': 1,
    'receita_id': 3,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Achei a receita muito criativa e saudável!',
    'data_publicacao': '2025-09-07',
    'avaliacao': 4,
    'curtidas': 0,
    'usuario_id': 1,
    'receita_id': 3,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto':
        'Achei a receita muito Bonita e Gostosa, mas poderia ser um pouco mais nutritiva!',
    'data_publicacao': '2025-04-07',
    'avaliacao': 3.5,
    'curtidas': 0,
    'usuario_id': 1,
    'receita_id': 4,
  });

  await db.insert(AppTables.COMENTARIO, {
    'texto': 'Não gostei muito, mas achei a receita muito Bonita e fofa!',
    'data_publicacao': '2025-04-07',
    'avaliacao': 2.5,
    'curtidas': 0,
    'usuario_id': 3,
    'receita_id': 5,
  });
  print('✅ Comentarios seedados com sucesso!');
}
