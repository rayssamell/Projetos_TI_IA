import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/shared/enums/enumTables.dart';

class TagRepository extends CrudRespository<Tag> {
  TagRepository() : super(tableName: AppTables.TAG);

  @override
  Tag fromMap(Map<String, dynamic> map) => Tag.fromMap(map);

  @override
  Map<String, dynamic> toMap(Tag entity) => entity.toMap();


  // Override do insert para adicionar logging
  @override
  Future<int> insert(Tag entity) async {
    final id = await super.insert(entity);
    print('✅ Tag inserida com ID: $id - ${entity.nome}');
    return id;
  }

  //Encontrar ids das tag
  Future<List<Tag>> findByIds(List<int> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    final db = await database; 

    //placeholders para consulta
    String placeholders = ids.map((_) => '?').join(', ');

    // executa a consulta
    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );

    return List.generate(maps.length, (i) {
      return fromMap(maps[i]); 
    });
  }
}
