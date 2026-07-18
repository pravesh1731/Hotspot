import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mySnackBar({
  required String message,
  required BuildContext context,
  Color color = Colors.blue,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: Duration(seconds: 1),
      content: (Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      )),
    ),
  );
}
