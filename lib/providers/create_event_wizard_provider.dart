import 'package:flutter/material.dart';

class CreateEventWizardProvider extends ChangeNotifier {
  DateTime _eventDate = DateTime.now();
  TimeOfDay _eventStartTime = TimeOfDay.now();
  TimeOfDay _eventEndTime = TimeOfDay.now();
  int _numberOfParticipants = 2;
  String _selectedGender = 'Female';
  String _selectedAgeGroup = '13-17';
  int _skillLevel = 1;
  String _eventName = '';
  String _eventDescription = "";
  String _courtId = "LocationId1";
  String? _userId = "";

  DateTime get eventDate => _eventDate;

  set eventDate(DateTime eventDate) {
    _eventDate = eventDate;
    notifyListeners();
  }

  TimeOfDay get eventStartTime => _eventStartTime;

  set eventStartTime(TimeOfDay eventStartTime) {
    _eventStartTime = eventStartTime;
    notifyListeners();
  }

  TimeOfDay get eventEndTime => _eventEndTime;

  set eventEndTime(TimeOfDay eventEndTime) {
    _eventEndTime = eventEndTime;
    notifyListeners();
  }

  int get numberOfParticipants => _numberOfParticipants;

  set numberOfParticipants(int numberOfParticipants) {
    _numberOfParticipants = numberOfParticipants;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;

  set selectedGender(String selectedGender) {
    _selectedGender = selectedGender;
    notifyListeners();
  }

  String get selectedAgeGroup => _selectedAgeGroup;

  set selectedAgeGroup(String selectedAgeGroup) {
    _selectedAgeGroup = selectedAgeGroup;
    notifyListeners();
  }

  int get skillLevel => _skillLevel;

  set skillLevel(int skillLevel) {
    _skillLevel = skillLevel;
    notifyListeners();
  }

  String get eventName => _eventName;

  set eventName(String eventName) {
    _eventName = eventName;
    notifyListeners();
  }

  String get eventDescription => _eventDescription;

  set eventDescription(String eventDescription) {
    _eventDescription = eventDescription;
    notifyListeners();
  }

  String get courtId => _courtId;

  set courtId(String courtId) {
    _courtId = courtId;
    notifyListeners();
  }

  String? get userId => _userId;

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  void reset() {
    _eventDate = DateTime.now();
    _eventStartTime = TimeOfDay.now();
    _eventEndTime = TimeOfDay.now();
    _numberOfParticipants = 2;
    _selectedGender = 'Female';
    _selectedAgeGroup = '13-17';
    _skillLevel = 1;
    _eventName = '';
    _eventDescription = "";
    _courtId = "LocationId1";
    _userId = "";
    notifyListeners();
  }

  ValueNotifier<TimeOfDay> get eventEndTimeNotifier {
    return ValueNotifier<TimeOfDay>(_eventEndTime);
  }
}
