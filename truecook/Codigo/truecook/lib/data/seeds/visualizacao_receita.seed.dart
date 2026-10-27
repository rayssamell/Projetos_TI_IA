import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedVisualizacaoReceita(Database db) async {
  print('🌱 Rodando seeds Visualizacao_Receita...');

  // Visualizações da Receita 1 (Bolo de Cenoura)
  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 2,
    'receita_id': 1,
    'data_visualizacao': '2025-09-08 10:00:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 4,
    'receita_id': 1,
    'data_visualizacao': '2025-09-09 14:30:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 6,
    'receita_id': 1,
    'data_visualizacao': '2025-09-10 16:45:00',
  });

  // Visualizações da Receita 2 (Panqueca Vegana)
  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 1,
    'receita_id': 2,
    'data_visualizacao': '2025-09-07 09:15:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 3,
    'receita_id': 2,
    'data_visualizacao': '2025-09-08 11:20:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 5,
    'receita_id': 2,
    'data_visualizacao': '2025-09-09 13:25:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 7,
    'receita_id': 2,
    'data_visualizacao': '2025-09-10 15:30:00',
  });

  // Visualizações da Receita 3 (Salada de Grão-de-Bico)
  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 1,
    'receita_id': 3,
    'data_visualizacao': '2025-09-08 08:45:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 3,
    'receita_id': 3,
    'data_visualizacao': '2025-09-09 10:50:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 8,
    'receita_id': 3,
    'data_visualizacao': '2025-09-10 12:55:00',
  });

  // Visualizações da Receita 4 (Sopa Detox)
  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 2,
    'receita_id': 4,
    'data_visualizacao': '2025-09-09 17:00:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 5,
    'receita_id': 4,
    'data_visualizacao': '2025-09-10 19:05:00',
  });

  // Visualizações da Receita 5 (Muffin Integral)
  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 1,
    'receita_id': 5,
    'data_visualizacao': '2025-09-10 07:30:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 5,
    'receita_id': 5,
    'data_visualizacao': '2025-09-11 09:35:00',
  });

  await db.insert(AppTables.VISUALIZACAO_RECEITA, {
    'usuario_id': 9,
    'receita_id': 5,
    'data_visualizacao': '2025-09-12 11:40:00',
  });

  print('✅ Seeds Visualizacao_Receita rodados com sucesso!');
}
