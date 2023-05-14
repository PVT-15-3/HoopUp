import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/map.dart';

import '../providers/create_event_wizard_provider.dart';

class WizardSecondStep extends StatelessWidget {
  const WizardSecondStep({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateEventWizardProvider wizardProvider =
        Provider.of<CreateEventWizardProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
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
                    fontFamily: 'Open Sans',
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
                      } else {
                        wizardProvider.selectedGender = '';
                        wizardProvider.genderAllSelected = false;
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
                    fontFamily: 'Open Sans',
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
                  'Select age group/s',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
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
                    value: wizardProvider.ageGroupAllSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        wizardProvider.selectedAgeGroup = 'All';
                        wizardProvider.ageGroupAllSelected = true;
                      } else {
                        wizardProvider.selectedAgeGroup = '';
                        wizardProvider.ageGroupAllSelected = false;
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
                    fontFamily: 'Open Sans',
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
                    wizardProvider.selectedAgeGroup = '13-17';
                    wizardProvider.ageGroupAllSelected = false;
                  },
                  child: Container(
                    width: 39.3,
                    height: 39.3,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedAgeGroup == '13-17'
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
                    child: const Center(
                      child: Text(
                        '13-17',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF454545),
                        ),
                      ),
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
                    wizardProvider.selectedAgeGroup = '18-25';
                    wizardProvider.ageGroupAllSelected = false;
                  },
                  child: Container(
                    width: 39.3,
                    height: 39.3,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedAgeGroup == '18-25'
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
                    child: const Center(
                      child: Text(
                        '18-25',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF454545),
                        ),
                      ),
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
                    wizardProvider.selectedAgeGroup = '26-35';
                    wizardProvider.ageGroupAllSelected = false;
                  },
                  child: Container(
                    width: 39.3,
                    height: 39.3,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedAgeGroup == '26-35'
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
                    child: const Center(
                      child: Text(
                        '26-35',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF454545),
                        ),
                      ),
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
                    wizardProvider.selectedAgeGroup = '36-50';
                    wizardProvider.ageGroupAllSelected = false;
                  },
                  child: Container(
                    width: 39.3,
                    height: 39.3,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedAgeGroup == '36-50'
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
                    child: const Center(
                      child: Text(
                        '36-50',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF454545),
                        ),
                      ),
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
                    wizardProvider.selectedAgeGroup = '50+';
                    wizardProvider.ageGroupAllSelected = false;
                  },
                  child: Container(
                    width: 39.3,
                    height: 39.3,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: wizardProvider.selectedAgeGroup == '50+'
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
                    child: const Center(
                      child: Text(
                        '50+',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF454545),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // TODO: Skill level för event behöver återimplementeras som en Sträng ifall man ska kunna välja "all". För tillfället så är koden för den här knappen samma som för age group.
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
                    fontFamily: 'Open Sans',
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
                    value: wizardProvider.ageGroupAllSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        wizardProvider.selectedAgeGroup = 'All';
                        wizardProvider.ageGroupAllSelected = true;
                      } else {
                        wizardProvider.selectedAgeGroup = '';
                        wizardProvider.ageGroupAllSelected = false;
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
                    fontFamily: 'Open Sans',
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
            selector: (_, myProvider) => myProvider.skillLevel,
            builder: (_, skillLevel, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      wizardProvider.skillLevel = index + 1;
                    },
                    child: Container(
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
