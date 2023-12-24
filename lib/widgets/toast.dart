import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../components/colors.dart';


/// Shows a toast in android
class AppToast {
  /// Shows a toast with the message in android
  static void show(String shortMessage) {
    Fluttertoast.showToast(
        msg: shortMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        fontSize: 14.0);
  }
}

final indicatorMainColor = Center(child: CircularProgressIndicator(color: mainColor,),);
final indicatorWhiteColor = Center(child: CircularProgressIndicator(color: textColor,),);

showMyWaitingModal({required BuildContext context}){
  return  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Center(
        child: CircularProgressIndicator(color: mainColor),
      );
    },
  );
}