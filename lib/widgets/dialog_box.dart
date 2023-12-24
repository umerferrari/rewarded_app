import 'package:flutter/material.dart';

import '../components/colors.dart';

customDialog({context,content}){
  return showDialog(
      context: context,
      builder: (_){
        return
          Dialog(
            backgroundColor: blackOtherColor,
            insetPadding: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.center,
            // actionsPadding: EdgeInsets.zero,
            // titlePadding: EdgeInsets.zero,
            // iconPadding: EdgeInsets.zero,
            // buttonPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(21),
            ),
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  children: [
                    content,
                  ],
                ),
              ],
            ),
          );
      });
}