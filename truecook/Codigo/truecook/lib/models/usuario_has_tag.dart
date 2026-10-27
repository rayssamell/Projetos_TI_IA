class UsuarioHasTag {
  final int usuario_id;
  final int tag_id;

  final String? id;

  UsuarioHasTag({required this.usuario_id, required this.tag_id, this.id,});

  factory UsuarioHasTag.fromMap(Map<String, dynamic> map) {
    return UsuarioHasTag(usuario_id: map['usuario_id'], tag_id: map['tag_id']);
  }

  Map<String, dynamic> toMap() {
    return {'usuario_id': usuario_id, 'tag_id': tag_id};
  }

  UsuarioHasTag copyWith({String? id, int? usuario_id, int? tag_id}) {
    return UsuarioHasTag(
      id: id ?? this.id,
      usuario_id: usuario_id ?? this.usuario_id,
      tag_id: tag_id ?? this.tag_id,
    );
  }

  @override
  String toString() => 'UsuarioHasTag(receita: $usuario_id, tag: $tag_id)';

  factory UsuarioHasTag.fromJson(Map<String, dynamic> json) {
    return UsuarioHasTag(
      //id do backend python
      id: json['id'] as String?, 
      
      // O 'user_id' do Json
      usuario_id: json['user_id'] as int, 
      
      // O 'tag_id' do JSON 
      tag_id: json['tag_id'] as int,   
    );
  }
}
