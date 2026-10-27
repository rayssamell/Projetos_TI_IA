import 'package:sqflite/sqflite.dart';
import 'package:truecook/shared/enums/enumTables.dart';

Future<void> seedUsuarioHasTag(Database db) async {
  print('🌱 Rodando seeds Usuario_has_Tag...');

  // Map de exemplo: usuario_id -> lista de tag_ids
  final Map<int, List<int>> usuarioTags = {
    1: [1, 2, 14], // Davi -> Celíaco, Diabético, Semi Industrializados
    2: [3, 15], // Carlos Oliveira -> Vegetariano, Lowcarb
    3: [4, 17], // Mariana Santos -> Vegano, 30 minutos ou menos
    4: [5, 18], // João Pereira -> Colesterol alto, Alto proteína
    5: [6, 19], // Fernanda Costa -> Intolerante a Lactose, Baixo Calorias
    6: [1, 20], // Ricardo Almeida -> Celíaco, Rico em Fibras
    7: [2, 3], // Juliana Rodrigues -> Diabético, Vegetariano
    8: [4, 5], // Pedro Henrique -> Vegano, Colesterol alto
    9: [6, 7], // Camila Ferreira -> Intolerante a Lactose, Ovo
    10: [8, 9], // Alex Green -> Amendoim, Peixe
  };

  for (final entry in usuarioTags.entries) {
    final usuarioId = entry.key;
    final tagIds = entry.value;

    for (final tagId in tagIds) {
      await db.insert(AppTables.USUARIO_HAS_TAG, {
        'usuario_id': usuarioId,
        'tag_id': tagId,
      });
    }
  }

  print('✅ Usuario_has_Tag seedada com sucesso!');
}
