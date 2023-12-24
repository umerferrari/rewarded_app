import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';

Widget gameBtn(void Function()? onTap, String imagePath, double width) {
  return GestureDetector(
    onTap: onTap,
    child: Image.asset(imagePath, width: width),
  );
}
button({required BuildContext context,Function()? onTap,String? btnText,Color? bgColor,Color? btnTextColor,TextStyle? btnTextStyle}){
  final scrSize = MediaQuery.of(context).size;
  return SizedBox(
    height: 45,
    width: scrSize.width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius10,
        ),
        foregroundColor: textColor,
      ),
      onPressed: onTap,
      child: Text(btnText ?? "",style: btnTextStyle ?? TextStyle(
        color: btnTextColor ?? mainColor,
        fontFamily: "poppins"
      ),),
    ),
  );
}

iconButton({required BuildContext context,required Function() onTap,Widget? icon,String? btnText}){
  final scrSize = MediaQuery.of(context).size;
  return SizedBox(
    height: 45,
    width: scrSize.width,
    child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: mainColor,
          shadowColor: transparentColor,
          backgroundColor: transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius10,
            side:  BorderSide(color: otherColor,width: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            icon == null? Container() : const SizedBox(width: 10,),
            Text(btnText ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: txtStyle12AndBold,),
          ],
        )),
  );
}
