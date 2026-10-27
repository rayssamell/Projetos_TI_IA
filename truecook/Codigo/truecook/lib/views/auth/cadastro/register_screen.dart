import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  @override
  _RegisterFormScreenState createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _endereco = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmarSenha = TextEditingController();

  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  Future<void> _cadastrarUsuario() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final nome = _nome.text.trim();
    final email = _email.text.trim();
    final endereco = _endereco.text.trim();
    final telefone = _telefone.text.trim();
    final senha = _senha.text.trim();
    final confirmarSenha = _confirmarSenha.text.trim();

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(
        content: Text('As senhas não coincidem!'),
        backgroundColor: AppColors.redDefault,
      ));
      return;
    }

    try {
      final usuarioCadastrado = await authProvider.cadastrarUsuario(
        nome,
        email,
        endereco,
        telefone,
        senha,
      );

      if (!mounted) return;

      if (usuarioCadastrado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado com sucesso!'),
            backgroundColor: AppColors.greenDefault,
          ),
        );

        Navigator.of(context).pushNamed(AppRoutes.QUESTIONARIO);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao cadastrar. Verifique os campos.'),
            backgroundColor: AppColors.redDefault,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
        content: Text('Ocorreu um erro: $e'),
        backgroundColor: AppColors.redDefault,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);

    final OutlineInputBorder textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.orangeDefault, width: 1.5),
    );

    final OutlineInputBorder focusedTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.orangeHome, width: 2.0),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Cadastre-se aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 32.0),
                TextField(
                  controller: _nome,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    hintText: 'Seu nome',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _endereco,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    hintText: 'Rua X',
                    prefixIcon: const Icon(
                      Icons.home_outlined,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _telefone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(XX) XXXXX-XXXX',
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _senha,
                  obscureText: _obscureSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.kIconColor,
                      ),
                      onPressed: () {
                        setState(() => _obscureSenha = !_obscureSenha);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _confirmarSenha,
                  obscureText: _obscureConfirmarSenha,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.orangeDefault,
                    ),
                    labelStyle: const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: textFieldBorder,
                    focusedBorder: focusedTextFieldBorder,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.kIconColor,
                      ),
                      onPressed: () {
                        setState(
                          () =>
                              _obscureConfirmarSenha = !_obscureConfirmarSenha,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _cadastrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeHome,
                    foregroundColor: AppColors.allWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}