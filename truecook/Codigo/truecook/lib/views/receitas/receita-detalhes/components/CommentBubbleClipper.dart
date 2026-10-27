import 'package:flutter/material.dart';

class CommentBubbleClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double tipSize; // Tamanho do bico (altura e base)

  CommentBubbleClipper({this.borderRadius = 10.0, this.tipSize = 10.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;

    // Ponto onde o bico começa (verticalmente, um pouco abaixo do topo)
    double tipStart = height / 2 - tipSize;

    // 1. Inicia o Path (canto superior esquerdo - logo após o bico)
    path.moveTo(tipSize + borderRadius, 0);

    // 2. Linha superior (Top)
    path.lineTo(width - borderRadius, 0);

    // 3. Canto superior direito
    path.arcToPoint(
      Offset(width, borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // 4. Linha lateral direita
    path.lineTo(width, height - borderRadius);

    // 5. Canto inferior direito
    path.arcToPoint(
      Offset(width - borderRadius, height),
      radius: Radius.circular(borderRadius),
    );

    // 6. Linha inferior (Bottom)
    path.lineTo(tipSize + borderRadius, height);

    // 7. Canto inferior esquerdo (onde o corpo do balão encontra o bico)
    path.arcToPoint(
      Offset(tipSize, height - borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // 8. Desenha o bico na lateral esquerda
    path.lineTo(tipSize, tipStart + tipSize * 2); // Base do bico
    path.lineTo(0, tipStart + tipSize); // Ponta do bico
    path.lineTo(tipSize, tipStart); // Topo do bico

    // 9. Conecta ao início do balão (canto superior esquerdo)
    path.lineTo(tipSize, borderRadius);

    // 10. Canto superior esquerdo
    path.arcToPoint(
      Offset(tipSize + borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CommentBubbleClipper oldClipper) => false;
}
