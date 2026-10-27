import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:truecook/data/repositories/crud_repository.dart';
import 'package:truecook/models/comercio.dart';
import 'package:truecook/shared/enums/enumTables.dart';
import 'package:sqflite/sqflite.dart';

class ComercioRepository extends CrudRespository<Comercio> {
  // URL Raw do seu Gist (parece correta)
  final String _gistUrl =
      'https://gist.githubusercontent.com/letiicia1/fb29eeb65d118ce467a6caa3f7c68992/raw/0ca57bc94d73e8eed464f668d3a69befc9a2d15f/gistfile1.txt';

  ComercioRepository() : super(tableName: AppTables.COMERCIO);

  @override
  Comercio fromMap(Map<String, dynamic> map) => Comercio.fromMap(map);
  @override
  Map<String, dynamic> toMap(Comercio entity) => entity.toMap();

  @override
  Future<List<Comercio>> findAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => fromMap(map)).toList();
  }

  // --- MÉTODOS DE SINCRONIZAÇÃO COM API ---

  Future<void> syncFromApi() async {
    print("Iniciando sincronização com o Gist...");
    final url = Uri.parse(_gistUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> businesses = json.decode(response.body);

        if (businesses.isEmpty) {
          print("Gist não retornou nenhum comércio.");
          return;
        }
        print("Gist retornou ${businesses.length} comércios. Limpando banco local...");

        // ETAPA 1: Limpar o banco de dados local
        await _clearAll();

        print("Salvando ${businesses.length} novos comércios...");
        int count = 0;

        // ETAPA 2: Inserir cada item do Gist como um novo item
        for (var businessJson in businesses) {
          try {
           
            if (businessJson.containsKey('id')) {
              businessJson.remove('id');
            }
            
            final comercio = Comercio.fromMap(businessJson);

            print("imagem fornecida: ${comercio.foto}" );
            await _insert(comercio); // Usa um método simples de inserção
            count++;
          } catch (e) {
            print(
                "Erro ao mapear ou salvar comércio (Nome: ${businessJson['nome'] ?? 'Sem Nome'}): $e");
          }
        }
        print(
            "Sincronização concluída: $count comércios salvos.");
      } else {
        print("Erro ao acessar o Gist: ${response.statusCode}");
        print("Corpo: ${response.body}");
      }
    } catch (e) {
      print("Erro de rede ao sincronizar: $e");
    }
  }

  // Método auxiliar para limpar a tabela
  Future<void> _clearAll() async {
    final Database db = await database;
    await db.delete(tableName);
  }

  // Método auxiliar para inserir um novo comércio
  Future<void> _insert(Comercio comercio) async {
    final Database db = await database;
    await db.insert(
      tableName,
      comercio.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Garante a inserção
    );
  }
  
  // O método _findByExternoId não é mais necessário para a sincronização
  // O método _upsert não é mais necessário
}