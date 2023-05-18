import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_event_wizard_provider.dart';

class WizardFourthStep extends StatelessWidget {
  TextEditingController eventInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context);

    eventInfoController.text = 'You will now create a game at\n'
        '${wizardProvider.court?.name}\n'
        '${wizardProvider.eventDate.year}-${wizardProvider.eventDate.month}-${wizardProvider.eventDate.day}\n'
        'Start time: ${wizardProvider.eventStartTime.hour.toString()}:${wizardProvider.eventStartTime.minute.toString()}\n'
        'End Time: ${wizardProvider.eventEndTime.hour.toString()}:${wizardProvider.eventEndTime.minute.toString()}\n'
        '\nFor ${wizardProvider.numberOfParticipants} players\n'
        '${wizardProvider.selectedGender} between ${wizardProvider.selectedAgeGroup}\n'
        'with skill level\n'
        '${String.fromCharCode(0x2605) * wizardProvider.skillLevel}${String.fromCharCode(0x2606) * (5 - wizardProvider.skillLevel)}';

    return Builder(
      builder: (context) {
        return Consumer<CreateEventWizardProvider>(
          builder: (context, wizardProvider, _) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'CONFIRM GAME',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      height: 1.07,
                      letterSpacing: 0.1,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'Go through the content of your game',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 1.6,
                      letterSpacing: 0.1,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Game will be created at\n'
                              '${wizardProvider.court?.name}\n'
                              '${wizardProvider.eventDate.year}-${wizardProvider.eventDate.month}-${wizardProvider.eventDate.day}\n'
                              'Start time: ${wizardProvider.eventStartTime.hour.toString()}:${wizardProvider.eventStartTime.minute.toString()}\n'
                              'End Time: ${wizardProvider.eventEndTime.hour.toString()}:${wizardProvider.eventEndTime.minute.toString()}\n'
                              '\nFor ${wizardProvider.numberOfParticipants} players\n'
                              '${wizardProvider.selectedGender} between ${wizardProvider.selectedAgeGroup}\n'
                              'with skill level\n',
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.13,
                            letterSpacing: 0.1,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              String.fromCharCode(0x2605) * wizardProvider.skillLevel,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text:
                              String.fromCharCode(0x2606) * (5 - wizardProvider.skillLevel),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
