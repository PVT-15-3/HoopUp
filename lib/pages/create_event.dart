import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import '../classes/event.dart';
import '../classes/time.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final Time _eventDate = Time(
      startTime: DateTime(2023, 9, 7, 17), endTime: DateTime(2024, 9, 7, 17));

  final _eventCourtIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the event';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _eventCourtIdController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location for the event';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _eventDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description for the event';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitForm() {
   HoopUpUser newUser = HoopUpUser(
            username: 'kalle',
            skillLevel: 3,
            id: 'test id',
            photoUrl:
                'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png');
  
    print('${_eventCourtIdController.text} -  ${_eventNameController.text} - ${_eventDate.toJson()}');
    Event event = Event(
        name: _eventNameController.text,
        description: _eventDescriptionController.text,
        time: _eventDate,
        courtId: _eventCourtIdController.text,
        creatorId: newUser.id);

        print('${event.toJson()}');
        }
}
