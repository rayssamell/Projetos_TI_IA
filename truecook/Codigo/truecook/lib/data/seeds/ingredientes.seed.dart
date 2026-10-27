// Seeds de Ingredientes
import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedIngredientes(Database db) async {
  print('🌱 Rodando seeds Ingredientes...');

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Cenoura',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Farinha de Arroz',
    'tipo': 'Grão',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Ovo',
    'tipo': 'Outro',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Fermento',
    'tipo': 'Outro',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Banana',
    'tipo': 'Fruta',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Aveia',
    'tipo': 'Cereal',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Leite Vegetal',
    'tipo': 'Laticínio',
    'unidade_medida': 'ml',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Grão-de-bico',
    'tipo': 'Grão',
    'unidade_medida': 'kg',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Tomate',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Pepino',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Azeite',
    'tipo': 'Tempero',
    'unidade_medida': 'ml',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Limão',
    'tipo': 'Fruta',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Abóbora',
    'tipo': 'Legume',
    'unidade_medida': 'kg',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Cebola',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Maçã',
    'tipo': 'Fruta',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Açúcar Mascavo',
    'tipo': 'Tempero',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Óleo de Coco',
    'tipo': 'Outro',
    'unidade_medida': 'ml',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Couve',
    'tipo': 'Verdura',
    'unidade_medida': 'folha',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Gengibre',
    'tipo': 'Tempero',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Lentilha',
    'tipo': 'Grão',
    'unidade_medida': 'kg',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Pimentão',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Ervilha',
    'tipo': 'Legume',
    'unidade_medida': 'unidade',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Chocolate Amargo',
    'tipo': 'Outro',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Quinoa',
    'tipo': 'Grão',
    'unidade_medida': 'grama',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Salsinha',
    'tipo': 'Tempero',
    'unidade_medida': 'maço',
  });

  await db.insert(AppTables.INGREDIENTE, {
    'nome': 'Hortelã',
    'tipo': 'Tempero',
    'unidade_medida': 'maço',
  });
  print('✅ Ingredientes carregados.');
}
