import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/data/repositories/usuario_repository.dart';
import 'package:truecook/models/comentario.dart';
import 'package:truecook/models/usuario.dart';
import 'package:truecook/shared/enums/enumTables.dart';

/// Repositório responsável por guardar par usuario, tags
/// - Persistência de dados locais ou via API.

class ComentarioRepository extends CrudRespository<Comentario> {
  ComentarioRepository() : super(tableName: AppTables.COMENTARIO);

  @override
  Comentario fromMap(Map<String, dynamic> map) => Comentario.fromMap(map);

  @override
  Map<String, dynamic> toMap(Comentario entity) => entity.toMap();

  Future<List<Comentario>> findByReceitaId(int receitaId) async {
    final db = await database;
    final maps = await db.query(
      AppTables.COMENTARIO,
      where: 'receita_id = ?',
      whereArgs: [receitaId],
    );

    List<Comentario> comentariorResp = [];

    List<Comentario> comentarios = maps
        .map((map) => Comentario.fromMap(map))
        .toList();

    final UsuarioRepository repository = UsuarioRepository();
    for (var comentario in comentarios) {
      final Usuario? usuario = await repository.findById(comentario.usuarioId);

      final newComentario = comentario.copyWith(usuario: usuario);

      comentariorResp.add(newComentario);
    }

    return comentariorResp;
  }
}
