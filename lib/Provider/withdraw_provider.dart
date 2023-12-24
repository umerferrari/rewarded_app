import 'package:flutter/material.dart';

class WithdrawProvider extends ChangeNotifier {
  String storePhoneNumber = "";
  storePhoneNumberFun({value}){
    storePhoneNumber = value;
    notifyListeners();
  }

}