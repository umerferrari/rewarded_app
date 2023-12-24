import 'package:flutter/material.dart';
import 'package:start_and_earn/AuthScreens/signup_screen.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/text_style.dart';
import '../components/sizedbox.dart';
import '../widgets/button.dart';
import 'login_phone_and_buttons.dart';
import 'login_screen.dart';


class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.green,
          body:
            // Text('data')
          Column(
            children: [
              Expanded(
                  // height: scrSize.height*0.45,
                  // width: scrSize.width,
                  child: Image.asset("onBoardingSvgImage",fit: BoxFit.cover,)),
             // Spacer(),
              sizeHeight20,
              Text("Let's Get Started",maxLines: 2,textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,style: TextStyle(
                fontWeight: FontWeight.w500,
                height: 1.2,
                // fontFamily: "poppins",
                fontSize: 40,
                color: textColor
              ),),
              sizeHeight20,
              Padding(
                padding: kPaddingHorizontal20,
                child: Text("To incentive active users and promote engagement, the app offers a rewards system. Engaging with friends, and inviting others to join.",
                  style: txtStyle14AndOther,),
              ),
              sizeHeight30,
              Padding(
                padding: kPaddingHorizontal20,
                child: button(
                  context: context,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                  bgColor: mainColor,
                  btnText: "Join Now",
                  btnTextColor: textColor,
                ),
              ),
              Container(),
              sizeHeight15,
              Padding(
                padding: kPaddingHorizontal20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Already have an account?",style: txtStyle14AndOther,),
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: mainColor,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreenPhoneAndButtons()));
                      }, child: Text("Login",style: txtStyle14AndMainBold,)),

                  ],
                ),
              ),
              sizeHeight15
            ],
          ),
        ));
  }
}
