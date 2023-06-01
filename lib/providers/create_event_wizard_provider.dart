import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/court.dart';
import '../classes/event.dart';
import '../classes/time.dart';
import 'firebase_provider.dart';

FirebaseProvider firebaseProvider = FirebaseProvider();

class CreateEventWizardProvider extends ChangeNotifier {
  //TODO fix this shit
  // CreateEventWizardProvider({required FirebaseProvider firebaseProvider}) {
  //   firebaseProvider = firebaseProvider;
  // }

  DateTime _eventDate = DateTime.now();
  TimeOfDay _eventStartTime = TimeOfDay.now();
  TimeOfDay _eventEndTime = TimeOfDay.now();
  int _numberOfParticipants = 2;
  String _selectedGender = "";
  int _minimumAge = 13;
  int _maximumAge = 100;
  int _skillLevel = 1;
  String _eventName = "";
  String _eventDescription = "";
  String _courtId = "";
  Court? _court;
  String _userId = "";
  bool _wizardFirstStepMapSelected = false;
  bool _wizardFirstStepTimeSelected = false;
  bool _wizardSecondStepGenderSelected = false;
  bool _wizardSecondStepAgeGroupSelected = false;
  bool _wizardSecondStepSkillLevelSelected = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  List<int> daysInMonth = [];
  int selectedStartHour = TimeOfDay.now().hour;
  int selectedStartMinute = TimeOfDay.now().minute;
  int selectedEndHour = TimeOfDay.now().hour;
  late int selectedEndMinute;
  bool _genderAllSelected = false;
  bool _ageGroupAllSelected = false;
  bool _skillLevelAllSelected = false;
  Color? _color;
  bool _isEventTimeAvailable = false;
  String _checkEventAvailabilityMessage = "";
  Timer? _availabilityCheckTimer;
  final StreamController<bool> _eventAvailabilityController =
      StreamController<bool>();
  Stream<bool> get eventAvailabilityStream =>
      _eventAvailabilityController.stream;

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

  int get minimumAge => _minimumAge;

  set minimumAge(int minimumAge) {
    _minimumAge = minimumAge;
    notifyListeners();
  }

  int get maximumAge => _maximumAge;

  set maximumAge(int maximumAge) {
    _maximumAge = maximumAge;
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

  Court? get court => _court;

  set court(Court? court) {
    _court = court;
    notifyListeners();
  }

  String get userId => _userId;

  set userId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  bool get wizardFirstStepMapSelected {
    return _wizardFirstStepMapSelected;
  }

  set wizardFirstStepMapSelected(bool value) {
    _wizardFirstStepMapSelected = value;
    notifyListeners();
  }

  bool get wizardFirstStepTimeSelected {
    return _wizardFirstStepTimeSelected;
  }

  set wizardFirstStepTimeSelected(bool value) {
    _wizardFirstStepTimeSelected = value;
    notifyListeners();
  }

  bool get wizardSecondStepGenderSelected => _wizardSecondStepGenderSelected;

  set wizardSecondStepGenderSelected(bool value) {
    _wizardSecondStepGenderSelected = value;
    notifyListeners();
  }

  bool get wizardSecondStepAgeGroupSelected =>
      _wizardSecondStepAgeGroupSelected;

  set wizardSecondStepAgeGroupSelected(bool value) {
    _wizardSecondStepAgeGroupSelected = value;
    notifyListeners();
  }

  bool get wizardSecondStepSkillLevelSelected =>
      _wizardSecondStepSkillLevelSelected;

  set wizardSecondStepSkillLevelSelected(bool value) {
    _wizardSecondStepSkillLevelSelected = value;
    notifyListeners();
  }

  bool get genderAllSelected => _genderAllSelected;

  set genderAllSelected(bool value) {
    _genderAllSelected = value;
    notifyListeners();
  }

  bool get ageGroupAllSelected => _ageGroupAllSelected;

  set ageGroupAllSelected(bool value) {
    _ageGroupAllSelected = value;
    notifyListeners();
  }

  bool get skillLevelAllSelected => _skillLevelAllSelected;

  set skillLevelAllSelected(bool value) {
    _skillLevelAllSelected = value;
    notifyListeners();
  }

  bool get isEventTimeAvailable => _isEventTimeAvailable;

  set isEventTimeAvailable(bool value) {
    _isEventTimeAvailable = value;
    notifyListeners();
  }

  Color? get color => _color;

  set color(Color? value) {
    _color = value;
    notifyListeners();
  }

  String get checkEventAvailabilityMessage => _checkEventAvailabilityMessage;

  set checkEventAvailabilityMessage(String checkEventAvailabilityMessage) {
    _checkEventAvailabilityMessage = checkEventAvailabilityMessage;
    notifyListeners();
  }

  void updateColorFirstStep(
      bool isMapSelected, bool isTimeSelected, bool isEventTimeAvailable) {
    bool wizardFirstStepComplete =
        isMapSelected && isTimeSelected && isEventTimeAvailable;
    color = wizardFirstStepComplete
        ? const Color(0xFFFC8027)
        : const Color(0xFF959595);
  }

  void onMapSelectedChanged(bool newValue) {
    wizardFirstStepMapSelected = newValue;
    updateColorFirstStep(wizardFirstStepMapSelected,
        wizardFirstStepTimeSelected, isEventTimeAvailable);
  }

  void onTimeSelectedChanged() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventStartTime.hour,
      eventStartTime.minute,
    );

