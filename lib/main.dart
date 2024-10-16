import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Carte Google Maps')),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(48.8566, 2.3522), // Coordonnées de Paris
            zoom: 12,
          ),
        ),
      ),
    );
  }
}