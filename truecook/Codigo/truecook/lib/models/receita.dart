import 'package:truecook/models/comentario.dart';
import 'package:truecook/models/ingrediente.dart';
import 'package:truecook/models/tag.dart';

/// Modelo de dados da Receita.
/// - Define os atributos principais: título, ingredientes, modo de preparo, tags.
/// - Usado em telas e providers de receitas.

class Receita {
  final int? id;
  final String titulo;
  final String? imagem;
  final String? descricao;
  final int tempo_preparo; // em minutos
  final String passo_a_passo;
  final String? observacoes;
  final DateTime data_publicacao;
  final int usuario_id;
  final int distancia;
  final int visualizacoes;
  final double avaliacoes;
  final List<Tag> tags;
  final List<Ingrediente> ingredientes;
  final List<Comentario> comentarios;

  Receita({
    this.id,
    required this.titulo,
    this.imagem,
    this.descricao,
    required this.data_publicacao,
    required this.tempo_preparo,
    this.observacoes,
    required this.passo_a_passo,
    required this.usuario_id,
    this.visualizacoes = 0,
    this.avaliacoes = 0,
    this.distancia = 0,
    this.tags = const [],
    this.ingredientes = const [],
    this.comentarios = const [],
  });

  // Converter MAP → OBJETO (do banco para o app)
  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'] ?? '',
      imagem: map['imagem'],
      passo_a_passo: map['passo_a_passo'] ?? '',
      tempo_preparo: map['tempo_preparo'] ?? 0,
      observacoes: map['observacoes'],
      data_publicacao: DateTime.parse(map['data_publicacao']),
      usuario_id: map['usuario_id'],
    );
  }

  // Converter OBJETO → MAP (do app para o banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagem': imagem,
      'passo_a_passo': passo_a_passo,
      'tempo_preparo': tempo_preparo,
      'observacoes': observacoes,
      'data_publicacao': data_publicacao.toIso8601String(),
      'usuario_id': usuario_id,
    };
  }

  // Método para criar cópia (útil para updates)
  Receita copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? imagem,
    String? passo_a_passo,
    int? tempo_preparo,
    String? observacoes,
    DateTime? data_publicacao,
    int? usuario_id,
    int? visualizacoes,
    double? avaliacoes,
    int? distancia,
    List<Tag>? tags,
    List<Ingrediente>? ingredientes,
    List<Comentario>? comentarios,
  }) {
    return Receita(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      imagem: imagem ?? this.imagem,
      passo_a_passo: passo_a_passo ?? this.passo_a_passo,
      tempo_preparo: tempo_preparo ?? this.tempo_preparo,
      observacoes: observacoes ?? this.observacoes,
      data_publicacao: data_publicacao ?? this.data_publicacao,
      usuario_id: usuario_id ?? this.usuario_id,
      visualizacoes: visualizacoes ?? this.visualizacoes,
      avaliacoes: avaliacoes ?? this.avaliacoes,
      distancia: distancia ?? this.distancia,
      tags: tags ?? this.tags,
      ingredientes: ingredientes ?? this.ingredientes,
      comentarios: comentarios ?? this.comentarios,
    );
  }

  @override
  String toString() {
    return 'Receita(id: $id, titulo: $titulo, tempo_preparo: $tempo_preparo)';
  }
}
