import 'package:flutter/material.dart';
import 'package:my_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';

import '../classes/event.dart';

class FilterHandler {
  static bool filterEvent(Event event, BuildContext context) {
    FilterProvider filterProvider = context.read<FilterProvider>();
    // Filtreringslogik baserat på valda alternativ
    bool isGenderFilter = true;
    bool isAgeFilter = true;
    bool isSkillLevelFilter = true;
    List<String> selectedGenders = filterProvider.getSelectedGenders();
    List<String> selectedAges = filterProvider.getSelectedAge();
    List<int> selectedSkillLevel = filterProvider.getSelectedSKillLevel();

    // Filtrera baserat på kön
    if (selectedGenders.isNotEmpty) {
      isGenderFilter = selectedGenders.contains(event.genderGroup);
    }

    // Filtrera baserat på ålder
    if (selectedAges.isNotEmpty) {
      isAgeFilter = selectedAges.contains(event.ageGroup);
    }

    if(selectedSkillLevel.isNotEmpty){
      isSkillLevelFilter = selectedSkillLevel.contains(event.skillLevel);
    }
    return isGenderFilter && isAgeFilter && isSkillLevelFilter;
  }
}
