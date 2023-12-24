
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:get/get.dart';
import '../HomeScreen.dart';
import '../SpinWheel.dart';
import '../utils/game.dart';
import '../widgets/button.dart';
import 'results_screen.dart';

class RockMainScreenSTL extends StatelessWidget {
  const RockMainScreenSTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RockMainScreenSTF(),
    );
  }
}


class RockMainScreenSTF extends StatefulWidget {
  const RockMainScreenSTF({Key? key}) : super(key: key);

  @override
  _RockMainScreenSTFState createState() => _RockMainScreenSTFState();
}

class _RockMainScreenSTFState extends State<RockMainScreenSTF> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  late double width;
  late double height;

  late int DBcoins = 0;
  ///firebase
  late DataSnapshot snapshot;
  final database = FirebaseDatabase.instance.ref();

  void readData()async{
    snapshot = await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
    if(snapshot.exists){
      print(snapshot.value);
      Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
      setState(() {
        DBcoins = map['Current_Coins'];
      });
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
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }
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
  ///banner
  _showBannerAd(){
    setState(() {
      FacebookBannerAd(
        // placementId: "YOUR_PLACEMENT_ID",
        placementId:
        "781313709744134_781317063077132", //testid

        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
    });
  }
  ///load video
  void _loadRewardedVideoAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "781313709744134_781317496410422",
      listener: (result, value) {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE){
       Get.off(HomeScreenSTL());
        }

        /// Once a Rewarded Ad has been closed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
            (value == true || value["invalidated"] == true)) {
          _isRewardedAdLoaded = false;
          _loadRewardedVideoAd();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    double btnWidth = MediaQuery.of(context).size.width / 2 - 40;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ///first section
            Container(
              margin: EdgeInsets.only(top: height*0.01),
              child: Row(
                children: [
                  ///Back Button
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.01, top: height * 0.04),
                    child:  Container(
                      child: InkWell(child: Icon(Icons.arrow_back, color: Colors.yellow.shade700) , onTap: () async {
                        await FacebookRewardedVideoAd.showRewardedVideoAd();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));
                        await UnityAds.showVideoAd(
                          placementId: "Video_Android",
                          onComplete: (placementId){
                            print("Ads is Completed by $placementId ok");
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));
                          },

                        );

                      },),
                    ),
                  ),

                  ///Text
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.26, top: height * 0.04),
                    child: Text(
                      'R, P & S',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
            ///Score
            Container(
              margin: EdgeInsets.only(top: height*0.01),
              padding: EdgeInsets.all(width*0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow.shade700, width: width*0.006),
                borderRadius: BorderRadius.circular(width*0.04),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SCORE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${Game.gameScore}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ///Coins_Data
            // Container(
            //   margin: EdgeInsets.only( left: width * 0.58),
            //   child: Column(
            //     children: [
            //       ///Text
            //       Container(
            //         child: Text(
            //           'My Coin',
            //           style: TextStyle(
            //               fontWeight: FontWeight.w600,
            //               fontFamily: 'poppins',
            //               fontSize: 25,
            //               color: Colors.white),
            //         ),
            //       ),
            //
            //       ///Coins_values
            //       Container(
            //         child: Text(
            //           '${DBcoins}',
            //           style: TextStyle(
            //               fontWeight: FontWeight.w600,
            //               fontSize: 30,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            ///Images
            /* Setting the Game play pad */
            Container(
              margin: EdgeInsets.only(top: height*0.01),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: MediaQuery.of(context).size.width / 2 -
                          (btnWidth / 2) -
                          20, // we soustract the half of ther widget size and the half of the padding,
                      child: Hero(
                        tag: "Rock",
                        child: gameBtn(() {
                          print("you choosed rock");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(GameChoice("Rock")),
                            ),
                          );
                        }, "assets/rock_btn.png", btnWidth),
                      ),
                    ),
                    Positioned(
                      top: btnWidth,
                      left: MediaQuery.of(context).size.width / 2 -
                          btnWidth -
                          40, // we soustract the half of ther widget size and the half of the padding,
                      child: Hero(
                        tag: "Scisors",
                        child: gameBtn(() {
                          print("you choosed scisors");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(GameChoice("Scisors")),
                            ),
                          );
                        }, "assets/scisor_btn.png", btnWidth),
                      ),
                    ),
                    Positioned(
                      top: btnWidth,
                      right: MediaQuery.of(context).size.width / 2 -
                          btnWidth -
                          40, // we soustract the half of ther widget size and the half of the padding,
                      child: Hero(
                        tag: "Paper",
                        child: gameBtn(() {
                          print("you choosed paper");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(GameChoice("Paper")),
                            ),
                          );
                        }, "assets/paper_btn.png", btnWidth),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: FacebookBannerAd(
                placementId: "781313709744134_781317063077132",
              ),
            ),
            ///Banner
            Container(
              child: UnityBannerAd(
                placementId: "Banner_Ad_Android",
              ),
            ),
            ///Rules
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                padding: EdgeInsets.all(width*0.04),
                onPressed: () {},
                shape: StadiumBorder(
                    side: BorderSide(color: Colors.yellow.shade700, width: width*0.006)),
                child: Text(
                  "Rules",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  ///Back button with ads
  Widget _getElevatedButton({ icon, void Function()? onPressed}) {
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
  ///Rewarded ads
  _showRewardedAd() {
    if (_isRewardedAdLoaded == true){
      FacebookRewardedVideoAd.showRewardedVideoAd();
    _loadInterstitialAd();
    _loadRewardedVideoAd();
    _showAd;
  }
    else{
      print("Rewarded Ad not yet loaded!");}
  }
  ///Unity 3.07 update

  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        Get.off(HomeScreenSTL());

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
        Get.off(HomeScreenSTL());

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
