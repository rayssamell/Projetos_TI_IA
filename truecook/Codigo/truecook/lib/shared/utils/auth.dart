
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/routes/app_routes.dart';

Future<void> isLoggedIn(VoidCallback action, context, mounted) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final navigator = Navigator.of(context);

  //  Verifica o login
  final bool estaLogado = await authProvider.isLoggedIn();
  if (!mounted) return;

  if (estaLogado) {
    action();
  } else {
    // Redireciona para o Login
    navigator.pushNamed(AppRoutes.LOGIN);
  }
}
