import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:elesafe_app/features/alert/models/alert_data_model.dart';

class MapScreen extends StatefulWidget {
  final AlertDataModel? alertData;

  const MapScreen({super.key, this.alertData});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final CameraTargetBounds _cameraTargetBounds = CameraTargetBounds(lankaBounds);
  final MinMaxZoomPreference _minMaxZoomPreference = const MinMaxZoomPreference(5.0, 16.0);
  late CameraPosition _initialCameraPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    // Set initial camera position based on alert data or default to Sri Lanka
    if (widget.alertData != null) {
      _initialCameraPosition = CameraPosition(
        target: widget.alertData!.location,
        zoom: 14.0,
      );
      _addAlertMarker();
    } else {
      _initialCameraPosition = const CameraPosition(
        target: LatLng(7.8731, 80.7718), // Default to Sri Lanka
        zoom: 7.5,
      );
    }
  }

  void _addAlertMarker() {
    if (widget.alertData != null) {
      final marker = Marker(
        markerId: MarkerId(widget.alertData!.id),
        position: widget.alertData!.location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.alertData!.title,
          snippet: widget.alertData!.description,
        ),
      );
      _markers.add(marker);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: false,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            indoorViewEnabled: false,
            trafficEnabled: false,
            cameraTargetBounds: _cameraTargetBounds,
            minMaxZoomPreference: _minMaxZoomPreference,
            mapType: MapType.normal,
            onTap: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              _mapController.hideMarkerInfoWindow(MarkerId(widget.alertData!.id));
            },
          ),

          // Alert info card if alert data is available
          if (widget.alertData != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFff4444),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.alertData!.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.alertData!.timestamp,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.alertData!.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lat: ${widget.alertData!.location.latitude.toStringAsFixed(4)}, '
                            'Lng: ${widget.alertData!.location.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final LatLngBounds lankaBounds = LatLngBounds(
  southwest: const LatLng(5.9167, 79.6600),
  northeast: const LatLng(9.8333, 81.8800),
);
