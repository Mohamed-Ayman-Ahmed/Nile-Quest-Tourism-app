import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nile_quest/shared/styles/colors.dart';

void showToast({
  required String message,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: mainColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
