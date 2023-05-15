import 'package:flutter/material.dart';
import 'package:cool_stepper_reloaded/cool_stepper_reloaded.dart';
import 'package:my_app/handlers/event_handler.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:my_app/widgets/wizard_first_Step.dart';
import 'package:my_app/widgets/wizard_fourth_step.dart';
import 'package:my_app/widgets/wizard_second_step.dart';
import 'package:my_app/widgets/wizard_third_step.dart';
import 'package:provider/provider.dart';
import '../providers/create_event_wizard_provider.dart';

class CreateEventWizard extends StatelessWidget {
  const CreateEventWizard({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);
    final firebaseProvider = context.read<FirebaseProvider>();

    TextEditingController dateController = TextEditingController();
    TextEditingController eventNameController = TextEditingController();
    TextEditingController eventDescriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shadowColor: Colors.white,
      ),
      body: CoolStepper(
        isHeaderEnabled: false,
        showErrorSnackbar: true,
        onCompleted: () {
          // do something when the wizard is completed
          wizardProvider.userId = hoopUpUserProvider.user!.id;
          try {
            EventHandler().createEvent(
                eventDate: wizardProvider.eventDate,
                eventStartTime: wizardProvider.eventStartTime,
                eventEndTime: wizardProvider.eventEndTime,
                numberOfParticipants: wizardProvider.numberOfParticipants,
                selectedGender: wizardProvider.selectedGender,
                selectedAgeGroup: wizardProvider.selectedAgeGroup,
                skillLevel: wizardProvider.skillLevel,
                eventName: wizardProvider.court!.name,
                eventDescription: wizardProvider.eventDescription,
                courtId: wizardProvider.court!.courtId,
                userId: wizardProvider.userId,
                hoopUpUser: hoopUpUserProvider.user,
                firebaseProvider: firebaseProvider);
            showCustomToast('Your event is created', Icons.approval, context);
          } on Exception catch (e) {
            showCustomToast(e.toString(), Icons.error, context);
            print("error when creating event: $e");
          }
          Navigator.pop(context);
          wizardProvider.reset();
        },
        steps: [
          CoolStep(
            title: 'CREATE GAME',
            subtitle: '',
            content: WizardFirstStep(dateController: dateController),
            validation: () {
              if (wizardProvider.numberOfParticipants < 2 ||
                  wizardProvider.numberOfParticipants > 20) {
                return 'Please select a number of players between 2 and 20';
              }
              DateTime now = DateTime.now();
              DateTime startTime = DateTime(
                wizardProvider.eventDate.year,
                wizardProvider.eventDate.month,
                wizardProvider.eventDate.day,
                wizardProvider.eventStartTime.hour,
                wizardProvider.eventStartTime.minute,
              );
              DateTime thirtyMinutesFromNow =
                  now.add(const Duration(minutes: 30));
              if (startTime.isBefore(thirtyMinutesFromNow)) {
                return 'Start time must be at least 30 minutes from now.';
              }
              if (startTime.isBefore(now)) {
                return 'Start time cannot be before current time.';
              }
              DateTime endTime = DateTime(
                wizardProvider.eventDate.year,
                wizardProvider.eventDate.month,
                wizardProvider.eventDate.day,
                wizardProvider.eventEndTime.hour,
                wizardProvider.eventEndTime.minute,
              );
              if (endTime.isBefore(startTime.add(const Duration(hours: 1)))) {
                return 'End time must be at least 1 hour after start time.';
              }
              if (wizardProvider.court == null) {
                return "Please select a court";
              }
              return null;
            },
          ),
          CoolStep(
            title: 'CREATE GAME',
            subtitle: "",
            content: const WizardSecondStep(),
            validation: () {
              if (wizardProvider.selectedGender.isEmpty) {
                return "Please select an option for gender";
              }
              if (wizardProvider.selectedAgeGroup.isEmpty) {
                return "Please select an option for age groups";
              }
              return null;
            },
          ),
          CoolStep(
            title: 'CREATE GAME',
            subtitle: "",
            content: WizardThirdStep(
              eventDescriptionController: eventDescriptionController,
            ),
            validation: () {
              if (eventDescriptionController.text.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          CoolStep(
            title: 'CREATE GAME',
            subtitle: "",
            content: WizardFourthStep(),
            validation: () {
              return null;
            },
          )
        ],
        config: const CoolStepperConfig(
            nextTextStyle: TextStyle(color: Color(0xFFFC8027), fontSize: 20),
            backTextStyle: TextStyle(color: Color(0xFFFC8027), fontSize: 20),
            stepOfTextStyle: TextStyle(color: Color(0xFFFC8027)),
            backText: 'BACK',
            nextText: 'NEXT',
            stepText: 'STEP',
            ofText: 'OF',
            finalText: 'CONFIRM',
            headerColor: Colors.white,
            icon: Icon(null)),
      ),
    );
  }
}
