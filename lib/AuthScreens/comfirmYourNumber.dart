import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_and_earn/AuthScreens/signup_profile_info.dart';
import 'package:start_and_earn/AuthScreens/signup_screen.dart';

import '../Provider/auth_provider.dart';
import '../components/DB_keys.dart';
import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../main.dart';
import '../model/user_info_modal_class.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/toast.dart';

class ConfirmYourNumber extends StatefulWidget {
  const ConfirmYourNumber({Key? key}) : super(key: key);

  @override
  State<ConfirmYourNumber> createState() => _ConfirmYourNumberState();
}

class _ConfirmYourNumberState extends State<ConfirmYourNumber> {
  var codeValue = "";
  int _resendOtpTimer = 0;
  int _resendOtpDuration = 30; // Duration in seconds

  void startResendOtpTimer() {
    setState(() {
      _resendOtpTimer = _resendOtpDuration;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendOtpTimer > 0) {
          _resendOtpTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> resendOtp() async {
    final provider = Provider.of<AuthenProvider>(context,listen: false);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: provider.storePhoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
      },
      codeSent: (String verificationId, int? resendToken) async {
        SignUpScreen.verificationId = verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    // Implement your OTP resend logic here
    // This function will be called when the user taps on the "Resend OTP" button

    // Example code: You can simulate a delay and display a success message
    Future.delayed(Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OTP Resent'),
            content: Text('OTP has been resent successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    // Start the resend OTP timer
    startResendOtpTimer();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    return Consumer<AuthenProvider>(builder: (context,provider,child){
      return SafeArea(
          child: Scaffold(
            appBar: appBarJustLead(context: context,titleText: "Confirm number"),
            // backgroundColor: whiteColor,
            // appBar: appBar(title: "Confirm your number", context: context),
            body: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeHeight40,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.04),
                    child: Text("Enter the code we've sent by SMS to ${provider.storePhoneNum}",style: txtStyle18Andw500,),
                  ),
                  const SizedBox(height: 40,),

                  ///OTp
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.04),
                    child: OTPTextField(
                      length: 6,
                      hasError: false,

                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 40,
                      // otpFieldStyle: ,
                      style: TextStyle(
                          fontSize: 17
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        codeValue = pin;
                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.04),
                      child:
                      Row(
                        children: [
                          Text("Haven't received a code? ",style: TextStyle(
                              color: otherColor,
                              fontFamily: "cereal",
                              fontSize: 12
                          ),),
                          TextButton(
                              onPressed: _resendOtpTimer > 0 ? null : resendOtp,
                              child: Text(  _resendOtpTimer > 0
                                  ? " Resend in $_resendOtpTimer seconds" : "Send again",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontFamily: "cereal"
                                // fontSize: 17,
                                // decoration: TextDecoration.underline
                              ),)),
                        ],
                      )

                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width*0.04),
                    width: width,
                    height: 50,
                    child: button(
                        context: context,
                        btnText: "Continue",
                        bgColor: mainColor,
                        btnTextColor: textColor,
                        onTap: ()async{
                          // Create a PhoneAuthCredential with the code
                          showMyWaitingModal(context: context);
                          try{
                           PhoneAuthCredential credential = PhoneAuthProvider.credential(
                               verificationId: SignUpScreen.verificationId,
                               smsCode: codeValue,
                           );

                           // Sign the user in (or link) with the credential
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                           User? user = userCredential.user;
                           bool userExists = await checkIfUserExists(user!.uid);
                           UserInfoModal? userInfo = await provider.getUserInfo(uid: user.uid);
                           if (!userExists) {
                             showMyWaitingModal(context: context);
                             String? token = await FirebaseMessaging.instance.getToken();

                             // User does not exist, store user data in Firestore
                             await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
                               DBkeys.userName: "",
                               DBkeys.userBio : "",
                               "uid": user.uid.toString(),
                               DBkeys.userPhoto: "",
                               "phone_number": provider.storePhoneNum,
                               "email": "",
                               DBkeys.userGroups : [],
                               DBkeys.userMuteGroup : [],
                               DBkeys.token: token,
                               DBkeys.isRegisterMethod: "number",
                               DBkeys.userGender: "",
                               DBkeys.createdAt : DateTime.now().millisecond.toString()
                             }).then((value) async {
                               // SharedPreferences sf = await SharedPreferences.getInstance();
                               // await sf.setString(DBkeys.isRegisterMethod, "phone");
                             pref.setString(DBkeys.isRegisterMethod, "number");
                             pref.setString("userUid", user.uid.toString() );
                             // pref.setBool(SplashScreen.isCheckLogged, true);
                             Navigator.pop(context);
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpProfileInfo()));
                             });
                           }else if(userInfo == null || userInfo.bio.isEmpty == true || userInfo.bio == ""){
                             print("myDataok $userInfo");
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpProfileInfo(googleAuthImageUrl: user.photoURL,googleAuthUserName: user.displayName,)));
                           }else{
                             // SharedPreferences sf = await SharedPreferences.getInstance();
                             pref.setString(DBkeys.isRegisterMethod, "number");
                             pref.setString("userUid", user.uid.toString());
                             // pref.setBool(SplashScreen.isCheckLogged, true);
                             AppToast.show("Welcome");
                             // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomBar()), (route) => false);
                           }
                         }catch(e){
                           AppToast.show(e.toString());
                         };
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpProfileInfo()));
                        }
                    ),
                  ),

                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ));
    });
  }
}
