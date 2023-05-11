import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/map_page.dart';

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
        const Text("Select gender or all"),
        Selector<CreateEventWizardProvider, String>(
          selector: (_, myProvider) => myProvider
              .selectedGender, // TODO: myProvider is not a good name...
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
                    backgroundColor:
                        selectedAgeGroup == "13-17" ? Colors.blue : null,
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
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapPage(showSelectOption: true)));
          },
          child: const Text('Choose location'),
        )
      ],
    );
  }
}
