import 'package:flutter/material.dart';

class IntEditingController extends TextEditingController {
  int getIntValue() {
    final text = this.text;
    if (text == null || text.isEmpty) {
      return 0;
    }
    return int.tryParse(text) ?? 0;
  }

  setIntValue(int value) {
    text = value.toString();
  }
}
