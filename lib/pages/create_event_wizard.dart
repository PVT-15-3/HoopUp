import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/handlers/event_handler.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
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
    final CreateEventWizardProvider myProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wizard'),
      ),
      body: CoolStepper(
        onCompleted: () {
          // do something when the wizard is completed
          myProvider.userId = hoopUpUserProvider.user?.id;
          print(myProvider.userId);
          print(myProvider.eventName);
          print(myProvider.eventDate.toString());
          print(myProvider.eventStartTime.toString());
          print(myProvider.eventEndTime.toString());
          print(myProvider.numberOfParticipants.toString());
          print(myProvider.selectedGender.toString());
          print(myProvider.selectedAgeGroup.toString());
          print(myProvider.skillLevel.toString());
          print(myProvider.courtId.toString());
          print(myProvider.eventName.toString());
          print(myProvider.eventDescription.toString());
          print('Steps completed!');
          EventHandler().createEvent(
              eventDate: myProvider.eventDate,
              eventStartTime: myProvider.eventStartTime,
              eventEndTime: myProvider.eventEndTime,
              numberOfParticipants: myProvider.numberOfParticipants,
              selectedGender: myProvider.selectedGender,
              selectedAgeGroup: myProvider.selectedAgeGroup,
              skillLevel: myProvider.skillLevel,
              eventName: myProvider.eventName,
              eventDescription: myProvider.eventDescription,
              courtId: myProvider.courtId,
              userId: myProvider.userId,
              hoopUpUser: hoopUpUserProvider.user);
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
                        dateController.text = date.toString();
                        myProvider.eventDate = date;
                      },
                      onConfirm: (date) {
                        dateController.text = date.toString();
                        myProvider.eventDate = date;
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
              if (myProvider.numberOfParticipants < 2 ||
                  myProvider.numberOfParticipants > 20) {
                return 'Please select a number of players between 2 and 20';
              }
              DateTime now = DateTime.now();
              DateTime startTime = DateTime(
                myProvider.eventDate.year,
                myProvider.eventDate.month,
                myProvider.eventDate.day,
                myProvider.eventStartTime.hour,
                myProvider.eventStartTime.minute,
              );
              DateTime thirtyMinutesFromNow = now.add(Duration(minutes: 30));
              if (startTime.isBefore(thirtyMinutesFromNow)) {
                return 'Start time must be at least 30 minutes from now.';
              }
              if (startTime.isBefore(now)) {
                return 'Start time cannot be before current time.';
              }
              DateTime endTime = DateTime(
                myProvider.eventDate.year,
                myProvider.eventDate.month,
                myProvider.eventDate.day,
                myProvider.eventEndTime.hour,
                myProvider.eventEndTime.minute,
              );
              if (endTime.isBefore(startTime.add(Duration(hours: 1)))) {
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
                  selector: (_, myProvider) => myProvider.selectedGender,
                  builder: (_, selectedGender, __) {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedGender = "Female";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Female" ? Colors.blue : null,
                          ),
                          child: const Text("Female"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedGender = "Male";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Male" ? Colors.blue : null,
                          ),
                          child: const Text("Male"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedGender = "Other";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedGender == "Other" ? Colors.blue : null,
                          ),
                          child: const Text("Other"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedGender = "All";
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
                            myProvider.selectedAgeGroup = "13-17";
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
                            myProvider.selectedAgeGroup = "18+";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAgeGroup == "18+" ? Colors.blue : null,
                          ),
                          child: const Text("18+"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedAgeGroup = "55+";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAgeGroup == "55+" ? Colors.blue : null,
                          ),
                          child: const Text("55+"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myProvider.selectedAgeGroup = "All";
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
                            myProvider.skillLevel = index + 1;
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
                        myProvider.courtId = value!;
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
            validation: () {},
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
                    myProvider.eventName = value;
                  },
                ),
                const Text("Event description"),
                TextField(
                  controller: eventDescriptionController,
                  onChanged: (value) {
                    myProvider.eventDescription = value;
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
