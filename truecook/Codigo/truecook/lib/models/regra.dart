// Regras do Apriori
class Regra {
  final List<int> antecedents;
  final List<int> consequents;
  final double confidence;

  Regra({
    required this.antecedents,
    required this.consequents,
    required this.confidence,
  });

  factory Regra.fromJson(Map<String, dynamic> json) {
    return Regra(
      antecedents: List<int>.from(json['antecedents'].map((x) => x as int)),
      consequents: List<int>.from(json['consequents'].map((x) => x as int)),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}