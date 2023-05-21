import 'package:flutter/material.dart';
import 'package:my_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';

class FilterHandler {
  // Filtreringslogik baserat på valda alternativ
  static bool filterEvent(Event event, BuildContext context) {
    final filterProvider = context.read<FilterProvider>();
    final List<String> selectedGenderGroups = filterProvider.getSelectedGenders();
    final List<String> selectedAges = filterProvider.getSelectedAge();
    final List<int> selectedSkillLevel = filterProvider.getSelectedSkillLevel();

    return (selectedGenderGroups.isEmpty || selectedGenderGroups.contains(event.genderGroup)) &&
           (selectedAges.isEmpty || selectedAges.contains(event.ageGroup)) &&
           (selectedSkillLevel.isEmpty || selectedSkillLevel.contains(event.skillLevel));
  }
}
