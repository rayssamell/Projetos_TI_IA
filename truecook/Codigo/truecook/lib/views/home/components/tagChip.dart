import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> tagUiDetails = {
  // --- Estilo de Vida (Verde) ---
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
  'Saudável': {
    'icon': Icons.health_and_safety,
    'bg': Color(0xFFD4E8D7),
    'fg': Color(0xFF4C985A),
  },

  // --- Fitness (Laranja) ---
  'Fitness': {
    'icon': Icons.fitness_center,
    'bg': Color(0xFFFEE8DF),
    'fg': Color(0xFFE56A21),
  },
  'Low Carb': {
    'icon': Icons.trending_down,
    'bg': Color(0xFFFEE8DF),
    'fg': Color(0xFFE56A21),
  },
  'Baixo Calorias': {
    'icon': Icons.local_fire_department,
    'bg': Color(0xFFFEE8DF),
    'fg': Color(0xFFE56A21),
  },

  // --- Saúde / Restrições (Azul) ---
  'Colesterol alto': {
    'icon': Icons.heart_broken,
    'bg': Color(0xFFD4E6FA),
    'fg': Color(0xFF3886DA),
  },
  'Diabético': {
    'icon': Icons.bloodtype,
    'bg': Color(0xFFD4E6FA),
    'fg': Color(0xFF3886DA),
  },

  // --- ALERGIAS E RESTRIÇÕES FORTES (Amarelo/Laranja de Alerta) ---
  'Celíaco': {
    'icon': Icons.local_pizza, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFF3886DA),
  },
  'Intolerante a Lactose': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergias': {
    'icon': Icons.warning_amber_rounded,
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Ovo': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Amendoim': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Peixe': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Soja': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Nozes e Castanhas': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },
  'Alergia a Frutos do Mar': {
    'icon': Icons.warning_amber_rounded, // Ícone de Alerta
    'bg': Color(0xFFFFE0B2),
    'fg': Color(0xFFEF6C00),
  },

  // --- Padrão ---
  'default': {
    'icon': Icons.label,
    'bg': Color(0xFFE0E0E0),
    'fg': Color(0xFF616161),
  },
};

class TagChip extends StatelessWidget {
  final String tagName;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const TagChip({
    super.key,
    required this.tagName,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final uiDetails = tagUiDetails[tagName] ?? tagUiDetails['default']!;
    final icon = uiDetails['icon'] as IconData;
    final bgColor = uiDetails['bg'] as Color;
    final fgColor = uiDetails['fg'] as Color;

    final labelColor = isSelected ? bgColor : fgColor;
    final avatarColor = isSelected ? bgColor : fgColor;
    final chipBackgroundColor = isSelected ? fgColor : bgColor;

    return FilterChip(
      label: Text(
        tagName,
        style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),
      ),
      avatar: Icon(icon, color: avatarColor, size: 18),
      backgroundColor: bgColor,
      selectedColor: fgColor,
      selected: isSelected,
      pressElevation: 1.5,
      autofocus: true,
      mouseCursor: chipBackgroundColor == Colors.transparent
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
        
      onSelected: onSelected,
      side: BorderSide(color: Colors.transparent),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      labelPadding: const EdgeInsets.only(left: 4),
      avatarBorder: const CircleBorder(side: BorderSide.none),
    );
  }
}
