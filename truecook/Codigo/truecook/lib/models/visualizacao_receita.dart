class VisualizacaoReceita {
  final int usuario_id;
  final int receita_id;
  final DateTime data_visualizacao;

  VisualizacaoReceita({
    required this.usuario_id,
    required this.receita_id,
    required this.data_visualizacao,
  });

  factory VisualizacaoReceita.fromMap(Map<String, dynamic> map) {
    return VisualizacaoReceita(
      usuario_id: map['usuario_id'],
      receita_id: map['receita_id'],
      data_visualizacao: DateTime.parse(map['data_visualizacao']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuario_id,
      'receita_id': receita_id,
      'data_visualizacao': data_visualizacao.toIso8601String(),
    };
  }

  VisualizacaoReceita copyWith({
    int? usuario_id,
    int? receita_id,
    DateTime? data_visualizacao,
  }) {
    return VisualizacaoReceita(
      usuario_id: usuario_id ?? this.usuario_id,
      receita_id: receita_id ?? this.receita_id,
      data_visualizacao: data_visualizacao ?? this.data_visualizacao,
    );
  }

  @override
  String toString() =>
      'VisualizacaoReceita(usuario: $usuario_id, receita: $receita_id)';
}
