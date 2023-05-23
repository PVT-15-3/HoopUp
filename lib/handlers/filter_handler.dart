import 'package:flutter/material.dart';
import 'package:my_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import '../classes/court.dart';
import '../classes/event.dart';

class FilterHandler {
  // Filtreringslogik baserat på valda alternativ
  static bool filterEvent(Set<Court> courts, Event event, BuildContext context) {
    final filterProvider = context.read<FilterProvider>();
    final List<String> selectedGenderGroups =
        filterProvider.getSelectedGenders();
    final List<String> selectedCourtTypes = filterProvider.getSelectedCourtTypes();
    final int selectedMinAge = filterProvider.minimumAge;
    final int selectedMaxAge = filterProvider.maximumAge;
    final List<int> selectedSkillLevel = filterProvider.getSelectedSkillLevel();

    bool isWithinAgeRange() {
      return event.minimumAge >= selectedMinAge &&
          event.maximumAge <= selectedMaxAge;
    }

    Court getEventCourt() {
      return courts.firstWhere((court) => court.courtId == event.courtId);
    }

    return (selectedGenderGroups.isEmpty ||
            selectedGenderGroups.contains(event.genderGroup)) &&
        (isWithinAgeRange()) &&
        (selectedSkillLevel.isEmpty ||
            selectedSkillLevel.contains(event.skillLevel)) && (selectedCourtTypes.isEmpty || selectedCourtTypes.contains(getEventCourt().courtType));
  }
}
