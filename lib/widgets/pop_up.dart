import 'package:flutter/material.dart'; // TODO: IS NOT USED (USING TOASTER INSTEAD (1/5)), SHOULD WE REMOVE?? (VIKTOR)

class PopUp extends StatelessWidget {
  final String title;
  final String message;

  const PopUp({super.key, 
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}