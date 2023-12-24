import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreens/signup_profile_info.dart';
import '../AuthScreens/verify_email.dart';
import '../components/DB_keys.dart';
import '../components/colors.dart';
import '../main.dart';
import '../model/user_info_modal_class.dart';
import '../widgets/toast.dart';
import 'image_picker.dart';

class AuthenProvider extends ChangeNotifier {
  ///Shared Prefference
  static const String _isLoggedInKey = 'isLoggedIn';

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  ///Login Password
  bool isHidePasswordBool = true;

  isHidePasswordFun() {
    isHidePasswordBool = !isHidePasswordBool;
    notifyListeners();
  }

  String isIconColorChange = "";

  isIconColorChangeFun(val) {
    isIconColorChange = val;
    notifyListeners();
  }

  ///Remember me checkbox
  bool rememberMeBool = false;

  rememberMeFun(val) {
    rememberMeBool = val;
    notifyListeners();
  }

  ///agree
  bool agreeBool = false;

  agreeFun(val) {
    agreeBool = val;
    notifyListeners();
  }

  ///google sign in
  // Future<UserCredential> signInWithGoogle({required BuildContext context}) async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //   User? user = userCredential.user;
  //   if(user != null){
  //     print(user);
  //     ///Firestore
  //     await FirebaseFirestore.instance.collection("Authentication").doc(FirebaseAuth.instance.currentUser!.uid).set(
  //         {
  //           "UserName": user.displayName.toString(),
  //           "UID" : user.uid.toString(),
  //           "name" : "",
  //           "profilePhoto": user.photoURL.toString(),
  //           "Phone_Number": user.phoneNumber.toString(),
  //           "Email":user.email.toString(),
  //         });
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpProfileInfo()));
  //   }
  //
  //   // print(credentia);
  //   // Once signed in, return the UserCredential
  //   // final checKStatus = FirebaseAuth.instance.signInWithCredential(credential);
  //   // if(checKStatus == true){
  //   //   isLoggedIn().then((loggedIn) {
  //   //     setLoggedIn(!loggedIn).then((_) {
  //   //       print('Login status toggled');
  //   //     });
  //   //   });
  //   // }
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  //   // return checKStatus;
  //
  //   // notifyListeners();
  // }
  ///
  // Future<UserCredential> signInWithGoogle({required BuildContext context}) async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //   User? user = userCredential.user;
  //
  //   if (user != null) {
  //     print(user);
  //     // Store user data in Firestore
  //    await FirebaseFirestore.instance.collection("Authentication").doc(user.uid).set({
  //       "UserName": user.displayName.toString(),
  //       "UID": user.uid.toString(),
  //       // "name": "",
  //       "created_at" : DateTime.now(),
  //       "profilePhoto": user.photoURL.toString(),
  //       "Phone_Number": user.phoneNumber.toString(),
  //       "Email": user.email.toString(),
  //     });
  //   }
  //
  //   // Check if the user exists
  //   bool userExists = await checkIfUserExists(user!.uid);
  //   if (userExists) {
  //     // User exists, navigate to home screen
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar()));
  //   } else {
  //     // User does not exist, navigate to another page
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpProfileInfo()));
  //   }
  //
  //   return userCredential;
  // }

  ///
  Future<UserCredential> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      print(user);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(color: mainColor,),
          );
        },
      );
      // Check if the user already exists
      bool userExists = await checkIfUserExists(user.uid);
      UserInfoModal? userInfo = await getUserInfo(uid: user.uid);
      if (!userExists) {
        final imageProvider = Provider.of<ImagePickerProvider>(context,listen: false);
        imageProvider.getImageSignUp = File(user.photoURL!);
        notifyListeners();
        // User does not exist, store user data in Firestore
        String? token = await FirebaseMessaging.instance.getToken();

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          DBkeys.userName: user.displayName.toString(),
          DBkeys.userBio : "",
          DBkeys.userPhoto: user.photoURL.toString(),
          "phone_number": user.phoneNumber != null? user.phoneNumber.toString() : "",
          DBkeys.isRegisterMethod : "google",
          DBkeys.userGroups : [],
          DBkeys.userMuteGroup : [],
          DBkeys.userGender : "",
          "uid": user.uid.toString(),
          "email": user.email.toString(),
          // "password": "",
          DBkeys.token: token,
          DBkeys.createdAt : DateTime.now().millisecond.toString()
        }).then((value) {
          pref.setString(DBkeys.isRegisterMethod, "google");
          pref.setString("userUid", user.uid.toString() );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpProfileInfo(googleAuthImageUrl: user.photoURL,googleAuthUserName: user.displayName,)));

        });
        // await mUpdateToken(FirebaseAuth.instance.currentUser!.uid);
      }else if(userInfo == null || userInfo.bio.isEmpty == true || userInfo.bio == ""){
        print("myDataok $userInfo");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpProfileInfo(googleAuthImageUrl: user.photoURL,googleAuthUserName: user.displayName,)));
      }
      else{
        print("else $userInfo");
        pref.setString(DBkeys.isRegisterMethod, "google");
        pref.setString("userUid", user.uid.toString() );
        // pref.setBool(SplashScreen.isCheckLogged, true);
        AppToast.show("Welcome Back");
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBar()));
      }
    }
    // Navigator.pop(context); // Close the loading indicator

    // Navigator.push(context, MaterialPageRoute(builder: (context) => user != null ? BottomBar() : SignUpProfileInfo()));
    return userCredential;
  }

  UserInfoModal? userInfoStore;
  bool userInfoDataLoadedBool = false;
  userInfoDataLoadedTrueFun(value){
    userInfoDataLoadedBool == value;
    notifyListeners();
  }

  List<UserInfoModal> users = [];

  Future<UserInfoModal?> userInfoFun({required String uid}) async {
    userInfoDataLoadedTrueFun(false);
    print("userInfoDataLoadedBoolStart ====== $userInfoDataLoadedBool");
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection("users")
          .doc(uid)
          .get();

      if (documentSnapshot.exists) {
        // Extract user data from the documentSnapshot
        String name = documentSnapshot.get(DBkeys.userName);
        String email = documentSnapshot.get("email");
        String phone_number = documentSnapshot.get("phone_number");
        // String password = documentSnapshot.get("password");
        String uid = documentSnapshot.get("uid");
        // String created_at = documentSnapshot.get("created_at");
        String image_url = documentSnapshot.get(DBkeys.userPhoto);
        String bio = documentSnapshot.get(DBkeys.userBio);
        List<dynamic> allGroup = documentSnapshot.get(DBkeys.userGroups);
        List<dynamic> muteGroup = documentSnapshot.get(DBkeys.userMuteGroup);
        String token = documentSnapshot.get(DBkeys.token);
        String isRegisterMethod = documentSnapshot.get(DBkeys.isRegisterMethod);
        String gender = documentSnapshot.get(DBkeys.userGender);
        String createdAt = documentSnapshot.get(DBkeys.createdAt);
        // String groups = documentSnapshot.get("groups");
        // String email = documentSnapshot.get('email');
        // String? token = await FirebaseMessaging.instance.getToken();
        // Create a new UserInfoModal instance with the retrieved data
        UserInfoModal userInfo = UserInfoModal(
            email: email,
            uid: uid,
            bio: bio,
            userName: name,
            gender: gender,
            created_at: createdAt,
            // groups: groups,
            phone_number: phone_number,
            image_url: image_url,
            token: token,
            allGroups: allGroup,
            muteGroups: muteGroup,
            isRegisterMethod: isRegisterMethod,
        );

        // Add the userInfo to the userInfoStore list
        userInfoStore = userInfo;
        notifyListeners();
        if(userInfoStore != null){
        userInfoDataLoadedTrueFun(true);

        }
        notifyListeners();
        print("userInfoDataLoadedBool ====== $userInfoDataLoadedBool");
        return userInfoStore;
        // Success, user data fetched and added to the list

        // return true;
      } else {
        // Document with the given uid doesn't exist
        // AppToast.show('User data not found for uid: $uid');
        print('User data not found for uid: $uid');
        // return false;
      }
    } catch (e) {
      // Handle any potential errors here
      // AppToast.show('Error fetching user data: ${e.toString()}');

      print('Error fetching user data: ${e.toString()}');
      // return false;
    }
  }
  Future<UserInfoModal?> getUserInfo({required String uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (documentSnapshot.exists) {
        String name = documentSnapshot.get(DBkeys.userName);
        String email = documentSnapshot.get("email");
        String phone_number = documentSnapshot.get("phone_number");
        String image_url = documentSnapshot.get(DBkeys.userPhoto);
        String bio = documentSnapshot.get(DBkeys.userBio);
        List<dynamic> allGroup = documentSnapshot.get(DBkeys.userGroups);
        List<dynamic> muteGroup = documentSnapshot.get("mute_groups");
        String token = documentSnapshot.get(DBkeys.token);
        String isRegisterMethod = documentSnapshot.get(DBkeys.isRegisterMethod);
        String gender = documentSnapshot.get(DBkeys.userGender);
        String createdAt = documentSnapshot.get(DBkeys.createdAt);

        UserInfoModal userInfo = UserInfoModal(
          email: email,
          uid: uid,
          bio: bio,
          userName: name,
          gender: gender,
          created_at: createdAt,
          phone_number: phone_number,
          image_url: image_url,
          token: token,
          allGroups: allGroup,
          muteGroups: muteGroup,
          isRegisterMethod: isRegisterMethod,
        );

        userInfoDataLoadedTrueFun(true);
        return userInfo;
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching user data: $error");
      return null;
    }
  }  ///Google Auth
  Future<List<UserInfoModal>?> getAllUserInfo({required List<dynamic> uidList}) async {
    try {
    List<UserInfoModal> users = [];

      if (uidList.isNotEmpty) {

        final chunks = partition(uidList, 10);
        await Future.wait(chunks.map((e) async {
          await FirebaseFirestore.instance
              .collection("users")

              .where("uid", whereIn: e)
              .get()
              .then((value) {

            for (var element in value.docs) {
              UserInfoModal model = UserInfoModal(
                  gender: element.get(DBkeys.userGender),
                  isRegisterMethod: element.get(DBkeys.isRegisterMethod),
                  allGroups: element.get(DBkeys.userGroups),
                  muteGroups: element.get("mute_groups"),
                  token: element.get(DBkeys.token),
                  image_url: element.get(DBkeys.userPhoto),
                  uid: element.get("uid"),
                  bio: element.get(DBkeys.userBio),
                  userName: element.get(DBkeys.userName),
                  created_at: element.get(DBkeys.createdAt));
              users.add(model);
            }
          });
        }));
      }
        return users;

    } catch (error) {
      print("Error fetching user data: $error");
      return null;
    }
  }  ///Google Auth

  final FirebaseStorage _storage = FirebaseStorage.instance;
  ///Storage
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Generate a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';

      // Get the storage reference
      Reference reference = _storage.ref().child('images').child(FirebaseAuth.instance.currentUser!.uid).child(fileName);

      // Upload the file to Firebase Storage
      TaskSnapshot taskSnapshot = await reference.putFile(imageFile);

      // Get the image URL from the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Return the image URL
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase: ${e.toString()}');
      return null;
    }
  }

  // Future<String?> uploadImageToFirebase(File imageFile) async {
  //   try {
  //     // Generate a unique file name for the image
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
  //
  //     // Get the storage reference
  //     Reference reference = _storage.ref().child('images').child(FirebaseAuth.instance.currentUser!.uid).child(fileName);
  //
  //     // Upload the file to Firebase Storage
  //     TaskSnapshot taskSnapshot = await reference.putFile(imageFile);
  //
  //     // Get the image URL from the uploaded image
  //     String imageUrl = await taskSnapshot.ref.getDownloadURL();
  //
  //     // Return the image URL
  //     return imageUrl;
  //   } catch (e) {
  //     print('Error uploading image to Firebase: ${e.toString()}');
  //     return null;
  //   }
  // }
  // Future<String?> getCurrentUserProfileImageURL() async {
  //   try {
  //     // Get the current user's ID
  //     String? userId = FirebaseAuth.instance.currentUser?.uid;
  //
  //     if (userId != null) {
  //       // Build the path to the user's profile image in Firebase Storage
  //       // String imagePath = 'images/$userId/'; // Change the file extension as needed
  //
  //       // Get the download URL of the image
  //       Reference reference = FirebaseStorage.instance.ref().child('images').child("${FirebaseAuth.instance.currentUser!.uid}/");
  //       String downloadURL = await reference.getDownloadURL();
  //
  //       return downloadURL;
  //     }
  //   } catch (e) {
  //     print('Error getting current user profile image URL: ${e.toString()}');
  //   }
  //
  //   return null;
  // }

  Future<String?> getCurrentUserProfileImageURL() async {
    try {
      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Build the path to the user's profile image in Firebase Storage
        Reference reference = FirebaseStorage.instance.ref().child('images').child(userId);

        // Get the download URL of the image
        String downloadURL = await reference.getDownloadURL();

        return downloadURL;
      }
    } catch (e) {
      print('Error getting current user profile image URL: ${e.toString()}');
    }

    return null;
  }

  ///Email & Password
      bool showIndicator = false;
  signupEmailAndPassword({emailController, passwordController, context}) async {
    showIndicator == false;
    print("defaultValue $showIndicator");
    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return Center(
      //       child: CircularProgressIndicator(color: mainColor),
      //     );
      //   },
      // );
      if(showIndicator == false){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(color: mainColor),
            );
          },
        );
      }else{}
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );
      User? userSignup = userCredential.user;
      SharedPreferences sf = await SharedPreferences.getInstance();
      await sf.setString(DBkeys.isRegisterMethod, "emailPassword");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailScreen()));


        // });
      // }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        AppToast.show("The email address is already in use. Please sign in or use a different email.");
        Navigator.pop(context); // Display toast message for email already in use
        showIndicator == true;
        notifyListeners();
        print("lastValue aleady $showIndicator");
      }
      else {
        print('Error: ${e.code}');
        showIndicator == true;
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
      showIndicator == true;
      notifyListeners();
    }
    print("lastValue $showIndicator");
    notifyListeners();
  }
  Future loginEmailAndPassword({emailController, passwordController, context}) async {
    try {

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController,
        password: passwordController,
      );
      User? userLogin = userCredential.user;

      if (userLogin != null) {
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) {
             return Center(
               child: CircularProgressIndicator(color: mainColor),
             );
           },
         );
         bool userExists = await checkIfUserExists(userLogin.uid);
       // if(userExists && FirebaseAuth.instance.currentUser!.emailVerified){
       //   // Check if the user already exists
       //   // if (userExists) {
       //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar()), (route) => false);
       //   // }
       // }else {
         Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
       // }
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) {
        //     return Center(
        //       child: CircularProgressIndicator(color: mainColor),
        //     );
        //   },
        // );
        // // Check if the user already exists
        // bool userExists = await checkIfUserExists(userLogin.uid);
        // if (userExists) {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBar()));
        // }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Check if the user has reached the maximum number of failed attempts
          AppToast.show("Wrong password! Please try again."); // Display toast message for wrong password
      }
      else if (e.message?.contains('Access to this account has been temporarily disabled due to many failed login attempts') == true) {
        AppToast.show("Access has been temporarily disabled. Please reset your password."); // Display toast message to reset password
      }
      else if (e.code == 'too-many-requests') {
        AppToast.show("Access to this account has been temporarily disabled due to many failed login attempts. Please try again later or reset your password."); // Display toast message for account temporarily disabled
      }
      else if (e.code == 'user-not-found') {
        AppToast.show("You don't have account. Please create a account."); // Display toast message for account temporarily disabled
      }
      else {
        print('Error: ${e.code}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  ///Facebook
  // void facebookAuth()async{
  //   try{
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //     await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //     ///Create a new Creadential
  //     final credential = FacebookAuthProvider.credential(
  //         loginResult.accessToken!.token
  //     );
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     User? user = userCredential.user;
  //     if(user != null){
  //       print(user);
  //       ///Databse
  //       await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).set(
  //           {
  //             "username": user.displayName.toString(),
  //             // "UID" : user.uid.toString(),
  //             "profilePhoto": user.photoURL.toString(),
  //             "phone": user.phoneNumber.toString(),
  //             "email":user.email.toString(),
  //
  //           });
  //       ///Withdraw Nodes
  //       await database
  //           .child('Withdraw')
  //           .child(FirebaseAuth
  //           .instance.currentUser!.uid)
  //           .set({
  //         "Game_Name": "No Withdraw",
  //         "Reward": "-----",
  //         "Player_ID": "-----",
  //         "Data_and_Time": "-----"
  //       });
  //       ///Spins Nodes
  //       await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).set({
  //         "Current_Coins": 0,
  //       });
  //       Get.offNamed('/home');
  //     }
  //   }on FirebaseAuthException catch(e){
  //     print(e.message!);
  //   }
  // }
  User? _user;

  User? get user => _user;
  String storePhoneNum = "";
  storePhoneNumFun(value){
    storePhoneNum = value;
    notifyListeners();
  }
  bool verificationFailedBool = false;
  verificationFailedFun(value){
    verificationFailedBool = value;
    notifyListeners();
  }
///Phone number
  Future<void> signInWithPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: storePhoneNum,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _user = FirebaseAuth.instance.currentUser;
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        storePhoneNum = verificationId;
        storePhoneNum = verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        storePhoneNum = verificationId;
      },
    );
  }
  ///Logut
  logOutFun({required BuildContext context})async{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    pref.clear();
    // final userUid = FirebaseAuth.instance.uid;
    // if(userUid.isEmpty){
    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
    // }
  }

  ///Delete account fun
  Future<void> deleteGoogleAccountAndData({required BuildContext context}) async {
    showMyWaitingModal(context: context);
    // final QuerySnapshot userDocs = await FirebaseFirestore.instance
    //     .collection('users')
    //     .where('uid', isEqualTo: _user?.uid)
    //     .get();
    //
    // if (userDocs.docs.isEmpty) {
    // Delete user data from Firestore
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();

    // }

    // Delete Firebase Authentication account
    await FirebaseAuth.instance.currentUser!.delete();
    // Google
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    final sf = await SharedPreferences.getInstance();
    await sf.remove("userUid");
    await sf.clear();
    AppToast.show("Your account has been deleted successfully");

    print('Account and data deleted successfully');
  }
  Future<void> deleteAccountAndData({required BuildContext context}) async {
    try {
      showMyWaitingModal(context: context);

      // Get the current user
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete user data from Firestore
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).delete();

        // Delete Firebase Authentication account
        await currentUser.delete();

        // Google Sign Out
        await GoogleSignIn().signOut();

        // Firebase Sign Out
        await FirebaseAuth.instance.signOut();

        // Clear preferences
        pref.clear();

        // Display success message
        AppToast.show("Your account has been deleted successfully");

        // Navigate to SplashScreen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
      } else {
        // Handle the case where the current user is null
        AppToast.show("User not found");
      }
    } catch (e) {
      // Handle errors
      print('Error deleting account and data: $e');
      AppToast.show("An error occurred while deleting your account");
    }
  }


  forgotPassword({context,required TextEditingController emailController}) async {
    showMyWaitingModal(context: context);
    try{
      // checkIfUserExists(userLogin.uid);
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
     AppToast.show("Password reset send in your email.");
     Navigator.pop(context);
     Navigator.pop(context);
    }catch(e){
      AppToast.show(e.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('object ${userCredential.user!.emailVerified}');
      // final Shared = await SharedPreferences.getInstance();
      // Shared.setString('email', email.toLowerCase());
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // Shared.pref.setString('email', email.toLowerCase());
      print(userCredential.user!.uid);
      // isUserLoggedIn = true;
      if (userCredential.user!.emailVerified != false) {
        // await firestore
        //     .collection(Dbpath.User)
        //     .doc(email)
        //     .update({'isEmailVerified': true});
        // isVerified = true;
      } else {
        await userCredential.user!.sendEmailVerification();
        // userLoginMessage = 'Email not verified';
        AppToast.show("shortMessage");
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {

    }
  }
  
}

Future<bool> checkIfUserExists(String uid) async {

  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    // final sf = await SharedPreferences.getInstance();
    // sf.setString("userUid", uid );
    // sf.setBool(SplashScreen.isCheckLogged, true);
    return documentSnapshot.exists;
  } catch (e) {
    // Handle any potential errors here
    print(e.toString());
    return false;
  }
}
