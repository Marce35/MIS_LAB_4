import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          ledColor: Colors.white,
          defaultColor: const Color(0xFF68b0fe),
          importance: NotificationImportance.High,
        )
      ],
    );
  }

  Future<void> showNotification(String title, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }
}