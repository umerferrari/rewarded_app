import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';

textField({
  TextEditingController? controller,
  TextInputType? keyboardType,
  Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
  String? hintText,
  int? maxLine,
  String? Function(String?)? validator
}){
  return TextFormField(
    controller: controller,
    cursorColor: mainColor,
    maxLines: maxLine,
    inputFormatters: inputFormatters,
    style: txtStyle14,
    validator: validator,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
          vertical: 0, horizontal: 10),
      hintText: hintText,
      hintStyle: txtStyle12AndOther,
      border: OutlineInputBorder(
        borderRadius: kBorderRadius10,
        borderSide: BorderSide(
            color: otherColor, width: 0.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kBorderRadius10,
        borderSide:  BorderSide(
            color: otherColor, width: 0.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kBorderRadius10,
        borderSide: BorderSide(
            color: otherColor, width: 0.2),
      ),
      // suffixIcon: suffixIcon?? Container(),
    ),
  );
}