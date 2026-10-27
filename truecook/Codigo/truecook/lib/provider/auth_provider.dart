import 'package:truecook/data/repositories/usuario_repository.dart';

import 'package:truecook/models/usuario.dart';

import 'package:truecook/provider/crud_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Provider responsável pela autenticação do usuário.

/// - Gerencia login, logout e cadastro.

/// - Controla o estado de autenticação no app.
// bool isLoggedIn = false;
class AuthProvider extends CrudProvider<Usuario, UsuarioRepository> {
  AuthProvider() : super(UsuarioRepository());
  final UsuarioRepository _repository = UsuarioRepository();

  // Função para cadastrar usuário
  Future<Usuario?> cadastrarUsuario(
    String _nome,
    String _email,
    String _endereco,
    String _telefone,
    String _senha,
  ) async {
    // Validação básica
    if (_nome.isEmpty ||
        _email.isEmpty ||
        _endereco.isEmpty ||
        _telefone.isEmpty ||
        _senha.isEmpty) {
      print('Erro: Todos os campos são obrigatórios.');

      return null;
    }

    try {
      // Cria objeto do usuário
      final novoUsuario = Usuario(
        nome: _nome,
        email: _email,
        endereco: _endereco,
        telefone: _telefone,
        senha: _senha,
      );

      // Salva no banco de dados
     final int novoId = await _repository.insert(novoUsuario);
      final Usuario? usuarioSalvo = await _repository.findById(novoId);

      if (usuarioSalvo != null && usuarioSalvo.id != null) {
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); 
        await prefs.setString('userEmail', usuarioSalvo.email); 
        await prefs.setString('userName', usuarioSalvo.nome);
        await prefs.setInt('user_id', usuarioSalvo.id!); 

        print('===== Usuário cadastrado E LOGADO com sucesso =====');
        print('ID: ${usuarioSalvo.id}, Nome: ${usuarioSalvo.nome}');
        print('=========================================');

        notifyListeners();
        return usuarioSalvo;
      }
      } catch (e) {
        print('Erro ao cadastrar usuário: $e');
        return null;
      }
  }

  /// Realiza o login validando credenciais e salvando sessão.
  Future<Usuario?> login(String email, String senha) async {
    final user = await _repository.authenticate(email, senha);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userName', user.nome);
      //Salva id do usuario
      await prefs.setInt('user_id', user.id!);

      print("Usuário autenticado e salvo no SharedPreferences.");
      print('ID do usuario logado: ${user?.id}');
      print('=========================================');
      return user;
    }
    print("Credenciais inválidas.");
    return null;
  }

  /// Retorna se há sessão ativa.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Retorna o e-mail do usuário logado.
  Future<String?> getLoggedUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  //Retorna o id do usuario logado
  Future<int?> getLoggedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

   static Future<int?> getLoggedUserIdStatic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

  //Retorna o nome do usuario logado
  Future<String?> getLoggedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userName");
  }

  /// Faz logout limpando sessão.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Usuário desconectado e SharedPreferences limpo.");
  }
}