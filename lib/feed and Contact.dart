import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'HomeScreen.dart';
import 'SpinWheel.dart';

class feedAndContact extends StatelessWidget {
  const feedAndContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: feedAndContactSTF(),
      ),
    );
  }
}

///stf
class feedAndContactSTF extends StatefulWidget {
  const feedAndContactSTF({Key? key}) : super(key: key);

  @override
  State<feedAndContactSTF> createState() => _feedAndContactSTFState();
}

class _feedAndContactSTFState extends State<feedAndContactSTF> {
  late double width;
  late double height;
  ///google map geolocator
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
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
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }
  ///Firebase Data Sent Controller
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  final databasae = FirebaseDatabase.instance.ref();
  final fcDatabase = FirebaseFirestore.instance.collection('Contact_Us');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///Unity Ads
    UnityAds.init(
      gameId: AdManager.gameId,
      onComplete: () {
        print('Initialization Complete');
      },
      onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );

    ///Facebook ads init
    /// please add your own device testingId
    /// (testingId will print in console if you don't provide  )
    FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,
    );
    _loadInterstitialAd();
    Permissions();
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
  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  ///Initial
  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "781313709744134_781317253077113",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      child: SafeArea(
        child: Container(
          child: Stack(
            children: [
              ///Fisrt Section
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.1, vertical: height * 0.02),
                child: Row(
                  children: [
                    ///Back Button
                    Container(
                      child: InkWell(
                        child: Icon(Icons.arrow_back,
                            color: Colors.yellow.shade700),
                        onTap: ()async{
                          await FacebookRewardedVideoAd.showRewardedVideoAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));

                          await UnityAds.showVideoAd(placementId: "Video_Android");
                        },
                      ),
                    ),

                    ///Main Text
                    Container(
                      margin: EdgeInsets.only(left: width * 0.16),
                      child: RichText(
                        text: TextSpan(
                          text: "Contact ",
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(
                              text: "Us",
                              style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow.shade700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///Name Field
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.2, horizontal: width * 0.1),
                child: TextField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.yellow.shade700,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'poppins', fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500),
                      hintText: "Enter Name",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),

              ///Line
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.27, horizontal: width * 0.1),
                width: width * 0.8,
                height: height * 0.002,
                color: Colors.yellow.shade700,
              ),

              ///Email Field
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.28, horizontal: width * 0.1),
                child: TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.yellow.shade700,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'poppins', fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500),
                      hintText: "Enter Email",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),

              ///Line
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.35, horizontal: width * 0.1),
                width: width * 0.7,
                height: height * 0.002,
                color: Colors.yellow.shade700,
              ),

              ///Number Field
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.36, horizontal: width * 0.1),
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.yellow.shade700,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'poppins', fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500),
                      hintText: "Enter Number",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),

              ///Line
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.43, horizontal: width * 0.1),
                width: width * 0.6,
                height: height * 0.002,
                color: Colors.yellow.shade700,
              ),

              ///Border
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.474, left: width * 0.1, right: width * 0.1),
                height: height * 0.28,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow.shade700,
                    ),
                    borderRadius: BorderRadius.circular(width * 0.06)),
              ),

              ///Description Field
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.48,
                    left: width * 0.14,
                    right: width * 0.14),
                child: TextField(
                  controller: description,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.yellow.shade700,
                  maxLines: 7,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'poppins', fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500),
                      hintText: "Enter Descriptions",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),

              ///Submit
              Container(
                margin:
                EdgeInsets.only(top: height * 0.72, left: width * 0.355),
                child: GestureDetector(
                  onTap: () async{
                    ///FireStore
                    await fcDatabase.doc(FirebaseAuth.instance.currentUser!.uid).set(
                        {
                          "Name" : name.text,
                          "Email": email.text,
                          "Phone_Number": phone.text,
                          "Description" : description.text,
                        });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Your Request Have Been Submit SuccessFully. Owner Contact Your  "+email.text+"  With in 24 Hours. Thank You"),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.06,
                    width: width * 0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                      border: Border.all(color: Colors.yellow.shade700),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
