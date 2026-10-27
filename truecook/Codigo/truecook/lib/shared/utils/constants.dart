import 'dart:ui';

/// Arquivo de constantes globais.
/// - Contém strings fixas, cores, espaçamentos, etc.
/// - Facilita manutenção do design system.
/// !!! ATENÇÃO !!!!
/// ToDo: As cores e valores padrões abaixo podem ser alteradas conforme a necessidade do projeto.

// Cores do App
class AppColors {
  static const Color backgroundPrimary = Color(
    0xFFF2E3BC,
  ); // Cor de fundo principal
  static const Color orangeDefault = Color(0xFFFFA559); // Laranja principal
  static const Color redDefault = Color.fromRGBO(
    229,
    89,
    52,
    1,
  ); // Vermelho principal
  static const Color greenDefault = Color(0xFF414535); // Verde principal
  static const Color greenLight = Color(0xFF618985); // Verde claro 1
  static const Color greenLight2 = Color(0xFF96BBBB); // Verde claro 2
  static const Color purpleDefault = Color(0xFF4A4458); // Verde claro 3
  static const Color allWhite = Color(0xFFFFFFFF); // Branco
  static const Color allBlack = Color(0xFF000000); // Preto
  static const Color orangeQuest = Color.fromARGB(
    255,
    241,
    139,
    43,
  ); // Outro tom de laranja
  static const Color orangeHome = Color(0xFFF2853F);
  static const kBackgroundColor = Color(0xFFFBF3E0);
  static const kPrimaryColor = Color(0xFFE87A5A);
  static const kIconColor = Color(0xFF6D4C41);
  static const kTextColor = Color(0xFF3E2723);
  static const kEmailColor = Color(0xFF795548);
}

// Configurações do App
class AppConfig {
  static const String appName = 'TrueCook'; // Versão do App
  static const String appVersion = '1.0.0'; // Nome do App
}

// Imagens do App
class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String DefaultImage =
      'https://i.pinimg.com/474x/53/99/63/539963e04679dfb98237957b589dfa0c.jpg'; // Imagem de teste
  static const String DefaultImage2 = "assets/images/ImgAddDefault.png";
}

// Espacamentos Padrões
class AppPaddings {
  static const double DefaultPadding = 20.0;
  static const double DefaultPaddingSmall = 10.0;
  static const double DefaultPaddingBig = 30.0;
}

// Raio de Bordas Padrão
class AppBorders {
  static const double DefaultBorderRadius = 10.0;
  static const double DefaultBorderRadiusSmall = 5.0;
  static const double DefaultBorderRadiusBig = 15.0;
}

// Margins externas Padrões
class AppMargins {
  static const double DefaultMarginSmall = 10.0;
  static const double DefaultMarginBig = 30.0;
  static const double DefaultMargin = 20.0;
}

// Tamanho de Fontes Padrão
class AppFontSizes {
  static const double DefaultFontSize = 16.0;
  static const double DefaultFontSizeSmall = 12.0;
  static const double DefaultFontSizeBig = 20.0;
}

// Tamanho de Icones Padrão
class AppIconSizes {
  static const double DefaultIconSize = 30.0;
  static const double DefaultIconSizeSmall = 20.0;
  static const double DefaultIconSizeBig = 40.0;
}

// Elevação Padrão (Sombras)
class AppElevations {
  static const double DefaultElevation = 4.0;
  static const double DefaultElevationSmall = 2.0;
  static const double DefaultElevationBig = 8.0;
}

// Largura de Bordas Padrão
class AppBorderWidth {
  static const double DefaultBorderWidth = 2.0;
  static const double DefaultBorderWidthSmall = 1.0;
  static const double DefaultBorderWidthBig = 4.0;
}

// Opacidade Padrão (Transparência)
class AppOpacities {
  static const double DefaultOpacity = 0.5;
  static const double DefaultOpacitySmall = 0.3;
  static const double DefaultOpacityBig = 0.7;
}
