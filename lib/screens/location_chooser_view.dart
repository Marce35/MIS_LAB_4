import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationChooserView extends StatefulWidget {
  @override
  _LocationChooserViewState createState() => _LocationChooserViewState();
}

class _LocationChooserViewState extends State<LocationChooserView> {
  LatLng? _chosenLocation;

  void _selectLocation(LatLng location) {
    setState(() {
      _chosenLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a location',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.greenAccent,
        actions: [
          if (_chosenLocation != null)
            IconButton(
              icon: const Icon(Icons.check,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pop(_chosenLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.9981, 21.4253), // Geo coordinates of Skopje, Macedonia
          zoom: 14,
        ),
        onTap: _selectLocation,
        markers: _chosenLocation == null
            ? {}
            : {
          Marker(
            markerId: const MarkerId('selected-location'),
            position: _chosenLocation!,
          ),
        },
      ),
    );
  }
}