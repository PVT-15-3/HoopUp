import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import '../classes/event.dart';
import '../classes/time.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

DateTime _selectedDate = DateTime.now();

class _CreateEventPageState extends State<CreateEventPage> {
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventCourtIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10.0),
                    Text('Press to slecect date'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text("Start Time"),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: Text("${_startTime.hour}:${_startTime.minute}"),
              ),
              const SizedBox(height: 20.0),
              const Text("End Time"),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endTime),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        picked.hour,
                        picked.minute,
                      );
                    });
                  }
                },
                child: Text("${_endTime.hour}:${_endTime.minute}"),
              ),
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
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
      ),
    );
  }

  submitForm() {
    Time eventDate = Time(startTime: _startTime, endTime: _endTime);
    HoopUpUser newUser = HoopUpUser(
        username: 'kalle',
        skillLevel: 3,
        id: 'test id',
        photoUrl:
            'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png');

    print(
        '${_eventCourtIdController.text} -  ${_eventNameController.text} - ${eventDate.toJson()}');
    Event event = Event(
      name: _eventNameController.text,
      description: _eventDescriptionController.text,
      time: eventDate,
      courtId: _eventCourtIdController.text,
      creatorId: newUser.id,
    );

    print('${event.toJson()}');
  }
}

_selectDate(dynamic context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2021),
    lastDate: DateTime(2025),
  );
  if (picked != null && picked != _selectedDate) {
    _selectedDate = picked;
    print(_selectedDate);
  }
}
