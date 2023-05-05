import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/handlers/event_handler.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../providers/create_event_wizard_provider.dart';

class CreateEventWizard extends StatelessWidget {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController playerAmountController =
      TextEditingController(text: '2');

  CreateEventWizard({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);
    final firebaseProvider = context.read<FirebaseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wizard'),
      ),
      body: CoolStepper(
        showErrorSnackbar: true,
        onCompleted: () {
          // do something when the wizard is completed
          wizardProvider.userId = hoopUpUserProvider.user?.id;
          print('${wizardProvider.userId}\n'
              '${wizardProvider.eventName}\n'
              '${wizardProvider.eventDate}\n'
              '${wizardProvider.eventStartTime}\n'
              '${wizardProvider.eventEndTime}\n'
              '${wizardProvider.numberOfParticipants}\n'
              '${wizardProvider.selectedGender}\n'
              '${wizardProvider.selectedAgeGroup}\n'
              '${wizardProvider.skillLevel}\n'
              '${wizardProvider.courtId}\n'
              '${wizardProvider.eventName}\n'
              '${wizardProvider.eventDescription}\n'
              'Steps completed!');

          try {
            EventHandler().createEvent(
                eventDate: wizardProvider.eventDate,
                eventStartTime: wizardProvider.eventStartTime,
                eventEndTime: wizardProvider.eventEndTime,
                numberOfParticipants: wizardProvider.numberOfParticipants,
                selectedGender: wizardProvider.selectedGender,
                selectedAgeGroup: wizardProvider.selectedAgeGroup,
                skillLevel: wizardProvider.skillLevel,
                eventName: wizardProvider.eventName,
                eventDescription: wizardProvider.eventDescription,
                courtId: wizardProvider.courtId,
                userId: wizardProvider.userId,
                hoopUpUser: hoopUpUserProvider.user,
                firebaseProvider: firebaseProvider);
            showCustomToast('Your event is created', Icons.approval, context);
          } on Exception catch (e) {
            showCustomToast("ERROR: $e", Icons.error, context);
            print("error when creating event: $e");
          }
          Navigator.pop(context);
          wizardProvider.reset();
        },
        steps: [
          CoolStep(
            title: 'Step 1',
            subtitle: 'Please select date, time-span, and player amount',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2099, 12, 31),
                      onChanged: (date) {
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(date);
                        wizardProvider.eventDate = date;
                      },
                      onConfirm: (date) {
                        dateController.text = date.toString();
                        wizardProvider.eventDate = date;
                      },
                      currentTime: DateTime.now(),
                    );
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<CreateEventWizardProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: provider.eventStartTime,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? Container(),
                              );
                            },
                          );
                          if (selectedTime != null) {
                            provider.eventStartTime = selectedTime;
                          }
                        },
                        child: Text(
                          DateFormat.Hm().format(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            provider.eventStartTime.hour,
                            provider.eventStartTime.minute,
                          )),
                        ),
                      ),
                    ),
                    Consumer<CreateEventWizardProvider>(
                      builder: (context, provider, _) => ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: provider.eventEndTime,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child ?? Container(),
                              );
                            },
                          );
                          if (selectedTime != null) {
                            provider.eventEndTime = selectedTime;
                          }
                        },
                        child: Text(
                          DateFormat.Hm().format(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            provider.eventEndTime.hour,
                            provider.eventEndTime.minute,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Player Amount:'),
                    SizedBox(
                      width: 120,
                      child: Consumer<CreateEventWizardProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                int amount = provider.numberOfParticipants;
                                amount--;
                                if (amount < 2) amount = 2;
                                provider.numberOfParticipants = amount;
                                playerAmountController.text = amount.toString();
                              },
                            ),
                            Text(provider.numberOfParticipants.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                int amount = provider.numberOfParticipants;
                                amount++;
                                if (amount > 20) amount = 20;
                                provider.numberOfParticipants = amount;
                                playerAmountController.text = amount.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            validation: () {
              if (dateController.text.isEmpty) {
                return 'Please enter a date';
              }
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
              return null;
            },
          ),
          CoolStep(
            title: "Step 2",
            subtitle: "Customize your game",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select gender or all"),
                Selector<CreateEventWizardProvider, String>(
                  selector: (_, myProvider) => myProvider.selectedGender, // TODO: myProvider is not a good name...
                  builder: (_, selectedGender, __) {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedGender = "Female";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Female" ? Colors.blue : null,
                          ),
                          child: const Text("Female"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedGender = "Male";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Male" ? Colors.blue : null,
                          ),
                          child: const Text("Male"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedGender = "Other";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Other" ? Colors.blue : null,
                          ),
                          child: const Text("Other"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedGender = "All";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "All" ? Colors.blue : null,
                          ),
                          child: const Text("All"),
                        ),
                      ],
                    );
                  },
                ),
                const Text("Select age group"),
                Selector<CreateEventWizardProvider, String>(
                  selector: (_, myProvider) => myProvider.selectedAgeGroup,
                  builder: (_, selectedAgeGroup, __) {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedAgeGroup = "13-17";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAgeGroup == "13-17"
                                ? Colors.blue
                                : null,
                          ),
                          child: const Text("13-17"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedAgeGroup = "18+";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAgeGroup == "18+" ? Colors.blue : null,
                          ),
                          child: const Text("18+"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedAgeGroup = "55+";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAgeGroup == "55+" ? Colors.blue : null,
                          ),
                          child: const Text("55+"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            wizardProvider.selectedAgeGroup = "All";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAgeGroup == "All" ? Colors.blue : null,
                          ),
                          child: const Text("All"),
                        ),
                      ],
                    );
                  },
                ),
                const Text("Select skill level"),
                Selector<CreateEventWizardProvider, int>(
                  selector: (_, myProvider) => myProvider.skillLevel,
                  builder: (_, skillLevel, __) {
                    return Row(
                      children: List.generate(
                        5,
                        (index) => InkWell(
                          onTap: () {
                            wizardProvider.skillLevel = index + 1;
                          },
                          child: Icon(
                            index < skillLevel ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Text("Choose a location"),
                Selector<CreateEventWizardProvider, String>(
                  selector: (_, myProvider) => myProvider.courtId,
                  builder: (_, selectedLocationId, __) {
                    return DropdownButton<String>(
                      value: selectedLocationId,
                      onChanged: (value) {
                        wizardProvider.courtId = value!;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "LocationId1",
                          child: Text("LocationId1"),
                        ),
                        DropdownMenuItem(
                          value: "LocationId2",
                          child: Text("LocationId2"),
                        ),
                        DropdownMenuItem(
                          value: "LocationId3",
                          child: Text("LocationId3"),
                        ),
                        DropdownMenuItem(
                          value: "LocationId4",
                          child: Text("LocationId4"),
                        ),
                        DropdownMenuItem(
                          value: "LocationId5",
                          child: Text("LocationId5"),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            validation: () {
              return null;
            },
          ),
          CoolStep(
            title: "Step 3",
            subtitle: "Please name and describe your event",
            content: Column(
              children: [
                const Text("Event name"),
                TextField(
                  controller: eventNameController,
                  onChanged: (value) {
                    wizardProvider.eventName = value;
                  },
                ),
                const Text("Event description"),
                TextField(
                  controller: eventDescriptionController,
                  onChanged: (value) {
                    wizardProvider.eventDescription = value;
                  },
                ),
              ],
            ),
            validation: () {
              if (eventNameController.text.isEmpty) {
                return 'Please enter a name';
              }
              if (eventDescriptionController.text.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          CoolStep(
            title: "Step 4",
            subtitle: "Confirm your event",
            content: Builder(builder: (context) {
              return Consumer<CreateEventWizardProvider>(
                builder: (context, myProvider, _) {
                  return Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Event Information',
                        ),
                        maxLines: 5,
                        initialValue:
                            'Event info: ${myProvider.eventDescription}\n'
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
            }),
            validation: () {}, // TODO: WHAT TO DO HERE? SHOULD I REMOVE? (VIKTOR)
          )
        ],
        config: const CoolStepperConfig(
          backText: 'PREVIOUS',
          nextText: 'NEXT',
          stepText: 'STEP',
          ofText: 'OF',
        ),
      ),
    );
  }
}
