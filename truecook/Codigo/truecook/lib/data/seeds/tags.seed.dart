import 'package:sqflite/sqflite.dart';

Future<void> seedTags(Database db) async {
  print('🌱 Rodando seeds Tags...');

  final tags = [
    {'nome': 'Celíaco'},
    {'nome': 'Diabético'},
    {'nome': 'Vegetariano'},
    {'nome': 'Vegano'},
    {'nome': 'Colesterol Alto'},
    {'nome': 'Intolerante a Lactose'},
    {'nome': 'Alergia a Ovo'},
    {'nome': 'Alergia a Amendoim'},
    {'nome': 'Alergia a Peixe'},
    {'nome': 'Alergia a Soja'},
    {'nome': 'Alergia a Nozes e Castanhas'},
    {'nome': 'Alergia a Frutos do Mar'},
    {'nome': 'Alergias'},
    {'nome': 'Saudável'},
    {'nome': 'Low Carb'},
    {'nome': 'Fitness'},
    {'nome': 'Cetogenica'},
    {'nome': 'Alto proteína'},
    {'nome': 'Baixo Calorias'},
    {'nome': 'Rico em Fibras'},
    {'nome': 'Fácil e Rápida'},
  ];

  for (final tag in tags) {
    await db.insert('Tag', tag);
  }

  print('✅ Tags seedadas com sucesso!');
}
