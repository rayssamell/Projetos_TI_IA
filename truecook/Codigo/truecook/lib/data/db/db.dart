import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:truecook/data/db/dbModelsHelp.dart';
import 'package:truecook/data/seeds/seed_manager.dart';

class DB {
  //Construtor de acesso privado -> Permite que apenas uma instancia seja criada

  DB._();

  // Cira uma instancia unica de DB
  static final DB instance = DB._();

  static const String dbName = 'truecook.db';
  static const int dbVersion = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      print('✅ Database já inicializado');
      return _database;
    }
    print('🔄 Inicializando database...');
    _database = await _initDatabase();
    print('✅ Database inicializado com sucesso');
    return _database;
  }

  // Inicia o banco de dados
  Future<Database?>? _initDatabase() async {
    try {
      final path = join(await getDatabasesPath(), dbName);
      print('📁 Caminho do banco: $path');

      // Caso queira apagar o banco (Quando houver mudanças no modelo de dados)
      await deleteDatabase(path);

      return await openDatabase(
        path,
        version: dbVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          print('👷 Criando banco de dados...');
          await _onCreate(db, version);
        },
      );
    } catch (e, s) {
      print('❌ Erro ao inicializar o banco: $e');
      print(s);
      return null;
    }
  }

  // Cria o banco de dados
  Future<void> _onCreate(Database db, int version) async {
    
    print('----------------------------------------------');
    print('👷 Criando tabelas...');
    await db.execute(createUsuario());
    await db.execute(createTag());
    await db.execute(createIngrediente());
    await db.execute(createReceita());
    await db.execute(createComercio());
    await db.execute(createComentario());
    await db.execute(createReceitaHasIngrediente());
    await db.execute(createReceitaHasTag());
    await db.execute(createUsuarioReceitaFavorita());
    await db.execute(createVisualizacaoReceita());
    await db.execute(createUsuarioHasTag());

    print('✅ Tabelas criadas com sucesso!');
    print('----------------------------------------------');

    await runAllSeeds(db);
  }
}
