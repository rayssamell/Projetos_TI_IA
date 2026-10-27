// [Arquivo: models/comercio.dart]

class Comercio {
  final int? id; // Seu ID local do SQLite (auto-increment)
  final String nome;
  final String? tipo;
  final String localizacao;
  final String? descricao;
  final String? foto;
  final double? avaliacao;
  final String? horarioFuncionamento;
  final double latitude;
  final double longitude;
  final double? distanciaDoUsuario;

  Comercio({
    this.id,
    required this.nome,
    this.tipo,
    required this.localizacao,
    this.descricao,
    this.foto,
    this.avaliacao,
    this.horarioFuncionamento,
    required this.latitude,
    required this.longitude,
    // --- CAMPO ADICIONADO AO CONSTRUTOR ---
    this.distanciaDoUsuario,
  });

  // Construtor de fábrica para criar um Comércio a partir do JSON da API Yelp
  // (Versão 100% segura contra nulos)
  factory Comercio.fromYelpJson(Map<String, dynamic> json) {
    // Helper para montar o endereço (agora aceita location nulo)
    String getEndereco(Map<String, dynamic>? location) {
      if (location == null) {
        return 'Localização não disponível';
      }
      final displayAddress = location['display_address'] as List?;
      if (displayAddress != null && displayAddress.isNotEmpty) {
        return displayAddress.join(', '); // Ex: "Rua Exemplo, 123, Bairro, Cidade"
      }
      return 'Localização não disponível';
    }

    // Helper para montar o tipo
    String? getTipo(List<dynamic>? categories) {
      if (categories == null || categories.isEmpty) {
        return null;
      }
      // Pega todos os 'title' das categorias e junta com vírgula
      return categories.map((cat) => cat['title'] as String).join(', ');
    }

    return Comercio(
      // Campos obrigatórios do Modelo (com valores padrão)
      nome: json['name'] as String? ?? 'Nome não disponível',
      localizacao: getEndereco(json['location']),
      latitude: (json['coordinates']?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['coordinates']?['longitude'] as num?)?.toDouble() ?? 0.0,

      // Campos nuláveis
      foto: json['image_url'] as String?,
      avaliacao: (json['rating'] as num?)?.toDouble(),
      tipo: getTipo(json['categories']),

      // Campos que o Yelp Search API não fornece:
      descricao: null, // A API de busca não fornece uma descrição
      horarioFuncionamento:
          null, // Exigiria uma chamada separada para /businesses/{id}
      // distanciaDoUsuario é null por padrão
    );
  }

  // Construtor de fábrica para criar um Comércio a partir do Banco de Dados
  // (Versão 100% segura contra nulos e COM O CAMPO 'idExterno' FALTANTE)
  factory Comercio.fromMap(Map<String, dynamic> map) {
    return Comercio(
      id: map['id'],

      // --- CORREÇÕES PARA STRINGS OBRIGATÓRIAS ---
      nome: map['nome'] as String? ?? 'Nome não disponível',
      localizacao: map['localizacao'] as String? ?? 'Localização não disponível',

      // --- CORREÇÕES PARA DOUBLES OBRIGATÓRIOS ---
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,

      // --- CAMPOS QUE JÁ SÃO NULÁVEIS (Estavam corretos) ---
      tipo: map['tipo'] as String?,
      descricao: map['descricao'] as String?,
      foto: map['foto'] as String?,
      horarioFuncionamento: map['horario_funcionamento'] as String?,
      avaliacao:
          map['avaliacao'] != null ? (map['avaliacao'] as num).toDouble() : null,
   
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'localizacao': localizacao,
      'descricao': descricao,
      'foto': foto,
      'avaliacao': avaliacao,
      'horario_funcionamento': horarioFuncionamento,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Comercio copyWith({
    int? id,
    String? nome,
    String? tipo,
    String? localizacao,
    String? descricao,
    String? foto,
    double? avaliacao,
    String? horarioFuncionamento,
    double? latitude,
    double? longitude,
    double? distanciaDoUsuario, 
  }) {
    return Comercio(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      localizacao: localizacao ?? this.localizacao,
      descricao: descricao ?? this.descricao,
      foto: foto ?? this.foto,
      avaliacao: avaliacao ?? this.avaliacao,
      horarioFuncionamento:
          horarioFuncionamento ?? this.horarioFuncionamento,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,

      distanciaDoUsuario: distanciaDoUsuario ?? this.distanciaDoUsuario,
    );
  }

  @override
  String toString() => 'Comercio(id: $id, nome: $nome)';

  void operator [](String other) {}
}