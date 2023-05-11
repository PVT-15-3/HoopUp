import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/map.dart';

import '../providers/create_event_wizard_provider.dart';

class WizardFirstStep extends StatelessWidget {
  WizardFirstStep({super.key, required this.dateController});

  TextEditingController dateController = TextEditingController();
  final TextEditingController playerAmountController =
      TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'CREATE GAME',
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
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Select a court for your game',
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
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2099, 12, 31),
              onChanged: (date) {
                dateController.text = DateFormat('yyyy-MM-dd').format(date);
                wizardProvider.eventDate = date;
              },
              onConfirm: (date) {
                dateController.text = DateFormat('yyyy-MM-dd').format(date);
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
    );
  }
}
