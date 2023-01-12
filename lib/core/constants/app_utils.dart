import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  showToast(String message, Color toastColor) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: toastColor,
    );
  }

  showScaffoldMessenger(String message, Color color, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }
}
