// alert_data_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertDataModel {
  final String id;
  final String title;
  final String timestamp;
  final LatLng location;
  final String description;

  AlertDataModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.location,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'timestamp': timestamp,
    'description': description,
    'location': {
      'lat': location.latitude,
      'lng': location.longitude,
    },
  };

  factory AlertDataModel.fromFirestore(String id, Map<String, dynamic> json) {
    final locationData = json['location'];
    LatLng location;

    if (locationData is GeoPoint) {
      location = LatLng(locationData.latitude, locationData.longitude);
    } else if (locationData is Map) {
      location = LatLng(
        (locationData['lat'] as num).toDouble(),
        (locationData['lng'] as num).toDouble(),
      );
    } else {
      location = LatLng(0, 0); // fallback
    }

    return AlertDataModel(
      id: id,
      title: json['title'] ?? '',
      timestamp: json['timestamp'] ?? '',
      description: json['description'] ?? '',
      location: location,
    );
  }
}
