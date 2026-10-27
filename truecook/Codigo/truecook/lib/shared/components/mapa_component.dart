// lib/shared/components/mapa_component.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/comercio.dart';
import 'detalhes_overlay.dart'; // importa o overlay deslizante

class MapaComponent extends StatefulWidget {
  final List<Comercio> restaurantes;
  final bool showSingleMarker;

  const MapaComponent({
    super.key,
    required this.restaurantes,
    this.showSingleMarker = false,
  });

  @override
  State<MapaComponent> createState() => _MapaComponentState();
}

class _MapaComponentState extends State<MapaComponent> {
  Comercio? comercioSelecionado;

  @override
  Widget build(BuildContext context) {
    if (widget.restaurantes.isEmpty) {
      return const Center(child: Text('Nenhum restaurante disponível.'));
    }

    final comercio = widget.restaurantes.first;

    // Marcadores do mapa
    final List<Marker> markers = widget.showSingleMarker
        ? [
            Marker(
              point: LatLng(comercio.latitude, comercio.longitude),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    comercioSelecionado = comercio;
                  });
                },
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ]
        : widget.restaurantes.map((restaurante) {
            return Marker(
              point: LatLng(restaurante.latitude, restaurante.longitude),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    comercioSelecionado = restaurante;
                  });
                },
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            );
          }).toList();

    // Posição inicial do mapa
    final LatLng initialPosition = LatLng(
      comercio.latitude,
      comercio.longitude,
    );

    return Stack(
      children: [
        // ===== MAPA =====
        FlutterMap(
          options: MapOptions(
            center: initialPosition,
            zoom: widget.showSingleMarker ? 15 : 12,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.truecook.app',
            ),
            MarkerLayer(markers: markers),
          ],
        ),

        // ===== OVERLAY DETALHES (deslizante) =====
        if (comercioSelecionado != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: DetalhesOverlay(comercio: comercioSelecionado!),
          ),
      ],
    );
  }
}
