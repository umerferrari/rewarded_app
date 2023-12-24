import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AuthScreens/authScreen.dart';
import 'HomeScreen.dart';
import 'SpinWheel.dart';
import 'screens/phoneAuthScreen.dart';
import 'signUpForm.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class logInFormSTL extends StatelessWidget {
  const logInFormSTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: logInFormSTF(),
        backgroundColor: Colors.black38,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
///stf
class logInFormSTF extends StatefulWidget {
  const logInFormSTF({Key? key}) : super(key: key);

  @override
  State<logInFormSTF> createState() => _logInFormSTFState();
}

class _logInFormSTFState extends State<logInFormSTF> {
  ///Storage Secure
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus()async{
    String? value = await storage.read(key: "uid");
    if(value == null ){
      return false;
    }
    return true;
  }
  ///Permission
  void Permissions()async{
    if ( await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
    }
    if(await Permission.location.serviceStatus.isDisabled){

      await Permission.locationAlways.serviceStatus.isEnabled;
    }
    ///Permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

///
  bool? _checkBoxValue = false ;

  late double width;
  late double height;
  bool isChecked = false;
///controller
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    Permissions();
    // FacebookAudienceNetwork.init();
    // UnityAds.init(
    //   gameId: AdManager.gameId,
    //   onComplete: () {
    //     print('Initialization Complete');
    //   },
    //   onFailed: (error, message) => print('Initialization Failed: $error $message'),
    // );

  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      child: SafeArea(
        child:hideUi? Container(
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
              ),
            ],
          ),
        ) : Container(
          margin: EdgeInsets.only(top: height*0.15, left: width*0.07, right:width*0.07 ),
          child: Column(
              children: [
                ///Text
                Container(
                  child: Text('Welcome back,',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                ),
                ///Facebook
                Container(
                  margin: EdgeInsets.only(top: height*0.08),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(width*0.035),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width*0.02)
                        )
                    ),
                    onPressed: (){
                      // context.read<FirebaseAuthMethods>().signInWithFacebook(context);\\
                      FirebaseAuthMethods(FirebaseAuth.instance).facebookAuth();
                    },
                    child: Container(
                      // padding: EdgeInsets.all(width*0.035),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Icon
                          Icon(Icons.facebook,color: Colors.white,),
                          ///Text
                          Container(
                            margin: EdgeInsets.only(left: width*0.2,top: height*0.005),
                            child: Text("Continue with Facebook",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ///google
                Container(
                  margin: EdgeInsets.only(top: height*0.04),
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(width*0.035),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width*0.02),
                        ),
                        elevation: 3
                    ),
                    onPressed: (){
                      FirebaseAuthMethods(FirebaseAuth.instance).googleSignIn();
                      // context.read<FirebaseAuthMethods>().signInWithGoogle(context);

                    },
                    child: Container(
                      // padding: EdgeInsets.all(width*0.035),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Icon
                          Container(
                            width: width*0.06,
                            child: Image.asset("assets/images/google_Icon.png"),
                          ),
                          ///Text
                          Container(
                            margin: EdgeInsets.only(left: width*0.2,top: height*0.005),
                            child: Text("Continue with Google",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ///TErms & Conditions
                Container(
                  margin: EdgeInsets.only(top: height*0.02),
                  child: Row(
                    children: [
                      ///Text
                      Text("By signing up you agree to our ",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                        ),),
                      InkWell(
                        onTap: (){
                          launchUrl( Uri.parse("https://securedoorstudio.blogspot.com/2022/10/terms-conditions.html"), mode: LaunchMode.inAppWebView );

                        },
                        child: Text("Terms and Conditions ",
                          style: TextStyle(
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                    ],
                  ),
                ),
                ///Privacy Policy
                Container(
                  margin: EdgeInsets.only(top: height*0.01),
                  child: Row(
                    children: [
                      Text("and ",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                        ),),
                      InkWell(
                        onTap: (){
                          launchUrl( Uri.parse("https://securedoorstudio.blogspot.com/2022/10/privacy-policy.html"), mode: LaunchMode.inAppWebView );

                        },
                        child: Text("Privacy Policy",
                          style: TextStyle(
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ]
          ),
        )
      ),
    );
  }
}
