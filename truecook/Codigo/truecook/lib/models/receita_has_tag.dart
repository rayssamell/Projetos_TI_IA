class ReceitaHasTag {
  final int receita_id;
  final int tag_id;

  ReceitaHasTag({required this.receita_id, required this.tag_id});

  factory ReceitaHasTag.fromMap(Map<String, dynamic> map) {
    return ReceitaHasTag(receita_id: map['receita_id'], tag_id: map['tag_id']);
  }

  Map<String, dynamic> toMap() {
    return {'receita_id': receita_id, 'tag_id': tag_id};
  }

  ReceitaHasTag copyWith({int? receita_id, int? tag_id}) {
    return ReceitaHasTag(
      receita_id: receita_id ?? this.receita_id,
      tag_id: tag_id ?? this.tag_id,
    );
  }

  @override
  String toString() => 'ReceitaHasTag(receita: $receita_id, tag: $tag_id)';
}
