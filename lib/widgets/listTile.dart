import 'package:flutter/material.dart';

listTileLeadWidgetAndTitleTextString({required Widget lead,required String title,required Function() onTap}){
  return ListTile(
    visualDensity: VisualDensity(
      vertical: -4
    ),
    onTap: onTap,
    leading: lead,
    title: Text(title),
  );
}