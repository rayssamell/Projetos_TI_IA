import 'package:truecook/models/usuario.dart';

class Comentario {
  final int? id;
  final String texto;
  final DateTime data_publicacao;
  final double avaliacao; // 1-5
  final int curtidas;
  final int usuarioId;
  final int receitaId;
  final Usuario? usuario;

  Comentario({
    this.id,
    required this.texto,
    required this.data_publicacao,
    required this.avaliacao,
    this.curtidas = 0,
    required this.usuarioId,
    required this.receitaId,
    this.usuario,
  });

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      id: map['id'],
      texto: map['texto'],
      data_publicacao: DateTime.parse(map['data_publicacao']),
      avaliacao: (map['avaliacao'] ?? 0).toDouble(),
      curtidas: map['curtidas'] ?? 0,
      usuarioId: map['usuario_id'],
      receitaId: map['receita_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'data_publicacao': data_publicacao.toIso8601String(),
      'avaliacao': avaliacao,
      'curtidas': curtidas,
      'usuario_id': usuarioId,
      'receita_id': receitaId,
    };
  }

  Comentario copyWith({
    int? id,
    String? texto,
    DateTime? data_publicacao,
    double? avaliacao,
    int? curtidas,
    int? usuarioId,
    int? receitaId,
    Usuario? usuario,
  }) {
    return Comentario(
      id: id ?? this.id,
      texto: texto ?? this.texto,
      data_publicacao: data_publicacao ?? this.data_publicacao,
      avaliacao: avaliacao ?? this.avaliacao,
      curtidas: curtidas ?? this.curtidas,
      usuarioId: usuarioId ?? this.usuarioId,
      receitaId: receitaId ?? this.receitaId,
      usuario: usuario ?? this.usuario,
    );
  }

  @override
  String toString() =>
      'Comentario(id: $id, texto: $texto, avaliacao: $avaliacao, curtidas: $curtidas)';

}
