import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_styles.dart';
import '../providers/create_event_wizard_provider.dart';

class WizardSecondStep extends StatelessWidget {
  const WizardSecondStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isGenderSelected = wizardProvider.wizardSecondStepGenderSelected;
      wizardProvider.updateColorSecondStep(isGenderSelected);
    });
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
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Customize your game',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  'Select gender/s',
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
              Consumer<CreateEventWizardProvider>(
                builder: (context, wizardProvider, _) {
                  return Checkbox(
                    value: wizardProvider.genderAllSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        wizardProvider.selectedGender = 'All';
                        wizardProvider.genderAllSelected = true;
                        wizardProvider.onGenderSelectedChanged(true);
                      } else {
                        wizardProvider.selectedGender = '';
                        wizardProvider.genderAllSelected = false;
                        wizardProvider.onGenderSelectedChanged(false);
                      }
                    },
                  );
                },
              ),
              Container(
                width: 15,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  'All',
                  style: TextStyle(
                    fontFamily: Styles.mainFont,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 2.67,
                    letterSpacing: 0.1,
                    color: Color(0xFFA9A9A9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<CreateEventWizardProvider>(
                builder: (context, wizardProvider, _) => GestureDetector(
                  onTap: () {
                    wizardProvider.selectedGender = 'Male';
                    wizardProvider.genderAllSelected = false;
                    wizardProvider.onGenderSelectedChanged(true);
                  },
                  child: Container(
                    width: 69,
                    height: 52,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedGender == 'Male'
                            ? const Color(0xFFFFA500)
                            : const Color(0xFFDBDBDB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.male,
                          size: 24,
                          color: Color(0xFFFC8027),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Consumer<CreateEventWizardProvider>(
                builder: (context, wizardProvider, _) => GestureDetector(
                  onTap: () {
                    wizardProvider.selectedGender = 'Female';
                    wizardProvider.genderAllSelected = false;
                    wizardProvider.onGenderSelectedChanged(true);
                  },
                  child: Container(
                    width: 69,
                    height: 52,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedGender == 'Female'
                            ? const Color(0xFFFFA500)
                            : const Color(0xFFDBDBDB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.female,
                          size: 24,
                          color: Color(0xFFFC8027),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Consumer<CreateEventWizardProvider>(
                builder: (context, wizardProvider, _) => GestureDetector(
                  onTap: () {
                    wizardProvider.selectedGender = 'Other';
                    wizardProvider.genderAllSelected = false;
                    wizardProvider.onGenderSelectedChanged(true);
                  },
                  child: Container(
                    width: 69,
                    height: 52,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedGender == 'Other'
                            ? const Color(0xFFFFA500)
                            : const Color(0xFFDBDBDB),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.transgender_sharp,
                          size: 24,
                          color: Color(0xFFFC8027),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Other',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 179,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  'Select age range',
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
            ],
          ),
        ),
        Consumer<CreateEventWizardProvider>(
          builder: (context, wizardProvider, _) {
            RangeValues ageRange = RangeValues(
              wizardProvider.minimumAge.toDouble(),
              wizardProvider.maximumAge.toDouble(),
            );
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: RangeSlider(
                    min: 13,
                    max: 100,
                    values: ageRange,
                    onChanged: (RangeValues values) {
                      if (values.end - values.start >= 1) {
                        wizardProvider.minimumAge = values.start.toInt();
                        wizardProvider.maximumAge = values.end.toInt();
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Age Range: ${ageRange.start.toInt()} - ${ageRange.end.toInt()}',
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.6,
                        letterSpacing: 0.1,
                        color: Color(0xFF454545),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 179,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  'Select skill level/s',
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
              Consumer<CreateEventWizardProvider>(
                builder: (context, wizardProvider, _) {
                  return Checkbox(
                    value: wizardProvider.skillLevelAllSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        wizardProvider.skillLevel = 0;
                        wizardProvider.skillLevelAllSelected = true;
                      } else {
                        wizardProvider.skillLevel = 1;
                        wizardProvider.skillLevelAllSelected = false;
                      }
                    },
                  );
                },
              ),
              Container(
                width: 15,
                height: 32,
                alignment: Alignment.center,
                child: const Text(
                  'All',
                  style: TextStyle(
                    fontFamily: Styles.mainFont,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 2.67,
                    letterSpacing: 0.1,
                    color: Color(0xFFA9A9A9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Center(
          child: Selector<CreateEventWizardProvider, int>(
            selector: (_, wizardProvider) => wizardProvider.skillLevel,
            builder: (_, skillLevel, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      wizardProvider.skillLevel = index + 1;
                      wizardProvider.skillLevelAllSelected = false;
                    },
                    child: SizedBox(
                      width: 45,
                      height: 49,
                      child: Icon(
                        index < skillLevel ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFC8027),
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
