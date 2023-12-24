import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_and_earn/HomeScreen.dart';

import 'AuthScreens/onboarding.dart';
import 'AuthScreens/signup_profile_info.dart';
import 'AuthScreens/verify_email.dart';
import 'Provider/auth_provider.dart';
import 'Widgets/toast.dart';
import 'components/DB_keys.dart';
import 'components/paths.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String isCheckLogged = "true";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final isLogged = pref.getBool(SplashScreen.isCheckLogged);
    return AnimatedSplashScreen(
      splash: splashScreenIcon,
      nextScreen:
      isLogged == null ? OnBoarding() :
      isLogged == true?
        HomeScreenSTL()
      :

      IsUserCheck()


      ,
      // userDataStore != null && userDataStore!.userDataSet == false? SignUpProfileInfo()
      //   :

      // IsUserCheck(),
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}



class IsUserCheck extends StatefulWidget {
  const IsUserCheck({Key? key}) : super(key: key);

  @override
  State<IsUserCheck> createState() => _IsUserCheckState();
}

class _IsUserCheckState extends State<IsUserCheck> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context,snapshot){
      if(snapshot.data == null){
        print("ok 1");
       return OnBoarding();
      }
      else{
        return VerifyEmailScreen();
      }
    });
  }
}


class ProFileGetter extends StatefulWidget {
  const ProFileGetter({Key? key}) : super(key: key);

  @override
  State<ProFileGetter> createState() => _ProFileGetterState();
}

class _ProFileGetterState extends State<ProFileGetter> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // initialData:
        stream: checkVerifiedUserStreamFun(),
        builder: (context, snap){
            if(snap.data?.data()== null){
            print("ali 2");
            return SignUpProfileInfo();
          }
          else if(snap.data?.get(DBkeys.userBio) == null){
            print("ali 3");
            return SignUpProfileInfo();
          }
          else{
            print("ali 4");
            print("email else");
            print("else");
            return HomeScreenSTL();
          }

    });
  }
}


class PhoneAuthCheckStreamBuilder extends StatefulWidget {
  const PhoneAuthCheckStreamBuilder({Key? key}) : super(key: key);

  @override
  State<PhoneAuthCheckStreamBuilder> createState() => _PhoneAuthCheckStreamBuilderState();
}

class _PhoneAuthCheckStreamBuilderState extends State<PhoneAuthCheckStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:FirebaseFirestore.instance.collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
        builder: (context, snap){
          // print("bilal${snap.data!.data().toString()}");
          if(snap.data == null){
            return Scaffold(
              body: Center(
                child: indicatorWhiteColor,
              ),
            );
          }
          else if(snap.data?.data() == null){
            return SignUpProfileInfo();
          }
          else{
            print("phone else");

            return HomeScreenSTL();
          }

        });
  }
}


class GoogleAuthCheckStreamBuilder extends StatefulWidget {
  const GoogleAuthCheckStreamBuilder({Key? key}) : super(key: key);

  @override
  State<GoogleAuthCheckStreamBuilder> createState() => _GoogleAuthCheckStreamBuilderState();
}

class _GoogleAuthCheckStreamBuilderState extends State<GoogleAuthCheckStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:checkVerifiedUserStreamFun(),
        builder: (context, snap){
          print("bilal${snap.data?.data().toString()}");
          if(snap.data == null || snap.data?.data() == null){
            return Scaffold(
              body: Center(
                child: indicatorWhiteColor,
              ),
            );
          }
          else if(snap.data?.get("user_bio") == ""){
            return SignUpProfileInfo();
          }
          else{
            print("google else");
            return HomeScreenSTL();
          }

        });
  }
}

Stream<DocumentSnapshot> checkVerifiedUserStreamFun(){
  return FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
}