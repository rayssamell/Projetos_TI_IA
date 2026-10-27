import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/firebase_options.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:truecook/models/receita.dart';
import 'package:truecook/provider/ReceitaCadastroForm_Provider.dart';
import 'package:truecook/provider/auth_provider.dart';
import 'package:truecook/provider/comentario_provider.dart';
import 'package:truecook/provider/comercio_provider.dart';
import 'package:truecook/provider/igredientes_provider.dart';
import 'package:truecook/provider/receita_has_igrediente_provider.dart';
import 'package:truecook/provider/receita_provider.dart';
import 'package:truecook/provider/tag_provider.dart';
import 'package:truecook/provider/user_provider.dart';
import 'package:truecook/provider/usuario_has_tag_provider.dart';
import 'package:truecook/provider/visualizacao_receita_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/views/perfil/perfil.dart';
import 'package:truecook/views/receitas/receita-cadastro/receitaCadastro_screen.dart';
import 'package:truecook/views/receitas/receita-list/receitaList_screen.dart';
import 'package:truecook/views/home/home_screen.dart';
import 'package:truecook/views/auth/cadastro/register_screen.dart';
import 'package:truecook/views/auth/inicial/inicial_screen.dart';
import 'package:truecook/views/auth/login/login_screen.dart';
import 'package:truecook/views/receitas/receita-detalhes/receitaDetalhes_screen.dart';
import 'package:truecook/views/questionario/questionario.dart';
import 'package:truecook/views/comercio/components/ComercioScreen.dart';
import 'package:truecook/views/camera/camera_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IngredientesProvider>(
          create: (context) => IngredientesProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider<ComercioProvider>(
          create: (context) => ComercioProvider(),
        ),
        ChangeNotifierProvider<ReceitaProvider>(
          create: (context) => ReceitaProvider(),
        ),
        ChangeNotifierProvider<ComercioProvider>(
          create: (context) => ComercioProvider(),
        ),
        ChangeNotifierProvider(create: (context) => UsuarioHasTagProvider()),
        ChangeNotifierProvider(
          create: (context) => ReceitaHasIgredienteProvider(),
        ),
        ChangeNotifierProvider<TagProvider>(create: (context) => TagProvider()),
        ChangeNotifierProvider<ComentarioProvider>(
          create: (context) => ComentarioProvider(),
        ),
        ChangeNotifierProvider<VisualizacaoReceitaProvider>(
          create: (context) => VisualizacaoReceitaProvider(),
        ),

        ChangeNotifierProvider(
          create: (context) => ReceitaCadastroFormProvider(),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orangeDefault),
        ),
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.INDEX: (context) => InicialScreen(),
          AppRoutes.HOME: (context) => HomeScreen(),
          AppRoutes.RECEITAS_MOSTRAR: (context) => ReceitaListScreen(),
          AppRoutes.RECEITAS_DETALHES: (context) => ReceitaDetalhesScreen(
            receita: ModalRoute.of(context)!.settings.arguments as Receita,
          ),
          AppRoutes.RECEITAS_CADASTRO: (context) => ReceitaCadastroScreen(),
          AppRoutes.QUESTIONARIO: (context) => QuestionarioPerfil(),
          AppRoutes.CADASTRO: (context) => RegisterFormScreen(),
          AppRoutes.LOGIN: (context) => LoginScreen(),
          AppRoutes.COMERCIO: (context) => ComercioScreen(),
          AppRoutes.GERADOR_RECEITAS: (context) => GeradorReceitasView(),
          AppRoutes.PERFIL: (context) => ProfileScreen(),
        },
      ),
    );
  }
}
