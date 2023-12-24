import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_and_earn/AuthScreens/terms_conditions.dart';
import '../../Provider/auth_provider.dart';
import '../../Provider/image_picker.dart';
import '../Widgets/toast.dart';
import '../components/DB_keys.dart';
import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../main.dart';
import '../widgets/button.dart';
import '../widgets/dialog_box.dart';

class SignUpProfileInfo extends StatefulWidget {
  const SignUpProfileInfo(
      {Key? key, this.googleAuthImageUrl, this.googleAuthUserName})
      : super(key: key);
  final String? googleAuthImageUrl;
  final String? googleAuthUserName;
  @override
  State<SignUpProfileInfo> createState() => _SignUpProfileInfoState();
}

class _SignUpProfileInfoState extends State<SignUpProfileInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  final _bio = TextEditingController();
  late StreamSubscription<DocumentSnapshot> _streamSubscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // pref.remove(SplashScreen.isCheckLogged);
    // _streamSubscription = checkVerifiedUserStreamFun().listen((event) {
    //   // Handle stream events here
    // });
    if(widget.googleAuthUserName != null){

    String name = widget.googleAuthUserName!;
    _name = TextEditingController(text: name);
    }else{
      // String name = "";
      _name = TextEditingController(text: "");
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ImagePickerProvider>(context, listen: false);
      provider.getImageSignUp = null;
      // pref.remove(SplashScreen.isCheckLogged);
    });
  }

  String? nameValidation(String? value) {
    if (value!.isEmpty) {
      return "Please enter a name";
    }
    return null;
  }

  String? bioValidation(String? value) {
    if (value!.isEmpty) {
      return "Please enter a bio";
    }
    return null;
  }
  String selectedValue = "Male";

  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return Consumer2<ImagePickerProvider, AuthenProvider>(
      builder: (context, provider, authProvider, child) {
        return SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                // backgroundColor: whiteColor,
                body: Form(
                    key: _formKey,
                    child: Container(
                      alignment: Alignment.center,
                      padding: kPaddingHorizontal20,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spacer,
                          Text(
                            "Profile Info",
                            style: txtStyle18AndMainBold,
                          ),
                          sizeHeight10,
                          Text(
                            "Please provide your name and an optional profile photo",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: txtStyle12AndOther,
                          ),
                          sizeHeight40,
                          GestureDetector(
                            onTap: () {
                              customDialog(
                                context: context,
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Choose you want",
                                      style: txtStyle12AndBold,
                                    ),
                                    sizeHeight40,
                                    // spacer,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          SizedBox.shrink(),
                                          // SizedBox.shrink(),
                                          ///Camera
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                mainColor,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    provider.pickCameraImageSignUp();
                                                  },
                                                  icon: Icon(
                                                      Icons.camera,
                                                      color:
                                                      textColor),
                                                ),
                                              ),
                                              sizeHeight15,
                                              Text(
                                                "Camera",
                                                style:
                                                txtStyle14AndBold,
                                              ),
                                            ],
                                          ),
                                          SizedBox.shrink(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                mainColor,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    provider.pickImage();
                                                  },
                                                  icon: Icon(
                                                      Icons.photo,
                                                      color:
                                                      textColor)
                                                ),
                                              ),
                                              sizeHeight15,
                                              Text(
                                                "Gallery",
                                                style:
                                                txtStyle14AndBold,
                                              ),
                                            ],
                                          ),
                                          SizedBox.shrink(),
                                          // SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(scrSize.width),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: grey400Color,
                                // backgroundImage:  FileImage(provider.getImageSignUp!.path.isEmpty?  : provider.getImageSignUp!),
                                child: provider.getImageSignUp != null
                                    ? Image.file(
                                        provider.getImageSignUp!,
                                        fit: BoxFit.cover,
                                        height: scrSize.height,
                                        width: scrSize.width,
                                      )
                                    :
                                    // widget.googleAuthImageUrl!.isNotEmpty?
                                    //     Image.network(widget.googleAuthImageUrl!)
                                    //     :
                                    Icon(Icons.camera_alt,
                                        color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                          sizeHeight30,
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Name",
                                style: txtStyle12AndBold,
                              )),
                          sizeHeight10,
                          // textField(hintText: "finjineers@gmail.com", controller: email),
                          TextFormField(
                            controller: _name,
                            validator: nameValidation,
                            cursorColor: mainColor,
                            style: txtStyle14,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              hintText: "Enter your name",
                              hintStyle: txtStyle12AndOther,
                              border: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide: BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide:  BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide: BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              // suffixIcon: suffixIcon?? Container(),
                            ),
                          ),
                          sizeHeight15,
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Bio",
                                style: txtStyle12AndBold,
                              )),
                          sizeHeight10,
                          TextFormField(
                            controller: _bio,
                            style: txtStyle14,

                            validator: bioValidation,
                            cursorColor: mainColor,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              hintText: "Enter your bio",
                              hintStyle: txtStyle12AndOther,
                              border: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide: BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide: BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide: BorderSide(
                                    color: otherColor, width: 0.2),
                              ),
                              // suffixIcon: suffixIcon?? Container(),
                            ),
                          ),
                          sizeHeight15,
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Gender",
                                style: txtStyle12AndBold,
                              )),
                          sizeHeight10,
                          DropdownButtonHideUnderline(
                            child: SizedBox(
                              width: scrSize.width,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius10,
                                  border: Border.all(
                                      color: otherColor,
                                      width: 0.2
                                  ),
                                ),
                                padding: kPaddingHorizontal20,
                                child: DropdownButton<String>(
                                  value: selectedValue,
                                  dropdownColor: blackOtherColor,
                                  iconEnabledColor: mainColor,
                                  hint: Text("Select Gender"),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                      print(selectedValue);
                                    });
                                  },
                                  items: <String>[
                                    'Male',
                                    'Female',
                                    'Other',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(

                                      value: value,
                                      child: Text(value,style: txtStyle14,),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                          sizeHeight30,
                          button(
                              context: context,
                              btnText: "Continue",
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  String name = _name.text;
                                  String bio = _bio.text;
                                  // // showMyWaitingModal(context: context);
                                  // showDialog(
                                  //   context: context,
                                  //   barrierDismissible: false,
                                  //   builder: (_) {
                                  //     return Center(
                                  //       child: CircularProgressIndicator(color: mainColor),
                                  //     );
                                  //   },
                                  // );
                                  // final FirebaseStorage _storage =
                                  //     FirebaseStorage.instance;
                                  //
                                  // try {
                                  //   if (provider.getImageSignUp != null) {
                                  //     // Generate a unique file name for the image
                                  //     String fileName = DateTime.now()
                                  //             .millisecondsSinceEpoch
                                  //             .toString() +
                                  //         '.png';
                                  //
                                  //     // Get the storage reference
                                  //     Reference reference = _storage
                                  //         .ref()
                                  //         .child('users_images')
                                  //         .child(FirebaseAuth
                                  //             .instance.currentUser!.uid)
                                  //         .child(fileName);
                                  //
                                  //     // final imagePath = provider.getImageSignUp != null? provider.getImageSignUp! : NetworkImage(widget.googleAuthImageUrl!);
                                  //     // Upload the file to Firebase Storage
                                  //     TaskSnapshot taskSnapshot =
                                  //         await reference.putFile(
                                  //             provider.getImageSignUp!);
                                  //
                                  //     // Get the image URL from the uploaded image
                                  //     String imageUrl = await taskSnapshot.ref
                                  //         .getDownloadURL();
                                  //     if (imageUrl.isNotEmpty) {
                                  //       String? token = await FirebaseMessaging.instance.getToken();
                                  //
                                  //       // Image uploaded successfully, update Firestore with the image URL
                                  //       if(pref.getString(DBkeys.isRegisterMethod) == "number"){
                                  //         await FirebaseFirestore.instance
                                  //             .collection("users")
                                  //             .doc(FirebaseAuth
                                  //             .instance.currentUser!.uid)
                                  //             .update({
                                  //           DBkeys.userName: _name.text,
                                  //           DBkeys.userBio: _bio.text,
                                  //           DBkeys.userPhoto: imageUrl,
                                  //           DBkeys.userGender: selectedValue,
                                  //         }).then((value) {
                                  //           Navigator.pop(context);
                                  //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TermsConditionsSignup()), (route) => false);
                                  //         });
                                  //       }else if(pref.getString(DBkeys.isRegisterMethod) == "google"){
                                  //         await FirebaseFirestore.instance
                                  //             .collection("users")
                                  //             .doc(FirebaseAuth
                                  //             .instance.currentUser!.uid)
                                  //             .update({
                                  //           DBkeys.userName: _name.text,
                                  //           DBkeys.userBio: _bio.text,
                                  //           DBkeys.userPhoto: imageUrl,
                                  //           DBkeys.userGender: selectedValue,
                                  //         }).then((value) {
                                  //           pref.setString(DBkeys.isRegisterMethod, "google");
                                  //           pref.setString("userUid", FirebaseAuth
                                  //               .instance.currentUser!.uid);
                                  //           // pref.setBool(SplashScreen.isCheckLogged, true);
                                  //           Navigator.pop(context);
                                  //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TermsConditionsSignup()), (route) => false);
                                  //         });
                                  //       }
                                  //       else {
                                  //         await FirebaseFirestore.instance
                                  //             .collection("users")
                                  //             .doc(FirebaseAuth
                                  //             .instance.currentUser!.uid)
                                  //             .set({
                                  //           DBkeys.userGroups : [],
                                  //           DBkeys.userMuteGroup : [],
                                  //           "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                                  //           "phone_number": FirebaseAuth.instance.currentUser!.phoneNumber ?? "",
                                  //           "email": FirebaseAuth.instance.currentUser!.email ,
                                  //           // "password": passwordController,
                                  //           DBkeys.token: token,
                                  //           DBkeys.isRegisterMethod: "emailpassword",
                                  //           DBkeys.createdAt: DateTime.now().millisecond.toString(),
                                  //           DBkeys.userName: _name.text,
                                  //           DBkeys.userBio: _bio.text,
                                  //           DBkeys.userPhoto: imageUrl,
                                  //           DBkeys.userGender: selectedValue,
                                  //         }).whenComplete(() async {
                                  //           await _streamSubscription.cancel().whenComplete(() {
                                  //           pref.setString("userUid", FirebaseAuth.instance.currentUser!.uid.toString() );
                                  //           // pref.setBool(SplashScreen.isCheckLogged, true);
                                  //           // Navigator.pop(NavKey.navKey.currentState!.context);
                                  //           // Navigator.pushAndRemoveUntil(NavKey.navKey.currentState!.context, MaterialPageRoute(builder: (_) => const TermsConditionsSignup()), (route) => false);
                                  //           });
                                  //         });
                                  //       }
                                  //     }
                                  //     print("With Image Select");
                                  //   } else {
                                  //     print("withOut Image Select");
                                  //     String? token = await FirebaseMessaging.instance.getToken();
                                  //     if(pref.getString(DBkeys.isRegisterMethod) == "number"){
                                  //       await FirebaseFirestore.instance
                                  //           .collection("users")
                                  //           .doc(FirebaseAuth
                                  //           .instance.currentUser!.uid)
                                  //           .update({
                                  //         DBkeys.userName: _name.text,
                                  //         DBkeys.userBio: _bio.text,
                                  //         DBkeys.userPhoto: "",
                                  //         DBkeys.userGender: selectedValue,
                                  //       }).then((value) async {
                                  //        await _streamSubscription.cancel();
                                  //         Navigator.pop(context);
                                  //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TermsConditionsSignup()), (route) => false);
                                  //       });
                                  //     }
                                  //     else if(pref.getString(DBkeys.isRegisterMethod) == "google"){
                                  //       await FirebaseFirestore.instance
                                  //           .collection("users")
                                  //           .doc(FirebaseAuth
                                  //           .instance.currentUser!.uid)
                                  //           .update({
                                  //         DBkeys.userName: _name.text,
                                  //         DBkeys.userBio: _bio.text,
                                  //         DBkeys.userPhoto: "",
                                  //         DBkeys.userGender: selectedValue,
                                  //       }).then((value) {
                                  //         pref.setString(DBkeys.isRegisterMethod, "google");
                                  //         pref.setString("userUid", FirebaseAuth
                                  //             .instance.currentUser!.uid );
                                  //         // pref.setBool(SplashScreen.isCheckLogged, true);
                                  //         Navigator.pop(context);
                                  //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TermsConditionsSignup()), (route) => false);
                                  //       });
                                  //     }
                                  //     else{
                                  //       await FirebaseFirestore.instance
                                  //           .collection("users")
                                  //           .doc(FirebaseAuth
                                  //           .instance.currentUser!.uid)
                                  //           .set({
                                  //         DBkeys.userName: _name.text,
                                  //         DBkeys.userGender: selectedValue,
                                  //         DBkeys.userBio: _bio.text,
                                  //         "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                                  //         DBkeys.token: token,
                                  //         DBkeys.userGroups : [],
                                  //         DBkeys.userPhoto: "",
                                  //         "phone_number": FirebaseAuth.instance.currentUser!.phoneNumber ?? "",
                                  //         DBkeys.userMuteGroup : [],
                                  //         "email": FirebaseAuth.instance.currentUser!.email ,
                                  //         DBkeys.isRegisterMethod: "emailpassword",
                                  //         DBkeys.createdAt: DateTime.now().millisecond.toString(),
                                  //       }).whenComplete(() async {
                                  //         await _streamSubscription.cancel().whenComplete(() {
                                  //         pref.setString("userUid", FirebaseAuth.instance.currentUser!.uid.toString() );
                                  //         // pref.setBool(SplashScreen.isCheckLogged, true);
                                  //         // Navigator.pop(NavKey.navKey.currentState!.context);
                                  //         // Navigator.pushAndRemoveUntil(NavKey.navKey.currentState!.context, MaterialPageRoute(builder: (_) => const TermsConditionsSignup()), (route) => false);
                                  //         });
                                  //       });
                                  //     }
                                  //   }
                                  // } catch (e) {
                                  //   print(
                                  //       'Error uploading image to Firebase: ${e.toString()}');
                                  // }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsSignup()));

                                } else {
                                  AppToast.show("Please Fill All Data");
                                }
                              },
                              btnTextColor: textColor),
                          spacer,
                        ],
                      ),
                    ))));
      },
    );
  }
}





