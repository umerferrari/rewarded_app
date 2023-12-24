import 'package:flutter/material.dart';
import 'package:start_and_earn/HomeScreen.dart';
import 'package:start_and_earn/components/text_style.dart';

import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../widgets/button.dart';

class TermsConditionsSignup extends StatefulWidget {
  const TermsConditionsSignup({Key? key}) : super(key: key);

  @override
  State<TermsConditionsSignup> createState() => _TermsConditionsSignupState();
}

class _TermsConditionsSignupState extends State<TermsConditionsSignup> {
  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          // backgroundColor: whiteColor,
          body: Column(
            children: [
              sizeHeight40,
              Expanded(
                // height: scrSize.height*0.45,
                // width: scrSize.width,
                  child: Image.asset("termsConditionImage",fit: BoxFit.cover,)),
              // Spacer(),
              sizeHeight50,
              Padding(
                padding: kPaddingHorizontal20,
                child: Text("All done now",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    fontSize: 25,
                    // fontFamily: "poppins",
                    color: textColor
                ),),
              ),
              sizeHeight10,
              Padding(
                padding: kPaddingHorizontal20,
                child: Text("It's time for you to explore everything",style: txtStyle12AndOther,),
              ),
              sizeHeight30,
              Padding(
                padding: kPaddingHorizontal20,
                child: button(
                  context: context,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreenSTL()));
                    // Navigator.push(context, );
                  },
                  bgColor: mainColor,
                  btnText: "Start exploring the app",
                  btnTextColor: textColor,
                ),
              ),
              sizeHeight40,
            ],
          ),
        ));
  }
}
