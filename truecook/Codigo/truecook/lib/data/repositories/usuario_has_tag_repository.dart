import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/usuario_has_tag.dart';
import 'package:truecook/shared/enums/enumTables.dart';

/// Repositório responsável por guardar par usuario, tags
/// - Persistência de dados locais ou via API.

class UsuarioHasTagRepository extends CrudRespository<UsuarioHasTag> {
  UsuarioHasTagRepository() : super(tableName: AppTables.USUARIO_HAS_TAG);

  @override
  UsuarioHasTag fromMap(Map<String, dynamic> map) => UsuarioHasTag.fromMap(map);

  @override
  Map<String, dynamic> toMap(UsuarioHasTag entity) => entity.toMap();

  // Métodos específicos
  Future<List<UsuarioHasTag>> buscarTagsUsuario(int usuarioId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return maps.map(fromMap).toList();
  }


}
