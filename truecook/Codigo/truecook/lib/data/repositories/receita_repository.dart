import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/data/repositories/usuario_repository.dart';
import 'package:truecook/models/comentario.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/models/tag.dart';
import 'package:truecook/models/usuario.dart';
import 'package:truecook/shared/enums/enumTables.dart';

class ReceitaRepository extends CrudRespository<Receita> {
  ReceitaRepository() : super(tableName: AppTables.RECEITA);

  @override
  Receita fromMap(Map<String, dynamic> map) => Receita.fromMap(map);

  @override
  Map<String, dynamic> toMap(Receita entity) => entity.toMap();

  Future<List<Tag>> findTagsByReceita(int receitaId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT T.* 
      FROM ${AppTables.TAG} T
      JOIN ${AppTables.RECEITA_HAS_TAG} RHT ON T.id = RHT.tag_id
      WHERE RHT.receita_id = ?''',
      [receitaId],
    );
    return maps.map((map) => Tag.fromMap(map)).toList();
  }

  Future<List<Ingrediente>> findIngredientesByReceita(int receitaId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT * FROM ${AppTables.INGREDIENTE} I
      JOIN ${AppTables.RECEITA_HAS_INGREDIENTE} RHI ON I.id = RHI.ingrediente_id
      WHERE RHI.receita_id = ?''',
      [receitaId],
    );
    return maps.map((map) => Ingrediente.fromMap(map)).toList();
  }

  Future<List<Comentario>> findComentariosByReceita(int receitaId) async {
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

  @override
  Future<List<Receita>> findAll() async {
    final db = await database;

    // --- 1️⃣ Consulta principal com joins e agregações ---
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      r.*,
      AVG(c.avaliacao) AS avaliacao_media,
      COUNT(DISTINCT vr.usuario_id) AS total_visualizacoes
    FROM Receita r
    LEFT JOIN Comentario c ON r.id = c.receita_id
    LEFT JOIN Visualizacao_Receita vr ON r.id = vr.receita_id
    GROUP BY r.id
    ORDER BY avaliacao_media DESC, total_visualizacoes DESC, r.data_publicacao DESC
  ''');

    // Para cada receita, busca os comentários completos
    List<Receita> receitas = [];

    for (var map in maps) {
      final id = map['id'] as int;

      //Busca comentários da receita
      final comentarios = await findComentariosByReceita(id);

      // Monta tags e ingredientes
      final tags = await findTagsByReceita(id);

      // Busca ingredientes
      final ingredientes = await findIngredientesByReceita(id);

      // Cria o objeto final
      final receita = Receita.fromMap(map).copyWith(
        tags: tags,
        ingredientes: ingredientes,
        avaliacoes: double.parse(
          (map['avaliacao_media'] ?? 0).toDouble().toStringAsFixed(1),
        ),
        visualizacoes: (map['total_visualizacoes'] ?? 0),
        comentarios: comentarios,
      );

      receitas.add(receita);
    }

    return receitas;
  }

  // Métodos específicos
  Future<List<Receita>> buscarPorUsuario(int usuarioId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'data_publicacao DESC',
    );
    return maps.map(fromMap).toList();
  }

  Future<List<Receita>> buscarPorTempoMaximo(int tempoMaximo) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'tempo_preparo <= ?',
      whereArgs: [tempoMaximo],
      orderBy: 'tempo_preparo ASC',
    );
    return maps.map(fromMap).toList();
  }

  Future<List<Receita>> buscarPorTitulo(String searchTerm) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'titulo LIKE ?',
      whereArgs: ['%$searchTerm%'],
      orderBy: 'titulo ASC',
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<List<Receita>> buscarRecentes([int limit = 10]) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      orderBy: 'data_publicacao DESC',
      limit: limit,
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  // Métodos com queries mais complexas
  Future<List<Receita>> buscarComIngredientes() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT r.*, GROUP_CONCAT(i.nome) as ingredientes
      FROM $tableName r
      LEFT JOIN ${AppTables.RECEITA_HAS_INGREDIENTE} rhi ON r.id = rhi.receita_id
      LEFT JOIN ${AppTables.INGREDIENTE} i ON rhi.ingrediente_id = i.id
      GROUP BY r.id
    ''');
    return maps.map((map) => fromMap(map)).toList();
  }

  // Estatísticas
  Future<int> countReceitasPorUsuario(int usuarioId) async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName WHERE usuario_id = ?',
      [usuarioId],
    );
    return maps.first.values.first as int;
  }

  Future<double> tempoMedioPreparo() async {
    final db = await database;
    final maps = await db.rawQuery('SELECT AVG(tempo_preparo) FROM $tableName');
    return (maps.first.values.first as num?)?.toDouble() ?? 0.0;
  }

  // Override do insert para adicionar logging
  @override
  Future<int> insert(Receita entity) async {
    final id = await super.insert(entity);
    print('✅ Receita inserida com ID: $id - ${entity.titulo}');
    return id;
  }

  // Override do update para adicionar logging
  @override
  Future<int> update(Receita entity) async {
    final count = await super.update(entity);
    print('✏️ Receita ${entity.id} atualizada. Linhas: $count');
    return count;
  }

  // Override do delete para adicionar logging
  @override
  Future<int> delete(int id) async {
    final count = await super.delete(id);
    print('🗑️ Receita $id deletada. Linhas: $count');
    return count;
  }

  // Buscar receitas favoritas do usuário
  Future<List<Receita>> buscarReceitasFavoritas(int userId) async {
    final db = await database;

    // Query que traz a receita
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT r.*
      FROM ${AppTables.USUARIO_RECEITA_FAVORITA} rc
      INNER JOIN ${AppTables.RECEITA} r ON rc.receita_id = r.id
      WHERE rc.usuario_id = ?
    ''',
      [userId],
    );

    final List<Receita> receitasCompletas = [];
    for (final map in maps) {
      final receitaBase = fromMap(map);
      if (receitaBase.id == null) continue;

      receitasCompletas.add(
        receitaBase.copyWith(
          // tags: tags,
          // ingredientes: ingredientes,
        ),
      );
    }
    return receitasCompletas;
  }

  Future<bool> toggleFavoriteReceita({
    required int userId,
    required int receitaId,
  }) async {
    final db = await database;

    final maps = await db.query(
      AppTables.USUARIO_RECEITA_FAVORITA,
      where: 'usuario_id = ? AND receita_id = ?',
      whereArgs: [userId, receitaId],
    );

    if (maps.isEmpty) {
      await db.insert(AppTables.USUARIO_RECEITA_FAVORITA, {
        'usuario_id': userId,
        'receita_id': receitaId,
        'data_adicao': DateTime.now().toString(),
      });
    } else {
      await db.delete(
        AppTables.USUARIO_RECEITA_FAVORITA,
        where: 'usuario_id = ? AND receita_id = ?',
        whereArgs: [userId, receitaId],
      );
    }

    return maps.isNotEmpty;
  }

  Future<bool> receitaIsFavorite({
    required int userId,
    required int receitaId,
  }) async {
    final db = await database;

    final maps = await db.query(
      AppTables.USUARIO_RECEITA_FAVORITA,
      where: 'usuario_id = ? AND receita_id = ?',
      whereArgs: [userId, receitaId],
    );
    return maps.isNotEmpty;
  }
}
