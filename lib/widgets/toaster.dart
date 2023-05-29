import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static void showCustomToast(
    String message,
    IconData icon,
    BuildContext context, {
    ToastGravity positionOnScreen = ToastGravity.BOTTOM,
  }) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey[600],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12.0),
          message.length > 20
              ? Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                  ),
                )
              : Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: positionOnScreen,
      toastDuration: const Duration(seconds: 3),
    );
  }

  static void clearToast() {
    FToast fToast = FToast();
    fToast.removeQueuedCustomToasts();
  }
}
