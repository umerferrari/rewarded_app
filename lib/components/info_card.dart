import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
Widget info_card(String title, String info) {
  return Expanded(
    child: Container(
      height: 90,
      margin: EdgeInsets.only(top: 26.0, left: 26.0, right: 26.0),
      // padding: EdgeInsets.symmetric(horizontal: 26.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow.shade700),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            Text(
              info,
              style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold ,color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
