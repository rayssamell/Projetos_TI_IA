// [Arquivo: views/comercio_screen.dart]

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truecook/models/comercio.dart';
import 'package:truecook/provider/comercio_provider.dart';
import 'package:truecook/routes/app_routes.dart';
import 'package:truecook/shared/components/custom_bar.dart';
import 'package:truecook/shared/components/custom_Scaffold.dart';
import 'package:truecook/shared/components/mapa_component.dart';
import 'package:truecook/shared/components/restauranteCard.dart'; // Verifique o nome do arquivo
import 'package:truecook/shared/utils/constants.dart';
import 'package:truecook/shared/components/detalhes_overlay.dart';

enum OverlayType { none, map, details }

class ComercioScreen extends StatefulWidget {
  const ComercioScreen({super.key});

  @override
  _ComercioScreenState createState() => _ComercioScreenState();
}

class _ComercioScreenState extends State<ComercioScreen> {
  Comercio? _selectedComercio;
  OverlayType _overlayState =
      OverlayType.none; // Agora 'OverlayType' é conhecido
  int _selectedIndex = 2;

  // Controlador para a barra de busca
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncComercios());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncComercios() async {
    final comercioProvider = Provider.of<ComercioProvider>(
      context,
      listen: false,
    );
    await comercioProvider.syncComercios();
  }

  void _closeOverlay() {
    setState(() {
      _overlayState = OverlayType.none;
      _selectedComercio = null;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.RECEITAS_MOSTRAR);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.COMERCIO);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.PERFIL);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Renomeei para 'provider' para ficar mais curto
    final provider = Provider.of<ComercioProvider>(context);

    return CustomScaffold(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.HOME),
        ),
        title: const Text('Restaurantes'),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.person), onPressed: () {})],
      ),
      body: Stack(
        children: [
          // === LISTA DE RESTAURANTES ===
          Column(
            children: [
              // 1. BARRA DE BUSCA
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: CustomSearchBar(
                  controller: _searchController, 
                  onChanged: (query) {
                    if (_overlayState != OverlayType.none) _closeOverlay();
                    provider.searchComercios(query);
                  },
                ),
              ),

              // 2. SELETOR "PRÓXIMOS" / "TODOS"
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: SegmentedButton<bool>(
                  segments: const <ButtonSegment<bool>>[
                    ButtonSegment<bool>(
                      value: true, // O valor que representa "Próximos"
                      label: Text('Próximos'),
                      icon: Icon(Icons.location_on_outlined),
                    ),
                    ButtonSegment<bool>(
                      value: false, // O valor que representa "Todos"
                      label: Text('Ver Todos'),
                      icon: Icon(Icons.list_alt_outlined),
                    ),
                  ],
                  selected: <bool>{provider.filtroProximidadeAtivo},
                  onSelectionChanged: (Set<bool> novaSelecao) {
                    provider.setFiltroProximidade(novaSelecao.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  showSelectedIcon: false,
                ),
              ),

              // 3. TÍTULO DINÂMICO DA LISTA
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    provider.filtroProximidadeAtivo
                        ? "Restaurantes Próximos"
                        : "Todos os Restaurantes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),

              // 4. LISTA DE RESULTADOS
              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.hasError)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Erro ao carregar restaurantes:\n${provider.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              // MENSAGEM SE A LISTA ESTIVER VAZIA
              else if (provider.filteredItems.isEmpty && !provider.isLoading)
                Expanded(
                  child: Center(
                    child: Text(
                      _searchController.text.isNotEmpty
                          ? 'Nenhum restaurante encontrado para "${_searchController.text}".'
                          : 'Nenhum restaurante encontrado nesta área.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // Remove padding do ListView
                    itemCount: provider.filteredItems.length,
                    itemBuilder: (context, index) {
                      final restaurante = provider.filteredItems[index];

                      // Formata a distância
                      String distanciaFormatada = '...'; // Padrão
                      if (restaurante.distanciaDoUsuario != null) {
                        distanciaFormatada =
                            "${restaurante.distanciaDoUsuario!.toStringAsFixed(1)} km";
                      }

                      // Retorna o Card
                      return RestauranteCard(
                        restaurante: restaurante,
                        distancia: distanciaFormatada,
                        onDetailsTap: () {
                          setState(() {
                            _selectedComercio = restaurante;
                            _overlayState = OverlayType.details;
                          });
                        },
                        onLocationTap: () {
                          setState(() {
                            _selectedComercio = restaurante;
                            _overlayState = OverlayType.map;
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),

          // === OVERLAY DESLIZANTE ===
          if (_overlayState != OverlayType.none && _selectedComercio != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  // 🔹 Se o overlay for tipo "map", mostra o mapa e o painel deslizante juntos
                  if (_overlayState == OverlayType.map)
                    MapaComponent(
                      restaurantes: [_selectedComercio!],
                      showSingleMarker: true,
                    )
                  else
                    // 🔹 Se for tipo "details", mostra só o painel de detalhes (arrastável)
                    DetalhesOverlay(comercio: _selectedComercio!),

                  // 🔹 Botão de fechar flutuante
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: _closeOverlay,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white70,
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
