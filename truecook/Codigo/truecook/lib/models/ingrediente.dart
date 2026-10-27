class Ingrediente {
  final int? id;
  final String nome;
  final String? tipo;
  final String? unidade_medida;

  Ingrediente({this.id, required this.nome, this.tipo, this.unidade_medida});

  factory Ingrediente.fromMap(Map<String, dynamic> map) {
    return Ingrediente(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      unidade_medida: map['unidade_medida'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'unidade_medida': unidade_medida,
    };
  }

  Ingrediente copyWith({
    int? id,
    String? nome,
    String? tipo,
    String? unidade_medida,
  }) {
    return Ingrediente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      unidade_medida: unidade_medida ?? this.unidade_medida,
    );
  }

  @override
  String toString() => 'Ingrediente(id: $id, nome: $nome, tipo: $tipo)';
}
