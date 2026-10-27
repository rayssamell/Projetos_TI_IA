//[imports]
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';
import '../cadastro/register_screen.dart';
import 'package:truecook/provider/auth_provider.dart';

/// Tela de Login.
/// - Formulário de autenticação.
/// - Integração com auth_Provider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //variaveis
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    final NavigatorState navigator = Navigator.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //[LOGO]
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48.0),

                //[LOGIN]
                const Text(
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 24.0),

                //[EMAIL]
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@email.com',
                    prefixIcon:
                        const Icon(Icons.email, color: AppColors.orangeDefault),
                    labelStyle:
                        const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.orangeDefault,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.orangeHome,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                //[SENHA]
                TextField(
                  obscureText: _obscureText,
                  controller: _senha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon:
                        const Icon(Icons.lock, color: AppColors.orangeDefault),
                    labelStyle:
                        const TextStyle(color: AppColors.kTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.orangeDefault,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: AppColors.orangeHome,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.kIconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),

                //[BOTÃO ENTRAR]
                ElevatedButton(
                  onPressed: () async {
                    print('Tentando autenticar...');

                    final auth = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    try {
                      final user = await auth.login(
                        _email.text.trim(),
                        _senha.text.trim(),
                      );

                      //  verificar se o widget ainda está na tela
                      if (!mounted) return;

                      if (user != null) {
                        // Autenticação bem-sucedida
                        print('Login realizado com sucesso!');
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.HOME);
                      } else {
                        // Falha na autenticação (login retornou null)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('E-mail ou senha incorretos.'),
                            backgroundColor: AppColors.redDefault,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ocorreu um erro: $e'),
                          backgroundColor: AppColors.redDefault,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeHome,
                    foregroundColor: AppColors.allWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24.0),

                //LINK PARA CADASTRO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          'Ainda não tem conta? ',
                          style: TextStyle(color: AppColors.kTextColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Link Cadastre-se pressionado!');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterFormScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}