import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../providers/create_event_wizard_provider.dart';
import 'basketball_slider.dart';

class WizardThirdStep extends StatelessWidget {
  WizardThirdStep({super.key, required this.eventDescriptionController});

  TextEditingController eventDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);

    return Column(
      children: [
        const SizedBox(height: 25),
        const Center(
          child: Text(
            'CREATE GAME',
            style: TextStyle(
              fontFamily: Styles.mainFont,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w800,
              fontSize: 30,
              height: 1.07,
              letterSpacing: 0.1,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Select number of players',
            style: TextStyle(
              fontFamily: Styles.mainFont,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.6,
              letterSpacing: 0.1,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: BasketballSlider(
            min: 2,
            max: 20,
            value: wizardProvider.numberOfParticipants.toDouble(),
            onChanged: (double value) {
              wizardProvider.numberOfParticipants = value.toInt();
            },
          ),
        ),
        const SizedBox(height: 20),
        Consumer<CreateEventWizardProvider>(
          builder: (context, wizardProvider, _) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                width: 46, // Increased width to accommodate two digits
                height: 64,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wizardProvider.numberOfParticipants < 10
                          ? ' '
                          : (wizardProvider.numberOfParticipants ~/ 10)
                              .toString(),
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                        height: 0.8,
                        letterSpacing: 0.1,
                        color: Color(0xFF454545),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      (wizardProvider.numberOfParticipants % 10).toString(),
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                        height: 0.8,
                        letterSpacing: 0.1,
                        color: Color(0xFF454545),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 379,
            height: 0.5,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFA4A4A4), width: 0.5),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          width: 179,
          height: 32,
          child: Text(
            'Other information',
            style: TextStyle(
              fontFamily: Styles.mainFont,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.6,
              letterSpacing: 0.1,
              color: Color(0xFF454545),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            controller: eventDescriptionController,
            decoration: const InputDecoration(
              hintText: 'Write something here...',
              filled: true,
              fillColor: Color(0xFFEFEFEF),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontFamily: Styles.mainFont,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.13,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.left,
            maxLines: 8,
            onChanged: (text) {
              wizardProvider.eventDescription = text;
            },
          ),
        ),
      ],
    );
  }
}
