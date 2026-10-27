import 'package:truecook/data/repositories/comentario_repository.dart';
import 'package:truecook/models/comentario.dart';
import 'package:truecook/provider/crud_provider.dart';

class ComentarioProvider
    extends CrudProvider<Comentario, ComentarioRepository> {
  ComentarioProvider() : super(ComentarioRepository());

  Future<void> adicionarComentario(
    String texto,
    double avaliacao,
    int usuarioId,
    int receitaId,
  ) async {
    final Comentario novoComentario = Comentario(
      texto: texto,
      data_publicacao: DateTime.now(),
      avaliacao: avaliacao,
      usuarioId: usuarioId,
      receitaId: receitaId,
    );

    print('🌱 Adicionando comentário... ($novoComentario)');
    super.adicionar(novoComentario);
  }

  Future<List<Comentario>?> buscarComentariosReceita(int receitaId) async {
    print('🌱 Buscando comentários de receita... ($receitaId)');
    return await repository.findByReceitaId(receitaId);
  }
}
