import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'HomeScreen.dart';
import 'SpinWheel.dart';
class historySTL extends StatelessWidget {
  const historySTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: historySTF(),
      ),
    );
  }
}
///STF
class historySTF extends StatefulWidget {
  const historySTF({Key? key}) : super(key: key);

  @override
  State<historySTF> createState() => _historySTFState();
}

class _historySTFState extends State<historySTF> {
  late double width;
  late double height;
  ///Firebase DataBase
  final database = FirebaseDatabase.instance.ref();
  late DataSnapshot snapshot;
  String gName = '';
  String uReward = '';
  String playerID = '' ;
  String dTime = '';
  void readData() async {
    snapshot = await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).get();
    Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;

    if(snapshot.exists){
      print(snapshot.value);
     setState(() {
       gName = map['Game_Name'];
       uReward = map['Reward'];
       playerID = map['Player_ID'];
       dTime = map['Data_and_Time'];

     });
    }else{
      print("Not Exists");
    }

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
    Permissions();
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
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      child: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                ///First Section
                Container(
                  margin: EdgeInsets.only(left: width*0.06,top: height*0.02),
                  child: Row(
                    children: [
                      ///Back Icon
                      Container(
                  child: InkWell(
                  child: Icon(Icons.arrow_back,
                      color: Colors.yellow.shade700),
                    onTap: ()async{
                    await FacebookRewardedVideoAd.showRewardedVideoAd();
                    Get.offNamed('/home/DashBoard');

                    await UnityAds.showVideoAd(placementId: "Video_Android");
                    },
                      ),),
                      ///Text
                      Container(
                        margin: EdgeInsets.only(left: width*0.27),
                          child: RichText(
                            text: TextSpan(text: "His",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                                fontSize: 30
                            ),
                              children: [
                                TextSpan(
                                  text: "t",
                                  style: TextStyle(
                                    color: Colors.yellow.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'poppins',
                                    fontSize: 30
                                  ),

                                ),
                                TextSpan(
                                  text: "ory",
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'poppins',fontWeight: FontWeight.w600,fontSize: 30)
                                )
                              ]
                            ),
                          ),

                        ),

                      ]),
                      ),
                ///Text
                Container(
                  margin: EdgeInsets.only(top: height*0.1,left: width*0.08),
                  child: Row(
                     children: [
                       ///Icon
                       Icon(Icons.wallet, color: Colors.yellow.shade700,),
                       ///Text
                       Container(
                         child: Text("  Last ", style: TextStyle(
                           color: Colors.white,
                           fontSize: 25,
                           fontWeight: FontWeight.w600,
                           fontFamily: 'poppins'
                         ),),
                       ),
                       ///Text2
                       Container(
                         child: Text(" WithDraw", style: TextStyle(
                             color: Colors.yellow.shade700,
                             fontSize: 25,
                             fontWeight: FontWeight.w600,
                             fontFamily: 'poppins'
                         ),),
                       ),
                     ],
                  ),
                ),
                ///read Firebase Withdraw Data
                Container(
                  margin: EdgeInsets.only(top: height*0.17, left: width*0.08),
                  height: height*0.7,
                  child: Column(
                    children: [
                      ///First Row
                      Container(
                        child: Row(
                          children: [
                            ///Text
                            Text("Player ID :  ", style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),
                            ///Text2
                            Text(playerID, style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),

                          ],
                        ),
                      ),
                      ///2nd
                      Container(
                        child: Row(
                          children: [
                            ///Text
                            Text("Game Name :  ", style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),
                            ///Text2
                            Text(gName, style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),

                          ],
                        ),
                      ),
                      ///2nd Row
                      Container(
                        child: Row(
                          children: [
                            ///Text
                            Text("Reward :  ", style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),
                            ///Text2
                            Text(uReward, style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),

                          ],
                        ),
                      ),
                      ///2nd
                      Container(
                        child: Row(
                          children: [
                            ///Text
                            Text("Date and Time  :  ", style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 18,fontWeight: FontWeight.w600,),),
                            ///Text2
                            Text(dTime, style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontSize: 14.4,fontWeight: FontWeight.w600,),),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ///Ads
                Container(
                  margin: EdgeInsets.only(top: height*0.92),
                  child: FacebookBannerAd(
                    placementId: "781313709744134_781317063077132",
                  ),
                )
                    ],
                  ),
          ),
              ),

          ),
        );
  }

  ///Back button with ads
  Widget _getElevatedButton({icon, void Function()? onPressed}) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Icon(
          Icons.arrow_back,
          color: Colors.yellow.shade700,
          size: 35,
        ),
      ),
    );
  }

  ///initial ads
  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
      Get.off(HomeScreenSTL());
    } else {
      print("Interstial Ad not yet loaded!");
      Get.off(HomeScreenSTL());

    }
  }
  ///Rewarded ads
  _showRewardedAd() {
    if (_isRewardedAdLoaded == true){
      FacebookRewardedVideoAd.showRewardedVideoAd();
      _showAd;
      _showInterstitialAd();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));

    }
    else {
      print("Rewarded Ad not yet loaded!");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));

    }}
  ///Unity 3.07 update

  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');

      },
      onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
    );
  }

  void _showAd(String placementId) {
    UnityAds.showVideoAd(
      placementId: 'Video_Android',
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);

      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
      },
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
      },
    );
  }
}
