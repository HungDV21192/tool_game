import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tool_eat_all_game/utils/constants.dart';

enum TypeMessageDisplay { SUCCESS, INFO, ERROR }

void showMessageToUserNowToast(String message,
    {TypeMessageDisplay typeMessageDisplay = TypeMessageDisplay.SUCCESS,
    ToastGravity toastGravity = ToastGravity.CENTER,
    bool isLongToast = false}) {
  print('showMessageToUserNow: $message');
  Color color = defaultColor;
  if (typeMessageDisplay == TypeMessageDisplay.INFO) {
    color = Colors.blueAccent;
  } else if (typeMessageDisplay == TypeMessageDisplay.ERROR) {
    color = Colors.redAccent;
  }
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: isLongToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIosWeb: isLongToast ? 5 : 3,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 18.0);
}

void showErrorMessage(
    {String? message, dynamic? data, bool isLongToast = false}) {
  if (data != null) {
    if (data is List && data.isNotEmpty) {
      showErrorMessage(message: data.first, isLongToast: isLongToast);
    } else {
      showErrorMessage(message: data, isLongToast: isLongToast);
    }
  } else {
    showMessageToUserNowToast(
        message != null ? message : 'Có lỗi xẩy ra vui lòng thử lại',
        typeMessageDisplay: TypeMessageDisplay.ERROR,
        isLongToast: isLongToast);
  }
}

Future<bool?> showConfirmDialog(
    {required BuildContext context, required String content}) async {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("CANCEL"),
    onPressed: () => Get.back(result: false),
  );
  Widget continueButton = TextButton(
    child: Text("  OK  "),
    onPressed: () => Get.back(result: true),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Chú ý".toUpperCase()),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
const decoder = JsonDecoder();
const encoder = JsonEncoder.withIndent('  ');

String prettyPrintJson(String input) {
  var object = decoder.convert(input);
  var prettyString = encoder.convert(object);
  return prettyString;
}
