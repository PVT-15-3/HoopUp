import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/widgets/wizard_second_step.dart';
import '../providers/create_event_wizard_provider.dart';

class WizardThirdStep extends StatelessWidget {
  WizardThirdStep({super.key, required this.eventDescriptionController});

  TextEditingController eventDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);

    return Column(
      children: [
        const Text("Event description"),
        TextField(
          controller: eventDescriptionController,
          onChanged: (value) {
            wizardProvider.eventDescription = value;
          },
        ),
      ],
    );
  }
}
