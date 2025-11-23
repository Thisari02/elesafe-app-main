import 'package:elesafe_app/features/alert/models/alert_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final AlertDataModel alertData;

  const MapScreen({super.key, required this.alertData});

  @override
  Widget build(BuildContext context) {
    final coordinates = alertData.location;
    // Print the coordinates to the console for debugging
    print('Map Coordinates: ${coordinates.latitude}, ${coordinates.longitude}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: coordinates,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: coordinates,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
