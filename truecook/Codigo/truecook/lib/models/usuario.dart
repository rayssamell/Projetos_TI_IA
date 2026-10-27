class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? sexo; // 'M', 'F', 'O'
  final String? foto;
  final String? endereco;
  final String? telefone;
  final DateTime? dataNascimento;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.sexo,
    this.foto,
    this.endereco,
    this.telefone,
    this.dataNascimento,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      sexo: map['sexo'],
      foto: map['foto'],
      endereco: map['endereco'],
      telefone: map['telefone'],
      dataNascimento: map['data_nascimento'] != null
          ? DateTime.parse(map['data_nascimento'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'sexo': sexo,
      'foto': foto,
      'endereco': endereco,
      'telefone': telefone,
      'data_nascimento': dataNascimento?.toIso8601String(),
    };
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? senha,
    String? sexo,
    String? foto,
    String? endereco,
    String? telefone,
    DateTime? dataNascimento,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      sexo: sexo ?? this.sexo,
      foto: foto ?? this.foto,
      endereco: endereco ?? this.endereco,
      telefone: telefone ?? this.telefone,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, senha: $senha, sexo: $sexo, foto: $foto, endereco: $endereco, telefone: $telefone, dataNascimento: $dataNascimento)';
  }
}
