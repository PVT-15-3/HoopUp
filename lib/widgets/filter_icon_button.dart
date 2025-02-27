import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';

import '../app_styles.dart';
import '../providers/filter_provider.dart';

class FilterIconButton extends StatelessWidget {
  const FilterIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text(
        '',
      ),
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.tune,
            color: Styles.primaryColor,
          ),
          Text(
            'Filter',
            style: TextStyle(
              color: Styles.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: () {
        Toaster.clearToast();
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(
                    context); // Stänger dialogrutan när man klickar utanför
              },
              child: Consumer<FilterProvider>(
                builder: (context, filterProvider, _) {
                  RangeValues ageRange = RangeValues(
                    filterProvider.minimumAge.toDouble(),
                    filterProvider.maximumAge.toDouble(),
                  );
                  return SingleChildScrollView(
                    child: AlertDialog(
                      title: const Center(
                        child: Text(
                          'FILTER EVENTS',
                          style: TextStyle(
                            fontFamily: Styles.headerFont,
                            fontSize: Styles.fontSizeMedium,
                          ),
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('GENDER',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Styles.primaryColor)),
                          CheckboxListTile(
                            title: const Text('Male'),
                            value: filterProvider.isMaleSelected,
                            onChanged: (value) {
                              filterProvider.toggleMaleSelected(value!);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Female'),
                            value: filterProvider.isFemaleSelected,
                            onChanged: (value) {
                              filterProvider.toggleFemaleSelected(value!);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Other'),
                            value: filterProvider.isOtherSelected,
                            onChanged: (value) {
                              filterProvider.toggleOtherSelected(value!);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Gender category "All"'),
                            value: filterProvider.isGenderAllSelected,
                            onChanged: (value) {
                              filterProvider.toggleGenderAllSelected(value!);
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Floor type',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Styles.primaryColor)),
                          CheckboxListTile(
                            title: const Text('PVC tiles (Plastic)'),
                            value: filterProvider.isPVCSelected,
                            onChanged: (value) {
                              filterProvider.togglePVCSelected(value!);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Asphalt'),
                            value: filterProvider.isAsphaltSelected,
                            onChanged: (value) {
                              filterProvider.toggleAsphaltSelected(value!);
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Synthetic rubber'),
                            value: filterProvider.isRubberSelected,
                            onChanged: (value) {
                              filterProvider.toggleRubberSelected(value!);
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('AGE',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Styles.primaryColor)),
                          Consumer<FilterProvider>(
                            builder: (context, filterProvider, _) {
                              return Column(
                                children: [
                                  RangeSlider(
                                    min: 13,
                                    max: 100,
                                    values: ageRange,
                                    onChanged: (RangeValues values) {
                                      if (values.end - values.start >= 1) {
                                        filterProvider.minimumAge =
                                            values.start.toInt();
                                        filterProvider.maximumAge =
                                            values.end.toInt();
                                      }
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Age Range: ${ageRange.start.toInt()} - ${ageRange.end.toInt()}',
                                        style: const TextStyle(
                                          fontFamily: 'Open Sans',
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'Skill level',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Styles.primaryColor),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: const Text('Skill Level category "All"'),
                            value: filterProvider.isSkillLevelAllSelected,
                            onChanged: (bool? value) {
                              if (value == true) {
                                filterProvider.skillLevel = 0;
                                filterProvider.isSkillLevelAllSelected = true;
                              } else {
                                filterProvider.skillLevel = 0;
                                filterProvider.isSkillLevelAllSelected = false;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'Or chose a specific skill level below:',
                                style: TextStyle(
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Styles.fontSizeSmallest,
                                  height: 1.6,
                                  letterSpacing: 0.1,
                                  color: Color(0xFFA9A9A9),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Selector<FilterProvider, int>(
                              selector: (_, FilterProvider) =>
                                  FilterProvider.skillLevel,
                              builder: (_, skillLevel, __) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                    5,
                                    (index) => InkWell(
                                      onTap: () {
                                        Provider.of<FilterProvider>(context,
                                                listen: false)
                                            .skillLevel = index + 1;
                                        Provider.of<FilterProvider>(context,
                                                listen: false)
                                            .isSkillLevelAllSelected = false;
                                      },
                                      child: SizedBox(
                                        width: 30,
                                        height: 49,
                                        child: Icon(
                                          index < skillLevel
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: const Color(0xFFFC8027),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Styles.primaryColor,
                                  minimumSize: const Size(70, 35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {
                                  // Apply clear filter logic here
                                  filterProvider.clearFilters();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavBar(
                                                currentIndex: 0,
                                              )),
                                      (route) => false);
                                },
                                child: const Text(
                                  'CLEAR FILTERS',
                                  style: TextStyle(
                                    fontFamily: Styles.buttonFont,
                                    fontSize: Styles.fontSizeSmall,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Styles.primaryColor,
                                  minimumSize: const Size(70, 35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () {
                                  // Apply filter logic here
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavBar(
                                                currentIndex: 0,
                                              )),
                                      (route) => false);
                                },
                                child: const Text(
                                  'APPLY',
                                  style: TextStyle(
                                    fontFamily: Styles.buttonFont,
                                    fontSize: Styles.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
