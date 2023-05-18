import 'package:flutter/material.dart';
import 'package:cool_stepper_reloaded/cool_stepper_reloaded.dart';
import 'package:my_app/handlers/event_handler.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
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
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);

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
      body: Consumer<CreateEventWizardProvider>(
        builder: (context, wizardProvider, _) {
          Color nextButtonColor = wizardProvider.color ?? Colors.black;
          return CoolStepper(
            isHeaderEnabled: false,
            showErrorSnackbar: true,
            onCompleted: () {
              wizardProvider.userId = hoopUpUserProvider.user!.id;
              EventHandler()
                  .createEvent(
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
                      firebaseProvider: firebaseProvider)
                  .then((_) {
               Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar(currentIndex: 2,)),
                          );
                showCustomToast(
                    'Your event is created', Icons.approval, context);
                wizardProvider.reset();
              }).catchError((e) {
                showCustomToast(e.toString(), Icons.error, context);
                print("error when creating event: $e");
              });
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
                  if (endTime
                      .isBefore(startTime.add(const Duration(hours: 1)))) {
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
              ),
            ],
            config: CoolStepperConfig(
              nextTextStyle: nextButtonColor != null
                  ? TextStyle(color: nextButtonColor, fontSize: 40)
                  : const TextStyle(color: Color(0xFF959595), fontSize: 40),
              backTextStyle:
                  const TextStyle(color: Color(0xFFFC8027), fontSize: 40),
              stepOfTextStyle:
                  const TextStyle(color: Color(0xFFFC8027), fontSize: 20),
              backText: String.fromCharCode(0x25C0),
              nextText: String.fromCharCode(0x25B6),
              stepText: 'STEP',
              ofText: 'OF',
              finalText: String.fromCharCode(0x25B6),
              headerColor: Colors.white,
              icon: const Icon(null),
            ),
          );
        },
      ),
    );
  }
}
