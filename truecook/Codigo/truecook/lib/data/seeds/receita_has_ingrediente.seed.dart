import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedReceitaHasIngrediente(Database db) async {
  print('🌱 Rodando seeds Receita_has_Ingrediente...');
  // Bolo de Cenoura sem Glúten (Receita 1)
  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 1,
    'ingrediente_id': 1, // Cenoura
    'quantidade': 3,
    'observacoes': 'raladas',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 1,
    'ingrediente_id': 2, // Farinha de Arroz
    'quantidade': 2,
    'observacoes': 'xícaras',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 1,
    'ingrediente_id': 3, // Ovo
    'quantidade': 3,
    'observacoes': '',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 1,
    'ingrediente_id': 4, // Fermento
    'quantidade': 1,
    'observacoes': 'colher de sopa',
  });

  // Panqueca Vegana de Banana (Receita 2)
  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 2,
    'ingrediente_id': 5, // Banana
    'quantidade': 2,
    'observacoes': 'maduras',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 2,
    'ingrediente_id': 6, // Aveia
    'quantidade': 1,
    'observacoes': 'xícara',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 2,
    'ingrediente_id': 7, // Leite Vegetal
    'quantidade': 0.5,
    'observacoes': 'xícara',
  });

  // Salada de Grão-de-Bico (Receita 3)
  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 3,
    'ingrediente_id': 8, // Grão-de-bico
    'quantidade': 1,
    'observacoes': 'xícara (cozido)',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 3,
    'ingrediente_id': 9, // Tomate
    'quantidade': 2,
    'observacoes': 'picados',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 3,
    'ingrediente_id': 10, // Pepino
    'quantidade': 1,
    'observacoes': 'picado',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 3,
    'ingrediente_id': 11, // Azeite
    'quantidade': 2,
    'observacoes': 'colheres de sopa',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 3,
    'ingrediente_id': 12, // Limão
    'quantidade': 1,
    'observacoes': 'suco',
  });

  // Sopa Detox de Abóbora (Receita 4)
  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 4,
    'ingrediente_id': 13, // Abóbora
    'quantidade': 0.5,
    'observacoes': 'kg',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 4,
    'ingrediente_id': 14, // Cebola
    'quantidade': 1,
    'observacoes': 'picada',
  });

  // Muffin Integral de Maçã (Receita 5)
  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 5,
    'ingrediente_id': 15, // Maçã
    'quantidade': 2,
    'observacoes': 'raladas',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 5,
    'ingrediente_id': 16, // Açúcar Mascavo
    'quantidade': 0.5,
    'observacoes': 'xícara',
  });

  await db.insert(AppTables.RECEITA_HAS_INGREDIENTE, {
    'receita_id': 5,
    'ingrediente_id': 17, // Óleo de Coco
    'quantidade': 0.25,
    'observacoes': 'xícara',
  });
  print('✅ IngredienteHasReceita carregados.');
}
