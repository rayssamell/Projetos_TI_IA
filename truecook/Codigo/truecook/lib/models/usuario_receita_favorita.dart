class UsuarioReceitaFavorita {
  final int usuario_id;
  final int receita_id;
  final DateTime data_adicao;

  UsuarioReceitaFavorita({
    required this.usuario_id,
    required this.receita_id,
    required this.data_adicao,
  });

  factory UsuarioReceitaFavorita.fromMap(Map<String, dynamic> map) {
    return UsuarioReceitaFavorita(
      usuario_id: map['usuario_id'],
      receita_id: map['receita_id'],
      data_adicao: DateTime.parse(map['data_adicao']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuario_id,
      'receita_id': receita_id,
      'data_adicao': data_adicao.toIso8601String(),
    };
  }

  UsuarioReceitaFavorita copyWith({
    int? usuario_id,
    int? receita_id,
    DateTime? data_adicao,
  }) {
    return UsuarioReceitaFavorita(
      usuario_id: usuario_id ?? this.usuario_id,
      receita_id: receita_id ?? this.receita_id,
      data_adicao: data_adicao ?? this.data_adicao,
    );
  }

  @override
  String toString() =>
      'UsuarioReceitaFavorita(usuario: $usuario_id, receita: $receita_id)';
}
