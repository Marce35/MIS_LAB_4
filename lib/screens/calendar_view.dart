import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/exam_event_provider.dart';
import 'create_exam_event_view.dart';
import 'map_view.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final examEventProvider = Provider.of<ExamEventProvider>(context);
    final examEventsForSelectedDate = examEventProvider.getExamEventsForDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams calendar \n(213280)',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.greenAccent,
        elevation: 7.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MapView()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              eventLoader: (day) =>
                  examEventProvider.getExamEventsForDate(day).map((e) => e.title).toList(),
              calendarStyle: const CalendarStyle(
                todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
                todayDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                ),
                selectedDecoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.arrow_back, color: Colors.greenAccent),
                rightChevronIcon: Icon(Icons.arrow_forward, color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: examEventsForSelectedDate.length,
                itemBuilder: (ctx, i) {
                  final examEvent = examEventsForSelectedDate[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 7.0),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      title: Text(
                        "Exam for: ${examEvent.title}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        'Time: ${examEvent.dateTime.hour.toString().padLeft(2, '0')}:${examEvent.dateTime.minute.toString().padLeft(2, '0')}\nLocation: ${examEvent.locationName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateExamEventView()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}