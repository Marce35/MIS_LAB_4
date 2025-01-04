import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import '../providers/exam_event_provider.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Location _location = Location();
  LatLng? _currentUserLocation;
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

  void _getCurrentUserLocation() async {
    final locData = await _location.getLocation();
    setState(() {
      _currentUserLocation = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (_currentUserLocation == null) return;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${_currentUserLocation!.longitude},${_currentUserLocation!.latitude};${destination.longitude},${destination.latitude}?geometries=polyline');

    final response = await http.get(url);

    print('URL: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData['routes'] != null &&
          decodedData['routes'].isNotEmpty &&
          decodedData['routes'][0]['geometry'] != null) {
        String encodedPolyline = decodedData['routes'][0]['geometry'];

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result =
        polylinePoints.decodePolyline(encodedPolyline);

        final List<LatLng> points =
        result.map((point) => LatLng(point.latitude, point.longitude)).toList();

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: points,
              color: Colors.green,
              width: 6,
            ),
          );
        });
      } else {
        print("No valid route found!");
      }
    } else {
      print('Failed to fetch route');
    }
  }

  @override
  Widget build(BuildContext context) {
    final examEventProvider = Provider.of<ExamEventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.9981, 21.4253),
              zoom: 14,
            ),
            markers: examEventProvider.examsEvents
                .map(
                  (examEvent) => Marker(
                markerId: MarkerId(examEvent.id),
                position: examEvent.location,
                infoWindow: InfoWindow(
                  title: "Exam for subject: ${examEvent.title}",
                  snippet:
                      'Click to get directions',
                  onTap: () {
                    _drawRoute(examEvent.location);
                  },
                ),
              ),
            )
                .toSet(),
            polylines: _polylines,
            myLocationEnabled: true,
            onMapCreated: (controller) {
            },
          ),
        ],
      ),
    );
  }
}