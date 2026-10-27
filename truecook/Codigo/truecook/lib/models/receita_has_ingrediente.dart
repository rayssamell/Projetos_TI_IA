class ReceitaHasIngrediente {
  final int receitaId;
  final int ingrediente_id;
  final double? quantidade;
  final String? observacoes;

  ReceitaHasIngrediente({
    required this.receitaId,
    required this.ingrediente_id,
    this.quantidade,
    this.observacoes,
  });

  factory ReceitaHasIngrediente.fromMap(Map<String, dynamic> map) {
    return ReceitaHasIngrediente(
      receitaId: map['receita_id'],
      ingrediente_id: map['ingrediente_id'],
      quantidade: map['quantidade'] != null
          ? (map['quantidade'] as num).toDouble()
          : null,
      observacoes: map['observacoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receita_id': receitaId,
      'ingrediente_id': ingrediente_id,
      'quantidade': quantidade,
      'observacoes': observacoes,
    };
  }

  ReceitaHasIngrediente copyWith({
    int? receitaId,
    int? ingrediente_id,
    double? quantidade,
    String? observacoes,
  }) {
    return ReceitaHasIngrediente(
      receitaId: receitaId ?? this.receitaId,
      ingrediente_id: ingrediente_id ?? this.ingrediente_id,
      quantidade: quantidade ?? this.quantidade,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  @override
  String toString() =>
      'ReceitaHasIngrediente(receita: $receitaId, ingrediente: $ingrediente_id)';
}
