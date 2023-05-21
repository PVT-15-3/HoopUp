import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  bool _isOtherSelected = false;
  bool _isGenderAllSelected = false;
  bool _isAge13To17Selected = false;
  bool _isAge18To25Selected = false;
  bool _isAge26To35Selected = false;
  bool _isAge36To50Selected = false;
  bool _isAgeAllSelected = false;
  bool _isAge50plusSelected = false;
  int _skillLevel = 0;
  bool _isSkillLevelAllSelected = false;

  bool get isMaleSelected => _isMaleSelected;
  bool get isFemaleSelected => _isFemaleSelected;
  bool get isOtherSelected => _isOtherSelected;
  bool get isGenderAllSelected => _isGenderAllSelected;
  bool get isAge13To17Selected => _isAge13To17Selected;
  bool get isAge18To25Selected => _isAge18To25Selected;
  bool get isAge26To35Selected => _isAge26To35Selected;
  bool get isAge36To50Selected => _isAge36To50Selected;
  bool get isAgeAllSelected => _isAgeAllSelected;
  bool get isAge50plusSelected => _isAge50plusSelected;
  int get skillLevel => _skillLevel;
  bool get isSkillLevelAllSelected => _isSkillLevelAllSelected;

  void clearFilters() {
    _isMaleSelected = false;
    _isFemaleSelected = false;
    _isOtherSelected = false;
    _isGenderAllSelected = false;
    _isAge13To17Selected = false;
    _isAge18To25Selected = false;
    _isAge26To35Selected = false;
    _isAge36To50Selected = false;
    _isAgeAllSelected = false;
    _isAge50plusSelected = false;
    _skillLevel = 0;
    _isSkillLevelAllSelected = false;
    notifyListeners();
  }

  set isMaleSelected(bool value) {
    _isMaleSelected = value;
    notifyListeners();
  }

  set isFemaleSelected(bool value) {
    _isFemaleSelected = value;
    notifyListeners();
  }

  set isOtherSelected(bool value) {
    _isOtherSelected = value;
    notifyListeners();
  }

  set isGenderAllSelected(bool value) {
    _isGenderAllSelected = value;
    notifyListeners();
  }

  set isAge13To17Selected(bool value) {
    _isAge13To17Selected = value;
    notifyListeners();
  }

  set isAge18To25Selected(bool value) {
    _isAge18To25Selected = value;
    notifyListeners();
  }

  set isAge26To35Selected(bool value) {
    _isAge26To35Selected = value;
    notifyListeners();
  }

  set isAge36To50Selected(bool value) {
    _isAge36To50Selected = value;
    notifyListeners();
  }

  set isAge50plusSelected(bool value) {
    _isAge50plusSelected = value;
    notifyListeners();
  }

  set isAgeAllSelected(bool value) {
    _isAgeAllSelected = value;
    notifyListeners();
  }

  set skillLevel(int value) {
    _skillLevel = value;
    notifyListeners();
  }

  set isSkillLevelAllSelected(bool value) {
    _isSkillLevelAllSelected = value;
    notifyListeners();
  }

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
    if (_isGenderAllSelected) {
      selectedGenders.add('All');
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
    if (_isAgeAllSelected) {
      selectedAge.add('All');
    }
    return selectedAge;
  }

  List<int> getSelectedSkillLevel() {
    List<int> selectedSkillLevel = [];
    List<int> allSkillLevel = [0, 1, 2, 3, 4, 5];
    if (!_isSkillLevelAllSelected && _skillLevel == 0) {
      return allSkillLevel;
    }
    selectedSkillLevel.add(_skillLevel);

    return selectedSkillLevel;
  }

  void toggleSkillLevelAllSelected(bool value) {
    _isSkillLevelAllSelected = value;
    notifyListeners();
  }

  void toggleFemaleSelected(bool value) {
    _isFemaleSelected = value;
    notifyListeners();
  }

  void toggleOtherSelected(bool value) {
    _isOtherSelected = value;
    notifyListeners();
  }

  void toggleGenderAllSelected(bool value) {
    _isGenderAllSelected = value;
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

  void toggleAgeAllSelected(bool value) {
    _isAgeAllSelected = value;
    notifyListeners();
  }
}
