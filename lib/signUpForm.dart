import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'AuthScreens/authScreen.dart';
import 'HomeScreen.dart';
class phoneAuthData extends StatelessWidget {
  const phoneAuthData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: phoneAuthDataSTF(),
        backgroundColor: Colors.black38,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

///stf
class phoneAuthDataSTF extends StatefulWidget {
  const phoneAuthDataSTF({Key? key}) : super(key: key);

  @override
  State<phoneAuthDataSTF> createState() => _phoneAuthDataSTFState();
}

class _phoneAuthDataSTFState extends State<phoneAuthDataSTF> {
  late double width;
  late double height;
  bool isChecked = false;
  File? Getimage;

  Future<dynamic> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(() {
        Getimage = imageTemporary;
      });
    } catch (e) {
      print(e);
    }
  }

  ///google map geolocator
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  //   required;
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }

  ///Controllers
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  ///firebase facebook
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SpinWheel;
    ///Wifi Connectivity
    _connectivity.onConnectivityChanged.listen((event) {
      if(event == ConnectivityResult.none){
        setState(() {
          hideUi = true;
        });
      }else{
        setState(() {
          hideUi = false;
        });
      }
    });
  }

  DatabaseReference database = FirebaseDatabase.instance.ref();
  void _SpinWheel()async{
    ///Spins Nodes
    await database
        .child('Spins')
        .child(FirebaseAuth
        .instance.currentUser!.uid)
        .set({
      "Current_Coins": 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return hideUi? Container(
      margin: EdgeInsets.only(top: height*0.3),
      alignment: Alignment.center,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          ///Icon
          Icon(Icons.wifi_off, color: Colors.yellow.shade700,size: 160,),
          ///Size Box
          Container(
            child: SizedBox(
              height: height*0.01,
            ),
          ),
          ///Text
          Container(
            child: Text("No Internet Connection",style: TextStyle(
                color: Colors.white,
                fontFamily: 'poppins',
                fontSize: 25,
                fontWeight: FontWeight.w600
            ),),
          )
        ],
      ),
    ) : Container(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              top: height * 0.15, left: width * 0.07, right: width * 0.07),
          child: Stack(children: [
            ///Text
            Container(
              child: Text(
                'Enter All Data With Image,',
                style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),

            ///Border
            Container(
              margin: EdgeInsets.only(top: height * 0.15),
              height: height * 0.515,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.yellow.shade700),
                  borderRadius: BorderRadius.circular(width * 0.08)),
            ),

            ///Circle Avaster
            Container(
              width: width * 0.34,
              height: height * 0.15,
              margin: EdgeInsets.only(top: height * 0.07, left: width * 0.28),
              child: InkWell(
                onTap: () {
                  pickImage();
                  // required;
                },
                child: Container(
                  child: Stack(
                    children: [
                      ///Image
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(width),
                            child: Getimage != null
                                ? Image.file(
                                    Getimage!,
                                  )
                                : Container(
                                    color: Colors.yellow.shade700,
                                    child: Image.asset(
                                      "assets/images/user.png",fit: BoxFit.cover,
                                    ))),
                      ),

                      ///Icon
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.21, top: height * 0.1),
                        // color: Colors.blue.shade700,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            ///inner border
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.06),

              // height: height*,
              // margin: EdgeInsets.only(top: height*0.2),
              child: Column(
                children: [
                  ///Name and username
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///Name field
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.31,
                                margin: EdgeInsets.only(top: height * 0.22),
                                child: TextFormField(
                                  controller: name,
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.yellow.shade700,

                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    labelStyle: TextStyle(
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    hintText: 'Secure Door',
                                    hintStyle: TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.002,
                                width: width * 0.31,
                                color: Colors.yellow.shade700,
                              ),
                            ],
                          ),
                        ),

                        ///username field
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.31,
                                margin: EdgeInsets.only(top: height * 0.22),
                                child: TextFormField(
                                  controller: username,
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.yellow.shade700,

                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    labelStyle: TextStyle(
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    hintText: 'secure_door',
                                    hintStyle: TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.002,
                                width: width * 0.31,
                                color: Colors.yellow.shade700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Email and phone
                  Container(
                    // margin: EdgeInsets.only(top:  height*0.25),
                    child: TextFormField(
                      autofocus: false,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.yellow.shade700,

                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        labelStyle: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.grey.shade400),
                        border: InputBorder.none,
                        hintText: 'securedoorstudio@gmail.com',
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.002,
                    width: width,
                    color: Colors.yellow.shade700,
                  ),

                  ///Password TextField
                  Container(
                    // margin: EdgeInsets.only(top:  height*0.25),
                    child: TextFormField(
                      autofocus: false,
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.yellow.shade700,

                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: "Enter Your Password",
                        labelStyle: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.grey.shade400),
                        border: InputBorder.none,
                        hintText: '*******',
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.002,
                    width: width,
                    color: Colors.yellow.shade700,
                  ),

                  ///Button
                  Container(
                    margin: EdgeInsets.only(top: height*0.06),
                    width: width * 0.7,
                    height: height * 0.058,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(width * 0.08)),
                      ),
                      onPressed: () async {
                        // register();
                        if (
                            validateField(password.text).isEmpty

                        )
                        {
                          Get.snackbar(
                            "SignUp Error",
                            "Please Enter All Fields Data With Image correctly. Thank You",
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                            duration: Duration(seconds: 9),
                          );

                        } else {
                          final user = await FirebaseAuth.instance.currentUser!.uid;
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
                          ///USer All Info without Image Path
                          await database
                              .child('Users')
                              .child(user)
                              .set({
                            "username": username.text,
                            "phone": phone.text,
                            "email": email.text,
                            "password": password.text,
                            "name": name.text,
                          });
                          // AuthController.instance.DataSent;
                          Get.toNamed('/home');
                          ///Firebase Storage
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child("Users_Profiles_Pick")
                              .child(user.toString());
                          // await ref.putFile(Getimage!);
                          UploadTask uploadTask =
                          ref.putFile(Getimage!);
                          TaskSnapshot Imagesnapshot =
                          await uploadTask;
                          String imageDownUrl = await Imagesnapshot
                              .ref
                              .getDownloadURL();
                          await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).update(
                              {
                                "profilePhoto": imageDownUrl.toString(),
                              });

                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'poppins',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  ///Ads
                  Container(
                    margin: EdgeInsets.only(top: height*0.15),
                    child: FacebookBannerAd(
                      placementId: "781313709744134_781317063077132",
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(left: width*0.25),
                  //   child: Row(
                  //     children: [
                  //       ///Google
                  //       Container(
                  //         margin: EdgeInsets.only(top: height*0.1),
                  //         padding: EdgeInsets.all(height*0.018),
                  //         height: height*0.07,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(width*0.1),
                  //             border: Border.all(color: Colors.grey.shade700)
                  //         ),
                  //         child: InkWell(
                  //           onTap: (){
                  //             FirebaseAuthMethods(FirebaseAuth.instance).googleSignIn();
                  //
                  //           },
                  //           child: Image.asset('assets/images/google-glass-logo.png',
                  //             color: Colors.white,
                  //             height: height*0.02,
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       ///Facebook
                  //       Container(
                  //         margin: EdgeInsets.only(top: height*0.1,left: width*0.06),
                  //         padding: EdgeInsets.all(height*0.018),
                  //         height: height*0.07,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(width*0.1),
                  //             border: Border.all(color: Colors.grey.shade700)
                  //         ),
                  //         child: InkWell(
                  //           onTap: (){
                  //             FirebaseAuthMethods(FirebaseAuth.instance).facebookAuth();
                  //           },
                  //           child: Image.asset('assets/images/facebook.png',
                  //             color: Colors.white,
                  //             height: height*0.02,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
}
