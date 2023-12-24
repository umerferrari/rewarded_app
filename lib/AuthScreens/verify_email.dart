import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start_and_earn/AuthScreens/signup_profile_info.dart';
import 'package:start_and_earn/components/colors.dart';

import '../Provider/auth_provider.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../widgets/button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key,}) : super(key: key);
  // final UserCredential? credential;
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      _user = _auth.currentUser;
      _user?.reload();
      iniCheck();
    });
  }


  Future<void> _sendEmailVerification() async {
    _user = _auth.currentUser;
    await _user?.sendEmailVerification();
  }


  iniCheck
      () {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload().then((value) {
        print("obRject");
        print(FirebaseAuth.instance.currentUser!.emailVerified);
        print(FirebaseAuth.instance.currentUser!.email);
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.cancel();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpProfileInfo(),
                ),
                    (route) => false);
          }
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {

  return
    FirebaseAuth.instance.currentUser!.emailVerified? SignUpProfileInfo()
      :
  SafeArea(
    child: Scaffold(
      // backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: transparentColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Verify email", style: txtStyle16AndMainBold,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/hourglass.gif", height: 100,),
            sizeHeight15,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text("Waiting for your ${FirebaseAuth.instance.currentUser!
                  .email} email verification.",
                textAlign: TextAlign.center,
                style: txtStyle14AndOther,
              ),
            ),
            sizeHeight20,
            // button(context: context,onTap: (){
            //   FirebaseAuth.instance.currentUser?.sendEmailVerification();
            // },btnText: "Again Send Verification Code",btnTextColor: whiteColor),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              child: button(
                  onTap: () async {
                    // await _sendEmailVerification();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpProfileInfo()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Verification email sent.'),
                      ),
                    );
                  },
                  btnText: 'Send Verification Email',
                  context: context,
                  btnTextColor: textColor
              ),
            ),
            sizeHeight15,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Another account using",
                textAlign: TextAlign.center,
              ),
            ),
            sizeHeight15,
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              child: button(
                  context: context,
                  onTap: () async {
                    final provider = Provider.of<AuthenProvider>(
                        context, listen: false);
                    provider.logOutFun(context: context);
                  },
                  btnText: 'Back to sign up process',
                  btnTextColor: textColor
              ),
            ),
            sizeHeight15,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: Text(
            //     "If you wish Delete your account Click Delete button",
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // sizeHeight15,
            // SizedBox(
            //   width: MediaQuery.of(context).size.width*0.7,
            //   child:  button(
            //       context: context,
            //       onTap: () async {
            //         deleteAccountDialog(context: context);
            //       },
            //       btnText: 'Delete',
            //       btnTextColor: whiteColor,
            //       bgColor: redColor
            //   ),
            // ),


          ],
        ),
      ),
    ),
  )
  ;
}
}
