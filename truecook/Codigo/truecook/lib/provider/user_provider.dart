import 'package:flutter/material.dart';
import 'package:truecook/data/repositories/usuario_repository.dart';
import 'package:truecook/models/usuario.dart';

class UserProvider with ChangeNotifier {
  final UsuarioRepository _repository = UsuarioRepository();

  // Estado
  List<Usuario> _usuarios = []; 
  Usuario? _usuarioSelecionado; 
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Getters
  List<Usuario> get usuarios => _usuarios;
  Usuario? get usuarioSelecionado =>
      _usuarioSelecionado; 
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  // Carrega todos os usuários
  Future<void> carregarUsuarios() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    print('🏃‍♂️‍➡️ Carregando usuarios...');
    try {
      _usuarios = await _repository.findAll();
      print('✅ Usuarios carregados: ${usuarios.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      print('❌ Erro ao carregar usuarios: $e');
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Carrega um usuário específico para a tela de perfil
  Future<void> carregarPerfilUsuario(int usuarioId) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    _usuarioSelecionado = null; // Limpa o usuário anterior enquanto carrega
    notifyListeners();

    print('🏃‍♂️‍➡️ Carregando perfil do usuário $usuarioId...');
    try {
      _usuarioSelecionado = await _repository.findById(usuarioId);

      if (_usuarioSelecionado == null) {
        print('❌ Usuário com ID $usuarioId não encontrado.');
        _hasError = true;
        _errorMessage = 'Usuário não encontrado.';
      } else {
        print('✅ Perfil carregado: ${_usuarioSelecionado!.nome}');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      print('❌ Erro ao carregar perfil: $e');
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Atualiza um usuário existente
  Future<void> atualizarUsuario(Usuario usuario) async {
    try {
      await _repository.update(usuario);

      // Atualiza na lista local (se ela estiver carregada)
      final index = _usuarios.indexWhere((u) => u.id == usuario.id);
      if (index != -1) {
        _usuarios[index] = usuario;
      }

      // Atualiza o usuário selecionado (se for o mesmo que está sendo editado)
      if (_usuarioSelecionado?.id == usuario.id) {
        _usuarioSelecionado = usuario;
      }

      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Erro ao atualizar usuário: ${e.toString()}';
      notifyListeners();
    }
  }

  // Deleta um usuário
  Future<void> deletarUsuario(int id) async {
    try {
      await _repository.delete(id);

      // Remove da lista local
      _usuarios.removeWhere((u) => u.id == id);

      // Limpa o usuário selecionado (se for o mesmo que foi deletado)
      if (_usuarioSelecionado?.id == id) {
        _usuarioSelecionado = null;
      }

      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Erro ao deletar usuário: ${e.toString()}';
      notifyListeners();
    }
  }

  // Limpa erros
  void limparErro() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}
