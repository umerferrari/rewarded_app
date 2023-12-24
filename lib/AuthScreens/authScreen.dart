import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../HomeScreen.dart';
import '../logInForm.dart';
import '../signUpForm.dart';
import '../utils/showOTP.dart';
import '../utils/showSnackbar.dart';


class FirebaseAuthMethods {

  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  DatabaseReference database = FirebaseDatabase.instance.ref();
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  User get user => FirebaseAuth.instance.currentUser!;
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      print('Email verification sent!');
    } on FirebaseAuthException catch (e) {
      print(e.message!); // Display error message
    }
  }
  Future<void> signUpWithEmail(
  {
    required String email,
    required String password,
    required BuildContext context,
  }
      ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
        Get.to(HomeScreenSTL());
      }
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }
///Google Auth
  Future<void> googleSignIn()async{
    try{
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      final googleAuth = await googleAccount!.authentication;
      if(googleAccount != null){
        if(googleAuth.accessToken != null && googleAuth.idToken != null){
          await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
            ///Create a new Credential
            final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken
            );
            UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            User? user = userCredential.user;
            if(user != null){
              print(user);
              ///Databse
              await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).set(
                  {
                    "username": user.displayName.toString(),
                    // "UID" : user.uid.toString(),
                    "profilePhoto": user.photoURL.toString(),
                    "phone": user.phoneNumber.toString(),
                    "email":user.email.toString(),

                  });
              ///Withdraw Nodes
              await database
                  .child('Withdraw')
                  .child(FirebaseAuth
                  .instance.currentUser!.uid)
                  .set({
                "Game_Name": "No Withdraw",
                "Reward": "-----",
                "Player_ID": "-----",
                "Data_and_Time": "-----"
              });
              ///Spins Nodes
              await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).set({
                "Current_Coins": 0,
              });
              Get.offNamed('/home');

              ///Firestore
              // await firedatabase.doc(FirebaseAuth.instance.currentUser!.uid).set(
              //     {
              //       "UserName": user.displayName.toString(),
              //       "UID" : user.uid.toString(),
              //       "profilePhoto": user.photoURL.toString(),
              //       "Phone_Number": user.phoneNumber.toString(),
              //       "Email":user.email.toString(),
              //     });
              ///Firestore enc

              //           if(userCredential.additionalUserInfo!.isNewUser){
              //
              //   Get.offNamed("/home");
              // }
              // Get.to(const signUpHomeScreenSTL());
            }

        }
      }
    }catch(e){print(e.toString());}


  }

  ///Facebook
  void facebookAuth()async{
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        ///Create a new Creadential
        final credential = FacebookAuthProvider.credential(
            loginResult.accessToken!.token
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;
        if(user != null){
          print(user);
          ///Databse
          await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).set(
              {
                "username": user.displayName.toString(),
                // "UID" : user.uid.toString(),
                "profilePhoto": user.photoURL.toString(),
                "phone": user.phoneNumber.toString(),
                "email":user.email.toString(),

              });
          ///Withdraw Nodes
          await database
              .child('Withdraw')
              .child(FirebaseAuth
              .instance.currentUser!.uid)
              .set({
            "Game_Name": "No Withdraw",
            "Reward": "-----",
            "Player_ID": "-----",
            "Data_and_Time": "-----"
          });
          ///Spins Nodes
          await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).set({
            "Current_Coins": 0,
          });
          Get.offNamed('/home');
        }
    }on FirebaseAuthException catch(e){
      print(e.message!);
    }
  }
  ///Delte
  Future<void> deleteAccount(BuildContext context)async{
    try{
      await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).remove();
      await database.child("Spins").child(FirebaseAuth.instance.currentUser!.uid).remove();
      await database.child("Withdraw").child(FirebaseAuth.instance.currentUser!.uid).remove();
      await FirebaseAuth.instance.currentUser?.delete();
      Get.off(const logInFormSTL());
    }catch(e){print(e);}
  }
  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Get.offNamed('/');
    } on FirebaseAuthException catch (e) {
      print( e.message!); // Displaying the error message
    }
  }
  // PHONE SIGN IN
  Future<void> phoneSignIn(
      BuildContext context,
      String phoneNumber,
      ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
      await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
         Get.off(phoneAuthData());// Remove the dialog box

          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              // !!! Works only on Android, iOS !!!
              await _auth.signInWithCredential(credential);

                Navigator.push(context, MaterialPageRoute(builder: (context)=> phoneAuthData()));// Remove the dialog box

            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

}