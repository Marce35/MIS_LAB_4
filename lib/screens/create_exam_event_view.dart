import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/exam_event_provider.dart';
import 'location_chooser_view.dart';

class CreateExamEventView extends StatefulWidget {
  @override
  _CreateExamEventState createState() => _CreateExamEventState();
}

class _CreateExamEventState extends State<CreateExamEventView> {
  final _titleController = TextEditingController();
  final _locationNameController = TextEditingController();
  LatLng? _selectedLocation;
  DateTime? _selectedDateTime;

  void _pickDateTime() async {
    final chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (chosenDate == null) return;

    final chosenTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (chosenTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        chosenDate.year,
        chosenDate.month,
        chosenDate.day,
        chosenTime.hour,
        chosenTime.minute,
      );
    });
  }

  void _pickLocation() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (ctx) => LocationChooserView()),
    );
    if (pickedLocation == null) return;
    setState(() {
      _selectedLocation = pickedLocation;
    });
  }

  void _saveExamEvent() {
    if (_titleController.text.isEmpty ||
        _selectedDateTime == null ||
        _selectedLocation == null ||
        _locationNameController.text.isEmpty) {
      return;
    }
    Provider.of<ExamEventProvider>(context, listen: false).addExamEvent(
      _titleController.text,
      _selectedDateTime!,
      _selectedLocation!,
      _locationNameController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const appBarColor = Colors.greenAccent;  // Accent Blue Color

    return Scaffold(
      appBar: AppBar(
        title: const Text('New exam',style: TextStyle(color: Colors.white),),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Name of the exam:',
                labelStyle: const TextStyle(color: appBarColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: appBarColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: appBarColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationNameController,
              decoration: InputDecoration(
                labelText: 'Location name:',
                labelStyle: const TextStyle(color: appBarColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: appBarColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: appBarColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Choose time and date'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedDateTime != null
                        ? '${'${_selectedDateTime!.toLocal()}'.split(' ')[0]} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}' : 'Time and date are not chosen',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Choose a location'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedLocation != null
                        ? '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}' : 'Location not chosen',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveExamEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button color
                foregroundColor: Colors.white, // Text color
                minimumSize: const Size(double.infinity, 50), // Full width and large height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}