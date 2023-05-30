import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:my_app/pages/map_page.dart';
import 'package:my_app/providers/courts_provider.dart';
import 'package:provider/provider.dart';

import '../app_styles.dart';
import '../classes/court.dart';
import '../providers/create_event_wizard_provider.dart';

class WizardFirstStep extends StatelessWidget {
  WizardFirstStep({super.key, required this.dateController});

  TextEditingController dateController = TextEditingController();
  final TextEditingController playerAmountController =
      TextEditingController(text: '2');

  Widget startTimePicker(Function(TimeOfDay) onTimeChange) {
    return Consumer<CreateEventWizardProvider>(
      builder: (context, wizardProvider, _) {
        DateTime wizardStartTime = DateTime(
          wizardProvider.eventDate.year,
          wizardProvider.eventDate.month,
          wizardProvider.eventDate.day,
          wizardProvider.eventStartTime.hour,
          wizardProvider.eventStartTime.minute,
        );
        return TimePickerSpinner(
          spacing: 10,
          time: wizardStartTime,
          minutesInterval: 5,
          isForce2Digits: true,
          normalTextStyle: const TextStyle(
            fontSize: 30,
            color: Color(0xFF959595),
            fontFamily: Styles.mainFont,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.1,
          ),
          highlightedTextStyle: const TextStyle(
            fontSize: 30,
            color: Color(0xFFFC8027),
            fontFamily: Styles.mainFont,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.1,
          ),
          onTimeChange: (time) {
            final timeOfDay = TimeOfDay.fromDateTime(time);
            onTimeChange(timeOfDay);
          },
        );
      },
    );
  }

  Widget endTimePicker(Function(TimeOfDay) onTimeChange) {
    return Consumer<CreateEventWizardProvider>(
      builder: (context, wizardProvider, _) {
        DateTime wizardStartTime = DateTime(
          wizardProvider.eventDate.year,
          wizardProvider.eventDate.month,
          wizardProvider.eventDate.day,
          wizardProvider.eventEndTime.hour,
          wizardProvider.eventEndTime.minute,
        );
        return TimePickerSpinner(
          spacing: 10,
          time: wizardStartTime,
          minutesInterval: 5,
          isForce2Digits: true,
          normalTextStyle: const TextStyle(
            fontSize: 30,
            color: Color(0xFF959595),
            fontFamily: Styles.mainFont,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.1,
          ),
          highlightedTextStyle: const TextStyle(
            fontSize: 30,
            color: Color(0xFFFC8027),
            fontFamily: Styles.mainFont,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.1,
          ),
          onTimeChange: (time) {
            final timeOfDay = TimeOfDay.fromDateTime(time);
            onTimeChange(timeOfDay);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    final CourtProvider courtProvider =
        Provider.of<CourtProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            'Select a court for your game',
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
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 318,
            height: 32,
            margin: const EdgeInsets.only(
              top: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              border: Border.all(
                color: const Color(0xFFD1D1D1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Consumer2<CreateEventWizardProvider, CourtProvider>(
              builder: (context, wizardProvider, courtProvider, _) {
                return DropdownButton<Court>(
                  isExpanded: true,
                  value: wizardProvider.court,
                  items: [
                    const DropdownMenuItem<Court>(
                      value: null,
                      child: Text('Select court from list'),
                    ),
                    ...courtProvider.courts.map((Court court) {
                      return DropdownMenuItem<Court>(
                        value: court,
                        child: Text(court.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (Court? newCourt) {
                    wizardProvider.court = newCourt;
                    wizardProvider.wizardFirstStepMapSelected = true;
                    wizardProvider.checkEventAvailability();
                  },
                  underline: Container(),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapPage(showSelectOption: true),
              ));
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFC8027),
              textStyle: const TextStyle(
                fontFamily: Styles.mainFont,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.78,
                letterSpacing: 0.1,
                decoration: TextDecoration.underline,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Choose from map'),
                Icon(
                  Icons.place,
                  color: Color(0xFFFC8027),
                ),
              ],
            ),
          ),
        ),
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
        const Center(
          child: Text(
            'Select day and time for your game',
            style: TextStyle(
              fontFamily: Styles.mainFont,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.6,
              letterSpacing: 0.1,
              color: Color(0xFF2D2D2D),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Consumer<CreateEventWizardProvider>(
          builder: (context, wizardProvider, _) {
            final daysInMonth = List<int>.generate(
              DateTime(wizardProvider.selectedYear,
                      wizardProvider.selectedMonth + 1, 0)
                  .day,
              (index) => index + 1,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: wizardProvider.selectedYear,
                  onChanged: (value) {
                    wizardProvider.setSelectedYear(value!);
                    wizardProvider.checkEventAvailability();
                  },
                  items: List.generate(10, (index) => index + 2022)
                      .map((year) => DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 20),
                DropdownButton<int>(
                  value: wizardProvider.selectedMonth,
                  onChanged: (value) {
                    wizardProvider.setSelectedMonth(value!);
                    wizardProvider.checkEventAvailability();
                  },
                  items: List.generate(12, (index) => index + 1)
                      .map((month) => DropdownMenuItem<int>(
                            value: month,
                            child: Text(month.toString()),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 20),
                DropdownButton<int>(
                  value: wizardProvider.selectedDay,
                  onChanged: (value) {
                    wizardProvider.setSelectedDay(value!);
                    wizardProvider.checkEventAvailability();
                  },
                  items: daysInMonth
                      .map((day) => DropdownMenuItem<int>(
                            value: day,
                            child: Text(day.toString()),
                          ))
                      .toList(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    width: 85,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Text(
                      'Start time',
                      style: TextStyle(
                        fontFamily: Styles.mainFont,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.14,
                        letterSpacing: 0.1,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    width: 69,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Text(
                      'End time',
                      style: TextStyle(
                        fontFamily: Styles.mainFont,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.14,
                        letterSpacing: 0.1,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 32,
                margin: const EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Hour',
                    style: TextStyle(
                      fontFamily: Styles.mainFont,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.14,
                      letterSpacing: 0.1,
                      color: Color(0xFF959595),
                    ),
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 32,
                margin: const EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Minutes',
                    style: TextStyle(
                      fontFamily: Styles.mainFont,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.14,
                      letterSpacing: 0.1,
                      color: Color(0xFF959595),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 56,
                height: 32,
                margin: const EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Hour',
                    style: TextStyle(
                      fontFamily: Styles.mainFont,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.14,
                      letterSpacing: 0.1,
                      color: Color(0xFF959595),
                    ),
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 32,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    'Minutes',
                    style: TextStyle(
                      fontFamily: Styles.mainFont,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.14,
                      letterSpacing: 0.1,
                      color: Color(0xFF959595),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              startTimePicker((time) {
                wizardProvider.eventStartTime = time;
                wizardProvider.checkEventAvailability();
              }),
              const SizedBox(width: 70),
              endTimePicker((time) {
                wizardProvider.eventEndTime = time;
                wizardProvider.checkEventAvailability();
              }),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}
