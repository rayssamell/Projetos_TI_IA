// [Arquivo: lib/shared/components/custom_bar.dart]

import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  
  // --- 1. ADICIONADO O CONTROLLER ---
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.controller, // --- 2. ADICIONADO AO CONSTRUTOR ---
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

// --- 3. MUDADO DE STATELESS PARA STATEFUL ---
// Isso é necessário para podermos "ouvir" o controller e 
// saber quando mostrar/esconder o botão de limpar.
class _CustomSearchBarState extends State<CustomSearchBar> {
  
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    // Se um controller foi passado, adiciona um listener
    if (widget.controller != null) {
      widget.controller!.addListener(_onTextChanged);
      // Verifica o estado inicial
      _showClearButton = widget.controller!.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    // Remove o listener para evitar vazamento de memória
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  // Listener que atualiza o estado do botão
  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _showClearButton = widget.controller!.text.isNotEmpty;
      });
    }
  }

  // Função para limpar o texto
  void _clearText() {
    widget.controller?.clear();
    widget.onChanged(''); // Dispara o onChanged com texto vazio
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redDefault, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.orangeQuest),
          Expanded(
            child: TextField(
              // --- 4. PASSADO O CONTROLLER PARA O TEXTFIELD ---
              controller: widget.controller, 
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: 'Procura um lugar em específico?',
                hintStyle: TextStyle(color: AppColors.redDefault.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // --- 5. LÓGICA DO BOTÃO ATUALIZADA ---
          // Mostra 'X' se houver texto, senão mostra o 'filtro'
          IconButton(
            onPressed: _showClearButton 
              ? _clearText // Se o 'X' está visível, limpa o texto
              : () {
                  // Ação do botão de filtro (se não houver texto)
                  print("Botão de filtro pressionado");
                },
            icon: Icon(
              _showClearButton ? Icons.close : Icons.tune, // Ícone dinâmico
              color: AppColors.orangeQuest
            ),
          ),
        ],
      ),
    );
  }
}