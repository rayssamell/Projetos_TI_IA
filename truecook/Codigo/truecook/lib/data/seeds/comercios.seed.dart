import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedComercios(Database db) async {
  print('🌱 Rodando seeds Comercio...');

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Teste',
    'tipo': 'Padaria/Cafeteria',
    'localizacao': 'Rua das Oliveiras, 123 - São Paulo, SP',
    'descricao':
        'Padaria especializada em produtos sem glúten e veganos, oferecendo pães, bolos e salgados para celíacos e veganos.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.5,
    'horario_funcionamento':
        'Segunda a Sábado: 07:00 - 20:00 | Domingo: 08:00 - 18:00',
    'latitude': -23.5505,
    'longitude': -46.6333,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Recanto GF',
    'tipo': 'Restaurante',
    'localizacao': 'Avenida Paulista, 500 - São Paulo, SP',
    'descricao':
        'Restaurante focado em culinária sem glúten e sem lactose, com opções variadas para almoço e jantar.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.8,
    'horario_funcionamento':
        'Terça a Domingo: 11:00 - 23:00 | Segunda: Fechado',
    'latitude': -23.5613,
    'longitude': -46.6567,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Alvarenga',
    'tipo': 'Mercado Orgânico',
    'localizacao': 'Rua Bela Cintra, 456 - São Paulo, SP',
    'descricao':
        'Mercado especializado em produtos orgânicos e veganos, com grande variedade de frutas, verduras e produtos naturais.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.2,
    'horario_funcionamento':
        'Segunda a Sábado: 08:00 - 22:00 | Domingo: 08:00 - 20:00',
    'latitude': -23.5505,
    'longitude': -46.6333,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'SaboresDeMaria',
    'tipo': 'Café/Restaurante',
    'localizacao': 'Rua Augusta, 789 - São Paulo, SP',
    'descricao':
        'Estabelecimento aconchegante especializado em culinária sem glúten e sem lactose, perfeito para café da manhã e lanches.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.7,
    'horario_funcionamento': 'Todos os dias: 07:00 - 22:00',
    'latitude': -23.5505,
    'longitude': -46.6333,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'GlutenFree',
    'tipo': 'Restaurante Especializado',
    'localizacao': 'Avenida Faria Lima, 1000 - São Paulo, SP',
    'descricao':
        'Restaurante 100% sem glúten, com cardápio diversificado incluindo massas, pizzas e sobremesas para celíacos.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.9,
    'horario_funcionamento':
        'Segunda a Sábado: 12:00 - 00:00 | Domingo: 12:00 - 22:00',
    'latitude': -23.5505,
    'longitude': -46.6333,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Natural Life',
    'tipo': 'Restaurante Vegano',
    'localizacao': 'Rua Haddock Lobo, 200 - São Paulo, SP',
    'descricao':
        'Restaurante 100% vegano com opções orgânicas e pratos inspirados na culinária internacional.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.6,
    'horario_funcionamento':
        'Terça a Domingo: 11:30 - 22:30 | Segunda: Fechado',
    'latitude': -23.5550,
    'longitude': -46.6600,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Casa da Quinoa',
    'tipo': 'Loja de Produtos Naturais',
    'localizacao': 'Alameda Santos, 800 - São Paulo, SP',
    'descricao':
        'Loja especializada em produtos sem glúten, sem lactose e orgânicos, com atendimento personalizado.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.4,
    'horario_funcionamento':
        'Segunda a Sexta: 09:00 - 19:00 | Sábado: 09:00 - 17:00',
    'latitude': -23.5570,
    'longitude': -46.6580,
  });

  await db.insert(AppTables.COMERCIO, {
    'nome': 'Doce Liberdade',
    'tipo': 'Confeitaria',
    'localizacao': 'Rua Oscar Freire, 350 - São Paulo, SP',
    'descricao':
        'Confeitaria especializada em doces sem glúten, sem lactose e veganos, com bolos, tortas e sobremesas.',
    'foto':
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&h=200&fit=crop&auto=format',
    'avaliacao': 4.8,
    'horario_funcionamento':
        'Terça a Domingo: 10:00 - 20:00 | Segunda: Fechado',
    'latitude': -23.5580,
    'longitude': -46.6690,
  });
  print('✅ Comercios carregados.');
}
