import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/usuario.dart';
import 'package:truecook/shared/enums/enumTables.dart';

class UsuarioRepository extends CrudRespository<Usuario> {
  UsuarioRepository() : super(tableName: AppTables.USUARIO);

  @override
  Usuario fromMap(Map<String, dynamic> map) => Usuario.fromMap(map);

  @override
  Map<String, dynamic> toMap(Usuario entity) => entity.toMap();

  /// Registra um novo usuário.
  /// Lança Exception se o e-mail já estiver cadastrado.
  Future<int> register(Usuario user) async {
    final exists = await emailExists(user.email);
    if (exists) {
      throw Exception('E-mail já cadastrado');
    }
    // Insere via CrudRespository.insert (remove id automaticamente)
    return await insert(user);
  }

  /// Busca usuário por e-mail.
  Future<Usuario?> findByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return maps.isNotEmpty ? fromMap(maps.first) : null;
  }

  /// Verifica se existe um usuário com esse e-mail.
  Future<bool> emailExists(String email) async {
    final u = await findByEmail(email);
    return u != null;
  }

  Future<Usuario?> authenticate(String email, String senha) async {
    final user = await findByEmail(email);
    if (user == null) return null;

    // Aqui, senha é comparada diretamente (plain text)
    if (user.senha == senha) {
      return user;
    }

    // Caso use hash, você trocaria por:
    // if (checkPasswordHash(senha, user.senha)) return user;

    return null;
  }

  // Override do update para adicionar logging
  @override
  Future<int> update(Usuario entity) async {
    final count = await super.update(entity);
    print('✏️ Usuário com id ${entity.id} atualizado. Linhas: $count');
    return count;
  }

  // Override do delete para adicionar logging
  @override
  Future<int> delete(int id) async {
    final count = await super.delete(id);
    print('🗑️ Usuário com $id deletado. Linhas: $count');
    return count;
  }

}
