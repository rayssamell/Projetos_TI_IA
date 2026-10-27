class Tag {
  final int? id;
  final String nome;

  Tag({this.id, required this.nome});

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'], nome: map['nome']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }

  Tag copyWith({int? id, String? nome}) {
    return Tag(id: id ?? this.id, nome: nome ?? this.nome);
  }

  @override
  String toString() => 'Tag(id: $id, nome: $nome)';
}
