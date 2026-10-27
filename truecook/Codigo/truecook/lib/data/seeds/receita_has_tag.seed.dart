import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedReceitaHasTag(Database db) async {
  print('🌱 Rodando seeds Receita_has_Ingrediente...');

  // Bolo de Cenoura sem Glúten (Receita 1)
  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 1,
    'tag_id': 1, // sem glúten
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 1,
    'tag_id': 4, // vegetariano
  });

  // Panqueca Vegana de Banana (Receita 2)
  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 2,
    'tag_id': 1, // sem glúten
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 2,
    'tag_id': 2, // vegano
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 2,
    'tag_id': 3, // sem lactose
  });

  // Salada de Grão-de-Bico (Receita 3)
  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 3,
    'tag_id': 2, // vegano
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 3,
    'tag_id': 3, // sem lactose
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 3,
    'tag_id': 10, // proteína vegetal
  });

  // Sopa Detox de Abóbora (Receita 4)
  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 4,
    'tag_id': 3, // sem lactose
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 4,
    'tag_id': 11, // detox
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 4,
    'tag_id': 4, // vegetariano
  });

  // Muffin Integral de Maçã (Receita 5)
  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 5,
    'tag_id': 3, // sem lactose
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 5,
    'tag_id': 12, // integral
  });

  await db.insert(AppTables.RECEITA_HAS_TAG, {
    'receita_id': 5,
    'tag_id': 6, // sem açúcar
  });
  print('✅ Receita_has_Ingrediente carregadas.');
}
