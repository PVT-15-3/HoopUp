import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_event_wizard_provider.dart';

class WizardFourthStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Consumer<CreateEventWizardProvider>(
          builder: (context, myProvider, _) {
            return Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Information',
                  ),
                  maxLines: 5,
                  initialValue: 'Event info: ${myProvider.eventDescription}\n'
                      'Date and time: ${myProvider.eventDate.year}/${myProvider.eventDate.month}/${myProvider.eventDate.day} '
                      '${myProvider.eventStartTime.hour.toString().padLeft(2, '0')}:${myProvider.eventStartTime.minute.toString().padLeft(2, '0')} - '
                      '${myProvider.eventEndTime.hour.toString().padLeft(2, '0')}:${myProvider.eventEndTime.minute.toString().padLeft(2, '0')}'
                      '\nThe event is for: ${myProvider.selectedGender}\n'
                      'Participants: ${myProvider.numberOfParticipants}\n'
                      'Skill level: ${myProvider.skillLevel}',
                  readOnly: true,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
