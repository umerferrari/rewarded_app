import 'package:flutter/material.dart';

import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';

userDashboardCardWithOnTap({String? imagePath,Color? iconColor,String? title,String? subtitle,Function()? onTap}){
  return Card(
    color: blackOtherColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(imagePath ??'',color: iconColor ?? redColor,)),
            sizeWidth10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Text
                  Text(
                    title ?? '',
                    style: txtStyle16AndBold,
                  ),

                  ///Text_description
                  Text(
                    subtitle ??
                    '',
                    style: txtStyle12AndOther,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}