import 'package:google_maps_flutter/google_maps_flutter.dart';


class ExamEvent {
  final String id;
  final String title;
  final DateTime dateTime;
  final String locationName;
  final LatLng location;

  ExamEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.locationName,
    required this.location,
  });
}