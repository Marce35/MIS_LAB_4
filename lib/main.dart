import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exam_event_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'screens/calendar_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ),
    ],
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const CalendarExamApp());
}

class CalendarExamApp extends StatelessWidget {
  const CalendarExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExamEventProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Exam calendar',
        theme: ThemeData(primarySwatch: Colors.green),
        home: CalendarView(),
      ),
    );
  }
}