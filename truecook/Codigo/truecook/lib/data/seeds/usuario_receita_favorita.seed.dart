import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedUsuarioReceitaFavorita(Database db) async {
  print('🌱 Rodando seeds Usuario_Receita_Favorita...');

  // Usuário 1 favorita receitas 2, 3, 5
  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 1,
    'receita_id': 2,
    'data_adicao': '2025-09-10 10:00:00',
  });

  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 1,
    'receita_id': 3,
    'data_adicao': '2025-09-11 14:30:00',
  });

  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 1,
    'receita_id': 5,
    'data_adicao': '2025-09-12 16:45:00',
  });

  // Usuário 2 favorita receitas 1, 4
  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 2,
    'receita_id': 1,
    'data_adicao': '2025-09-09 09:15:00',
  });

  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 2,
    'receita_id': 4,
    'data_adicao': '2025-09-10 11:20:00',
  });

  // Usuário 3 favorita receitas 2, 3
  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 3,
    'receita_id': 2,
    'data_adicao': '2025-09-08 15:00:00',
  });

  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 3,
    'receita_id': 3,
    'data_adicao': '2025-09-09 17:30:00',
  });

  // Usuário 4 favorita receita 1
  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 4,
    'receita_id': 1,
    'data_adicao': '2025-09-11 08:45:00',
  });

  // Usuário 5 favorita receitas 4, 5
  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 5,
    'receita_id': 4,
    'data_adicao': '2025-09-10 13:20:00',
  });

  await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
    'usuario_id': 5,
    'receita_id': 5,
    'data_adicao': '2025-09-12 10:10:00',
  });

  print('✅ Seeds concluídas!.');
}
