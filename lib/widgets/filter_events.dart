import 'package:flutter/material.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../app_styles.dart';
import '../providers/filter_provider.dart';

class FilterIconButton extends StatelessWidget {
  const FilterIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune),
      color: Styles.primaryColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Consumer<FilterProvider>(
              builder: (context, filterProvider, _) {
                return AlertDialog(
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
                      const SizedBox(height: 16),
                      const Text('AGE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Styles.primaryColor)),
                      CheckboxListTile(
                        title: const Text('13-17'),
                        value: filterProvider.isAge13To17Selected,
                        onChanged: (value) {
                          filterProvider.toggleAge13To17Selected(value!);
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('18-25'),
                        value: filterProvider.isAge18To25Selected,
                        onChanged: (value) {
                          filterProvider.toggleAge18To25Selected(value!);
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('26-35'),
                        value: filterProvider.isAge26To35Selected,
                        onChanged: (value) {
                          filterProvider.toggleAge26To35Selected(value!);
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('36-50'),
                        value: filterProvider.isAge36To50Selected,
                        onChanged: (value) {
                          filterProvider.toggleAge36To50Selected(value!);
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('50+'),
                        value: filterProvider.isAge50plusSelected,
                        onChanged: (value) {
                          filterProvider.toggleAge50plusSelected(value!);
                        },
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
                              // Apply filter logic here
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar()),
                              );
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
                );
              },
            );
          },
        );
      },
    );
  }
}
