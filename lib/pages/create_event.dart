import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';
import '../classes/time.dart';
import '../providers/hoopup_user_provider.dart';

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

  int _skillLevel = 1;
  int _numParticipants = 1;
  String _selectedGender = 'Female';
  String _selectedAgeGroup = '13-17';

  void _incrementSkillLevel() {
    setState(() {
      _skillLevel++;
    });
  }

  void _decrementSkillLevel() {
    setState(() {
      if (_skillLevel > 1) {
        _skillLevel--;
      }
    });
  }

  void _incrementNumParticipants() {
    setState(() {
      _numParticipants++;
    });
  }

  void _decrementNumParticipants() {
    setState(() {
      if (_numParticipants > 1) {
        _numParticipants--;
      }
    });
  }

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
              Row(
                children: [
                  const Text('Skill Level: '),
                  ElevatedButton(
                    onPressed: _decrementSkillLevel,
                    child: const Icon(Icons.remove),
                  ),
                  Text('$_skillLevel'),
                  ElevatedButton(
                    onPressed: _incrementSkillLevel,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text('Number of Participants: '),
                  ElevatedButton(
                    onPressed: _decrementNumParticipants,
                    child: const Icon(Icons.remove),
                  ),
                  Text('$_numParticipants'),
                  ElevatedButton(
                    onPressed: _incrementNumParticipants,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = 'Female';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == 'Female' ? Colors.blue : null,
                    ),
                    child: const Text('Female'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = 'Male';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == 'Male' ? Colors.blue : null,
                    ),
                    child: const Text('Male'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = 'Other';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == 'Other' ? Colors.blue : null,
                    ),
                    child: const Text('Other'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = 'All';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedGender == 'All' ? Colors.blue : null,
                    ),
                    child: const Text('All'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAgeGroup = '13-17';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedAgeGroup == '13-17' ? Colors.blue : null,
                    ),
                    child: const Text('13-17'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAgeGroup = '18+';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedAgeGroup == '18+' ? Colors.blue : null,
                    ),
                    child: const Text('18+'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAgeGroup = '55+';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedAgeGroup == '55+' ? Colors.blue : null,
                    ),
                    child: const Text('55+'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAgeGroup = 'All';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedAgeGroup == 'All' ? Colors.blue : null,
                    ),
                    child: const Text('All'),
                  ),
                ],
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
                    Navigator.pop(context);
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
    String? id =
        Provider.of<HoopUpUserProvider>(context, listen: false).user?.id;
    HoopUpUser newUser = HoopUpUser(
        username: 'kalle',
        skillLevel: 3,
        id: 'test id',
        photoUrl:
            'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
        gender: 'male');

    print(
        '${_eventCourtIdController.text} -  ${_eventNameController.text} - ${eventDate.toJson()}');
    Event event = Event(
        name: _eventNameController.text,
        description: _eventDescriptionController.text,
        time: eventDate,
        courtId: _eventCourtIdController.text,
        creatorId: id,
        skillLevel: _skillLevel,
        playerAmount: _numParticipants,
        ageGroup: _selectedAgeGroup,
        genderGroup: _selectedGender,
        id: const Uuid().v4(),);
    event.addEventToDatabase();

    print('${event.toJson()}');
    //HoopUpUserProvider().user!.addEvent(event);
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
