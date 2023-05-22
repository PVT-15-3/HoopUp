import 'package:flutter/material.dart';
import 'package:my_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';

class FilterHandler {
  // Filtreringslogik baserat på valda alternativ
  static bool filterEvent(Event event, BuildContext context) {
    final filterProvider = context.read<FilterProvider>();
    final List<String> selectedGenderGroups =
        filterProvider.getSelectedGenders();
    final int selectedMinAge = filterProvider.minimumAge;
    final int selectedMaxAge = filterProvider.maximumAge;
    final List<int> selectedSkillLevel = filterProvider.getSelectedSkillLevel();

    bool isWithinAgeRange() {
      return event.minimumAge >= selectedMinAge &&
          event.maximumAge <= selectedMaxAge;
    }

    return (selectedGenderGroups.isEmpty ||
            selectedGenderGroups.contains(event.genderGroup)) &&
        (isWithinAgeRange()) &&
        (selectedSkillLevel.isEmpty ||
            selectedSkillLevel.contains(event.skillLevel));
  }
}
