import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  bool _isOtherSelected = false;
  bool _isGenderAllSelected = false;

  bool _isPVCSelected = false;
  bool _isAsphaltSelected = false;
  bool _isRubberSelected = false;

  int _skillLevel = 0;
  bool _isSkillLevelAllSelected = false;

  int _minimumAge = 13;
  int _maximumAge = 100;

  bool get isMaleSelected => _isMaleSelected;
  bool get isFemaleSelected => _isFemaleSelected;
  bool get isOtherSelected => _isOtherSelected;
  bool get isGenderAllSelected => _isGenderAllSelected;
  int get skillLevel => _skillLevel;
  bool get isSkillLevelAllSelected => _isSkillLevelAllSelected;

  void clearFilters() {
    _isMaleSelected = false;
    _isFemaleSelected = false;
    _isOtherSelected = false;
    _isGenderAllSelected = false;
    _skillLevel = 0;
    _isSkillLevelAllSelected = false;
    _minimumAge = 13;
    _maximumAge = 100;
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

  List<int> getSelectedSkillLevel() {
    List<int> selectedSkillLevel = [];
    List<int> allSkillLevel = [0, 1, 2, 3, 4, 5];
    if (!_isSkillLevelAllSelected && _skillLevel == 0) {
      return allSkillLevel;
    }
    selectedSkillLevel.add(_skillLevel);

    return selectedSkillLevel;
  }

  List<String> getSelectedCourtTypes() {
    List<String> selectedCourtTypes = [];
    if (_isPVCSelected) {
      selectedCourtTypes.add('PVC tiles');
    }
    if (_isAsphaltSelected) {
      selectedCourtTypes.add('Asphalt');
    }
    if (_isRubberSelected) {
      selectedCourtTypes.add('Synthetic rubber');
    }
    return selectedCourtTypes;
  }

  bool get isPVCSelected => _isPVCSelected;
  bool get isAsphaltSelected => _isAsphaltSelected;
  bool get isRubberSelected => _isRubberSelected;

  void togglePVCSelected(bool value) {
    _isPVCSelected = value;
    notifyListeners();
  }

  void toggleAsphaltSelected(bool value) {
    _isAsphaltSelected = value;
    notifyListeners();
  }

  void toggleRubberSelected(bool value) {
    _isRubberSelected = value;
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
}
