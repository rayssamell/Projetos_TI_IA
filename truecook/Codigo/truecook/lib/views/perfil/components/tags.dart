import 'package:flutter/material.dart';

/// Mapa global com os detalhes de UI (ícones e cores) para cada Tag.
final Map<String, Map<String, dynamic>> kTagUiDetails = {
  'Celíaco': {
    'icon': Icons.local_pizza,
    'bg': Color(0xFFD4E6FA),
    'fg': Color(0xFF3886DA),
  },
  'Vegano': {
    'icon': Icons.eco,
    'bg': Color(0xFFD4E8D7),
    'fg': Color(0xFF4C985A),
  },
  'Vegetariano': {
    'icon': Icons.eco,
    'bg': Color(0xFFD4E8D7),
    'fg': Color.fromARGB(255, 23, 146, 46),
  },
  // ... (cole todo o resto do seu mapa aqui) ...
  'Intolerante a Lactose': {
    'icon': Icons.health_and_safety,
    'bg': Color(0xFFD4E8D7),
    'fg': Color(0xFF4C985A),
  },
  'default': {
    'icon': Icons.label,
    'bg': Color(0xFFE0E0E0),
    'fg': Color(0xFF616161),
  },
};