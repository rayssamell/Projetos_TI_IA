import 'package:sqflite/sqlite_api.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedUsuarios(Database db) async {
  print('🌱 Rodando seeds Usuarios...');

  await db.insert(AppTables.USUARIO, {
    'nome': 'Ana Silva',
    'email': 'ana.silva@email.com',
    'senha': 'senha123',
    'sexo': 'F',
    'foto':
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua das Flores, 123 - Jardim Paulista, São Paulo - SP',
    'telefone': '(11) 99999-1234',
    'data_nascimento': '1990-05-15',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Davi',
    'email': 'davi@gmail.com',
    'senha': 'senha123',
    'sexo': 'M',
    'foto':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Avenida Paulista, 1000 - Bela Vista, São Paulo - SP',
    'telefone': '(11) 98888-5678',
    'data_nascimento': '1985-08-22',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Mariana Santos',
    'email': 'mariana.santos@email.com',
    'senha': 'senha789',
    'sexo': 'F',
    'foto':
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua Augusta, 500 - Consolação, São Paulo - SP',
    'telefone': '(11) 97777-9012',
    'data_nascimento': '1992-12-03',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'João Pereira',
    'email': 'joao.pereira@email.com',
    'senha': 'senha321',
    'sexo': 'M',
    'foto':
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Alameda Santos, 200 - Jardins, São Paulo - SP',
    'telefone': '(11) 96666-3456',
    'data_nascimento': '1988-03-18',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Fernanda Costa',
    'email': 'fernanda.costa@email.com',
    'senha': 'senha654',
    'sexo': 'F',
    'foto':
        'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua Haddock Lobo, 800 - Cerqueira César, São Paulo - SP',
    'telefone': '(11) 95555-7890',
    'data_nascimento': '1995-07-30',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Ricardo Almeida',
    'email': 'ricardo.almeida@email.com',
    'senha': 'senha987',
    'sexo': 'M',
    'foto':
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua Oscar Freire, 350 - Jardins, São Paulo - SP',
    'telefone': '(11) 94444-1234',
    'data_nascimento': '1983-11-12',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Juliana Rodrigues',
    'email': 'juliana.rodrigues@email.com',
    'senha': 'senha159',
    'sexo': 'F',
    'foto':
        'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Avenida Faria Lima, 1500 - Itaim Bibi, São Paulo - SP',
    'telefone': '(11) 93333-5678',
    'data_nascimento': '1991-09-25',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Pedro Henrique',
    'email': 'pedro.henrique@email.com',
    'senha': 'senha753',
    'sexo': 'M',
    'foto':
        'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua Bela Cintra, 600 - Consolação, São Paulo - SP',
    'telefone': '(11) 92222-9012',
    'data_nascimento': '1994-02-14',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Camila Ferreira',
    'email': 'camila.ferreira@email.com',
    'senha': 'senha486',
    'sexo': 'F',
    'foto':
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua das Oliveiras, 50 - Pinheiros, São Paulo - SP',
    'telefone': '(11) 91111-3456',
    'data_nascimento': '1987-06-08',
  });

  await db.insert(AppTables.USUARIO, {
    'nome': 'Alex Green',
    'email': 'alex.green@email.com',
    'senha': 'senha624',
    'sexo': 'O',
    'foto':
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?q=80&w=200&h=200&fit=crop&auto=format',
    'endereco': 'Rua Harmonia, 900 - Vila Madalena, São Paulo - SP',
    'telefone': '(11) 90000-7890',
    'data_nascimento': '1993-04-20',
  });
  

  print('✅ Usuarios cadastrados! ');
}