    DateTime thirtyMinutesFromNow = now.add(const Duration(minutes: 30));
    bool isStartTimeValid =
        startTime.isAfter(thirtyMinutesFromNow) && startTime.isAfter(now);

    DateTime endTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventEndTime.hour,
      eventEndTime.minute,
    );
    bool isEndTimeValid =
        endTime.isAfter(startTime.add(const Duration(minutes: 55)));

    wizardFirstStepTimeSelected = isStartTimeValid && isEndTimeValid;
    updateColorFirstStep(wizardFirstStepMapSelected,
        wizardFirstStepTimeSelected, isEventTimeAvailable);
  }

  void onGenderSelectedChanged(bool newValue) {
    wizardSecondStepGenderSelected = newValue;
    updateColorSecondStep(wizardSecondStepGenderSelected);
  }

  void updateColorSecondStep(bool isGenderSelected) {
    bool wizardSecondStageComplete = isGenderSelected;
    color = wizardSecondStageComplete
        ? const Color(0xFFFC8027)
        : const Color(0xFF959595);
  }

  void updateEventDate() {
    _eventDate = DateTime(selectedYear, selectedMonth, selectedDay);
    notifyListeners();
  }

  void setSelectedMonth(int month) {
    selectedMonth = month;
    updateDaysInMonth();
    updateEventDate();
  }

  void setSelectedYear(int year) {
    selectedYear = year;
    updateDaysInMonth();
    updateEventDate();
  }

  void setSelectedDay(int day) {
    selectedDay = day;
    notifyListeners();
    updateEventDate();
  }

  void updateDaysInMonth() {
    final days = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final isLeap = isLeapYear(selectedYear);

    daysInMonth = List.generate(days, (index) => index + 1);

    if (!isLeap && selectedMonth == 2 && selectedDay == 29) {
      selectedDay =
          28; // Adjust the selected day if it was set to 29 in a non-leap year
    } else if (selectedDay > days) {
      selectedDay =
          days; // Adjust the selected day if it exceeds the maximum days in the month
    }

    notifyListeners();
  }

  bool isLeapYear(int year) {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else if (year % 400 != 0) {
      return false;
    } else {
      return true;
    }
  }

  void checkEventAvailability() async {
    List<Event> eventsList = await firebaseProvider.getAllEventsFromFirebase();
    bool isAvailable = true;

    for (Event event in eventsList) {
      if (event.courtId == court?.courtId) {
        if (isTimeOverlap(event.time)) {
          DateFormat format = DateFormat('HH:mm');
          String startTime = format.format(event.time.startTime);
          String endTime = format.format(event.time.endTime);

          checkEventAvailabilityMessage =
              "${court?.name} is occupied by another event the following time: $startTime - $endTime";
          isAvailable = false;
          break;
        }
      }
    }

    DateTime now = DateTime.now();
    DateTime startTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventStartTime.hour,
      eventStartTime.minute,
    );

    DateTime thirtyMinutesFromNow = now.add(const Duration(minutes: 30));
    bool isStartTimeValid =
        startTime.isAfter(thirtyMinutesFromNow) && startTime.isAfter(now);

    DateTime endTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventEndTime.hour,
      eventEndTime.minute,
    );
    bool isEndTimeValid =
        endTime.isAfter(startTime.add(const Duration(minutes: 55)));

    wizardFirstStepTimeSelected = isStartTimeValid && isEndTimeValid;

    isEventTimeAvailable = isAvailable;
    updateColorFirstStep(wizardFirstStepMapSelected,
        wizardFirstStepTimeSelected, isEventTimeAvailable);
    notifyListeners();
  }

  bool isTimeOverlap(Time eventTime) {
    DateTime wizardStartTime = DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _eventStartTime.hour,
      _eventStartTime.minute,
    );
    DateTime wizardEndTime = DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _eventEndTime.hour,
      _eventEndTime.minute,
    );

    if (wizardStartTime.isBefore(eventTime.endTime) &&
        wizardEndTime.isAfter(eventTime.startTime)) {
      return true;
    } else {
      return false;
    }
  }

  void reset() {
    _eventDate = DateTime.now();
    _eventStartTime = TimeOfDay.now();
    _eventEndTime = TimeOfDay.now();
    _numberOfParticipants = 2;
    _selectedGender = "";
    _minimumAge = 13;
    _maximumAge = 100;
    _skillLevel = 1;
    _eventName = "";
    _eventDescription = "";
    _courtId = "";
    _court = null;
    _userId = "";
    _wizardFirstStepMapSelected = false;
    _wizardFirstStepTimeSelected = false;
    _wizardSecondStepGenderSelected = false;
    _wizardSecondStepAgeGroupSelected = false;
    _wizardSecondStepSkillLevelSelected = true;
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    selectedDay = DateTime.now().day;
    selectedStartHour = TimeOfDay.now().hour;
    selectedStartMinute = TimeOfDay.now().minute;
    selectedEndHour = TimeOfDay.now().hour;
    selectedEndMinute = TimeOfDay.now().minute;
    _genderAllSelected = false;
    _ageGroupAllSelected = false;
    _skillLevelAllSelected = false;
    _color = null;
    _isEventTimeAvailable = false;

    notifyListeners();
  }

  ValueNotifier<TimeOfDay> get eventEndTimeNotifier {
    return ValueNotifier<TimeOfDay>(_eventEndTime);
  }
}
