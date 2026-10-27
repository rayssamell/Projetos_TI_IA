import 'package:truecook/shared/enums/enumTables.dart';

String createUsuario() {
  print('🧱 Criando tabela ${AppTables.USUARIO}...');
  return ('''
        CREATE TABLE ${AppTables.USUARIO} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL,
            sexo TEXT CHECK (sexo IN ('M', 'F', 'O')),
            foto TEXT,
            endereco TEXT,
            telefone TEXT,
            data_nascimento DATE
          );
      ''');
}

String createTag() {
  print('🧱 Criando tabela ${AppTables.TAG}...');
  return ('''
          CREATE TABLE ${AppTables.TAG} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL UNIQUE
          );
      ''');
}

String createIngrediente() {
  print('🧱 Criando tabela ${AppTables.INGREDIENTE}...');
  return ('''
        CREATE TABLE ${AppTables.INGREDIENTE} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          tipo TEXT,
          unidade_medida TEXT
        );
      ''');
}

String createReceita() {
  print('🧱 Criando tabela ${AppTables.RECEITA}...');
  return ('''
      CREATE TABLE ${AppTables.RECEITA} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT,
        imagem TEXT,
        passo_a_passo TEXT,
        tempo_preparo INTEGER,
        observacoes TEXT,
        data_publicacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES ${AppTables.USUARIO}(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
      );
      ''');
}

String createComercio() {
  print('🧱 Criando tabela ${AppTables.COMERCIO}...');
  return ('''
        CREATE TABLE ${AppTables.COMERCIO} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          tipo TEXT,
          localizacao TEXT,
          descricao TEXT,
          foto TEXT,
          avaliacao REAL,
          horario_funcionamento TEXT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL
        );
      ''');
}

String createComentario() {
  print('🧱 Criando tabela ${AppTables.COMENTARIO}...');
  return ('''
        CREATE TABLE ${AppTables.COMENTARIO} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          texto TEXT NOT NULL,
          data_publicacao DATETIME DEFAULT CURRENT_TIMESTAMP,
          avaliacao INTEGER CHECK (avaliacao BETWEEN 1 AND 5),
          curtidas INTEGER DEFAULT 0,
          usuario_id INTEGER NOT NULL,
          receita_id INTEGER NOT NULL,
          FOREIGN KEY (usuario_id) REFERENCES ${AppTables.USUARIO}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
          FOREIGN KEY (receita_id) REFERENCES ${AppTables.RECEITA}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
        );
      ''');
}

String createReceitaHasIngrediente() {
  print('🧱 Criando tabela ${AppTables.RECEITA_HAS_INGREDIENTE}...');
  return ('''
        CREATE TABLE ${AppTables.RECEITA_HAS_INGREDIENTE} (
          receita_id INTEGER NOT NULL,
          ingrediente_id INTEGER NOT NULL,
          quantidade REAL,
          observacoes TEXT,
          PRIMARY KEY (receita_id, ingrediente_id),
          FOREIGN KEY (receita_id) REFERENCES ${AppTables.RECEITA}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
          FOREIGN KEY (ingrediente_id) REFERENCES ${AppTables.INGREDIENTE}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
        );
      ''');
}

String createUsuarioHasTag() {
  print('🧱 Criando tabela ${AppTables.USUARIO_HAS_TAG}...');
  return ('''
    CREATE TABLE ${AppTables.USUARIO_HAS_TAG} (
      usuario_id INTEGER NOT NULL,
      tag_id INTEGER NOT NULL,
      PRIMARY KEY (usuario_id, tag_id),
      FOREIGN KEY (usuario_id) REFERENCES ${AppTables.USUARIO}(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES ${AppTables.TAG}(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
  );
''');
}

String createReceitaHasTag() {
  print('🧱 Criando tabela ${AppTables.RECEITA_HAS_TAG}...');
  return ('''
        CREATE TABLE ${AppTables.RECEITA_HAS_TAG} (
          receita_id INTEGER NOT NULL,
          tag_id INTEGER NOT NULL,
          PRIMARY KEY (receita_id, tag_id),
          FOREIGN KEY (receita_id) REFERENCES ${AppTables.RECEITA}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
          FOREIGN KEY (tag_id) REFERENCES ${AppTables.TAG}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
        );
      ''');
}

String createUsuarioReceitaFavorita() {
  print('🧱 Criando tabela ${AppTables.USUARIO_RECEITA_FAVORITA}...');
  return ('''
      CREATE TABLE ${AppTables.USUARIO_RECEITA_FAVORITA} (
        usuario_id INTEGER NOT NULL,
        receita_id INTEGER NOT NULL,
        data_adicao DATETIME DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (usuario_id, receita_id),
        FOREIGN KEY (usuario_id) REFERENCES ${AppTables.USUARIO}(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE,
        FOREIGN KEY (receita_id) REFERENCES ${AppTables.RECEITA}(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
      );
      ''');
}

String createVisualizacaoReceita() {
  print('🧱 Criando tabela ${AppTables.VISUALIZACAO_RECEITA}...');
  return ('''
        CREATE TABLE ${AppTables.VISUALIZACAO_RECEITA} (
          usuario_id INTEGER NOT NULL,
          receita_id INTEGER NOT NULL,
          data_visualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (usuario_id, receita_id),
          FOREIGN KEY (usuario_id) REFERENCES ${AppTables.USUARIO}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
          FOREIGN KEY (receita_id) REFERENCES ${AppTables.RECEITA}(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
        );
      ''');
}
