import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  bool _isOtherSelected = false;
  final bool _isAllGenderSelected = false;
  bool _isAge13To17Selected = false;
  bool _isAge18To25Selected = false;
  bool _isAge26To35Selected = false;
  bool _isAge36To50Selected = false;
  final bool _isAllAgeSelected = false;
  bool _isAge50plusSelected = false;

  bool get isMaleSelected => _isMaleSelected;
  bool get isFemaleSelected => _isFemaleSelected;
  bool get isOtherSelected => _isOtherSelected;
  bool get isAllGenderSelected => _isAllGenderSelected;
  bool get isAge13To17Selected => _isAge13To17Selected;
  bool get isAge18To25Selected => _isAge18To25Selected;
  bool get isAge26To35Selected => _isAge26To35Selected;
  bool get isAge36To50Selected => _isAge36To50Selected;
  bool get isAllAgeSelected => _isAllAgeSelected;
  bool get isAge50plusSelected => _isAge50plusSelected;

  void toggleMaleSelected(bool value) {
    _isMaleSelected = value;
    notifyListeners();
  }

  List<String> getSelectedGenders() {
    List<String> selectedGenders = [];
    if (_isFemaleSelected) {
      selectedGenders.add('Female');
    }
    if (_isMaleSelected) {
      selectedGenders.add('Male');
    }
    if (_isOtherSelected) {
      selectedGenders.add('Other');
    }
    return selectedGenders;
  }

  List<String> getSelectedAge() {
    List<String> selectedAge = [];
    if (_isAge13To17Selected) {
      selectedAge.add('13-17');
    }
    if (_isAge18To25Selected) {
      selectedAge.add('18-25');
    }
    if (_isAge26To35Selected) {
      selectedAge.add('26-35');
    }
    if (_isAge36To50Selected) {
      selectedAge.add('36-50');
    }
    if (_isAge50plusSelected) {
      selectedAge.add('50+');
    }
    return selectedAge;
  }

  void toggleFemaleSelected(bool value) {
    _isFemaleSelected = value;
    notifyListeners();
  }

  void toggleOtherSelected(bool value) {
    _isOtherSelected = value;
    notifyListeners();
  }

  void toggleAge13To17Selected(bool value) {
    _isAge13To17Selected = value;
    notifyListeners();
  }

  void toggleAge18To25Selected(bool value) {
    _isAge18To25Selected = value;
    notifyListeners();
  }

  void toggleAge26To35Selected(bool value) {
    _isAge26To35Selected = value;
    notifyListeners();
  }

  void toggleAge36To50Selected(bool value) {
    _isAge36To50Selected = value;
    notifyListeners();
  }

  void toggleAge50plusSelected(bool value) {
    _isAge50plusSelected = value;
    notifyListeners();
  }
}
