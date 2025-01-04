import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab4_flutter/services/location_service.dart';
import '../models/exam_event.dart';
import '../services/notification_service.dart';

class ExamEventProvider with ChangeNotifier {
  final List<ExamEvent> _examsEvents = [];
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final Map<String, bool> _notifiedExamEvents = {};
  ExamEventProvider() {
    _notificationService.initialize();
    _locationService.startListening(_checkLocationProximity);
  }

  List<ExamEvent> get examsEvents => [..._examsEvents];

  void addExamEvent(String title, DateTime dateTime, LatLng location, String locationName) {
    final newExamEvent = ExamEvent(
      id: DateTime.now().toString(),
      title: title,
      dateTime: dateTime,
      locationName: locationName,
      location: location,
    );
    _examsEvents.add(newExamEvent);
    _notifiedExamEvents[newExamEvent.id] = false;
    notifyListeners();
  }

  List<ExamEvent> getExamEventsForDate(DateTime date) {
    return _examsEvents
        .where((examEvent) =>
          examEvent.dateTime.year == date.year &&
          examEvent.dateTime.month == date.month &&
          examEvent.dateTime.day == date.day)
          .toList();
  }

  void _checkLocationProximity(Position position) async {
    for (var examEvent in _examsEvents) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        examEvent.location.latitude,
        examEvent.location.longitude,
      );
      if (!_notifiedExamEvents[examEvent.id]! && distance < 300 ) {
        await _notificationService.showNotification(
          "Exam reminder",
          "You have an exam for subject: ${examEvent.title} less than 300 meters from your location.",
        );
        _notifiedExamEvents[examEvent.id] = true;
      }
    }
  }
}