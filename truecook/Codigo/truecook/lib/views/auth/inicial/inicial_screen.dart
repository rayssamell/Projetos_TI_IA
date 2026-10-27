//[imports]
import 'package:flutter/material.dart';
import 'package:truecook/views/home/home_screen.dart';

/// Tela de Boas-Vindas (Splash Screen/Onboarding).
/// - Apresenta a marca e um convite inicial.
/// - Elementos animados para uma experiência mais envolvente.

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  _InicialScreenState createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen>
    with SingleTickerProviderStateMixin {
  //[variáveis de animação]
  late AnimationController _controller;
  late Animation<double> _bowlAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bowlAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //[paleta de cores]
    const Color primaryOrange = Color(0xFFF2853F);
    const Color backgroundLight = Color(0xFFFAEEDD);
    const Color textAccentOrange = Color(0xFFE55A45); // Cor do texto 'uma'

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          // Background - Curva Laranja Superior
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _bowlAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: TopClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45 * _bowlAnimation.value, // Anima a altura
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: primaryOrange,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0), // Ajuste para posicionar a imagem
                        child: Transform.scale(
                          scale: _bowlAnimation.value, // Anima a escala da tigela
                          child: Image.asset(
                            'assets/images/vegetables_bowl.png', // Verifique o caminho correto da imagem
                            height: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Conteúdo principal (Logo, Slogan, Botão)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Alinha os elementos mais para baixo
              children: [
                const Spacer(flex: 3), // Empurra o conteúdo para baixo
                // Logo TrueCook
                FadeTransition(
                  opacity: _controller,
                  child: Image.asset(
                    'assets/images/logo.png', // Verifique o caminho correto da imagem do logo
                    height: 120,
                  ),
                ),
                const SizedBox(height: 32.0),
                // Slogan
                SlideTransition(
                  position: _textAnimation,
                  child: FadeTransition(
                    opacity: _controller,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        children: [
                          const TextSpan(text: 'Um parceiro inovador para uma experiência\n'),
                          TextSpan(
                            text: 'culinária verdadeira!',
                            style: TextStyle(color: textAccentOrange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),
                
                //[Botão Bora!]
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Bora!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ... (a classe TopClipper continua a mesma) ...

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}