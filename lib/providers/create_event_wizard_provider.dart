import 'package:flutter/material.dart';
import '../classes/court.dart';

class CreateEventWizardProvider extends ChangeNotifier {
  DateTime _eventDate = DateTime.now();
  TimeOfDay _eventStartTime = TimeOfDay.now();
  TimeOfDay _eventEndTime = TimeOfDay.now();
  int _numberOfParticipants = 2;
  String _selectedGender = "";
  String _selectedAgeGroup = "";
  int _skillLevel = 1;
  String _eventName = "";
  String _eventDescription = "";
  String _courtId = "";
  Court? _court;
  String _userId = "";
  bool _wizardFirstStepSelected = true;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  List<int> daysInMonth = [];
  int selectedStartHour = TimeOfDay.now().hour;
  int selectedStartMinute = TimeOfDay.now().minute;
  int selectedEndHour = TimeOfDay.now().hour;
  int selectedEndMinute = TimeOfDay.now().minute;
  bool _genderAllSelected = false;
  bool _ageGroupAllSelected = false;
  bool _skillLevelAllSelected = false;

  DateTime get eventDate => _eventDate;

  set eventDate(DateTime eventDate) {
    _eventDate = eventDate;
    notifyListeners();
  }

  void updateEventDate() {
    if (wizardFirstStepSelected) {
      _eventDate = DateTime(selectedYear, selectedMonth, selectedDay);
      notifyListeners();
    }
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

  bool get wizardFirstStepSelected {
    return _wizardFirstStepSelected;
  }

  set wizardFirstStepSelected(bool value) {
    _wizardFirstStepSelected = value;
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

  void reset() {
    _eventDate = DateTime.now();
    _eventStartTime = TimeOfDay.now();
    _eventEndTime = TimeOfDay.now();
    _numberOfParticipants = 2;
    _selectedGender = "";
    _selectedAgeGroup = "";
    _skillLevel = 1;
    _eventName = "";
    _eventDescription = "";
    _courtId = "";
    _court = null;
    _userId;
    bool _wizardFirstStepSelected = true;
    int selectedYear = DateTime.now().year;
    int selectedMonth = DateTime.now().month;
    int selectedDay = DateTime.now().day;
    List<int> daysInMonth = [];
    int selectedStartHour = TimeOfDay.now().hour;
    int selectedStartMinute = TimeOfDay.now().minute;
    int selectedEndHour = TimeOfDay.now().hour;
    int selectedEndMinute = TimeOfDay.now().minute;
    bool _genderAllSelected = false;
    bool _ageGroupAllSelected = false;
    bool _skillLevelAllSelected = false;

    notifyListeners();
  }

  ValueNotifier<TimeOfDay> get eventEndTimeNotifier {
    return ValueNotifier<TimeOfDay>(_eventEndTime);
  }
}
