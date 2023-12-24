import 'package:flutter/material.dart';
import 'package:start_and_earn/components/text_style.dart';

import '../components/colors.dart';
import '../components/paths.dart';

appBarJustLead({required BuildContext context,Widget? leadIcon,Color? bgColor,String? titleText,Widget? action}){
  return AppBar(
    backgroundColor: bgColor ?? transparentColor,
    leading: IconButton(
      onPressed: (){Navigator.pop(context);},
      icon: leadIcon ?? backMainArrow,
    ),
    centerTitle: true,
    actions: [
      action ?? Container()
    ],
    title: Text(titleText ?? "",style: txtStyle18AndMainBold,),
    elevation: 0,
  );
}