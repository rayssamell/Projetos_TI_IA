import 'package:sqflite/sqflite.dart';
import 'package:truecook/data/db/db.dart';

class CrudRespository<T> {
  final String tableName;
  CrudRespository({required this.tableName});

  // Getter para o database - USA CLASSE DB DIRETAMENTE!
  Future<Database> get database async {
    final db = await DB.instance.database;
    if (db == null) {
      throw Exception('Database não inicializado');
    }
    return db;
  }

  T fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  // Converte Model para Map
  Map<String, dynamic> toMap(T entity) {
    throw UnimplementedError();
  }

  // CRUD Básico
  Future<int> insert(T entity) async {
    final db = await database;
    final mapData = toMap(entity);

    mapData.remove('id');
    return await db.insert(tableName, mapData);
  }

  Future<List<T>> findAll() async {
    final db = await database;
    final List<Map<String, dynamic>> mapData = await db.query(tableName);
    return mapData.map((m) => fromMap(m)).toList();
  }

  Future<T?> findById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> mapData = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return mapData.isNotEmpty ? fromMap(mapData.first) : null;
  }

  Future<int> update(T entity) async {
    final db = await database;
    final mapData = toMap(entity);
    final id = mapData['id'];
    if (id == null) throw Exception('ID não pode ser nulo para update');

    return await db.update(
      tableName,
      mapData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
