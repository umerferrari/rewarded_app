import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

import '../SpinWheel.dart';
import '../utils/game.dart';
import '../widgets/button.dart';
import 'main_screen.dart';

class GameScreen extends StatefulWidget {
  GameScreen(this.gameChoice, {Key? key}) : super(key: key);
  GameChoice gameChoice;
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /* Generating random choice */
  String? randomChoice() {
    Random random = new Random();
    int robotChoiceIndex = random.nextInt(3);
    return Game.choices[robotChoiceIndex];
  }
  ///initstate
  void initState() {
    // TODO: implement initState
    super.initState();
    //deleteCoins();
    readData();
    UnityAds.init(
      gameId: AdManager.gameId,
      onComplete: () {
        print('Initialization Complete');
        // _loadAds();
      },
      onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );

    // userdetails();
  }
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


  late double width;
  late double height;
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RockMainScreenSTL()));

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
    String robotChoice = randomChoice()!;
    String? robotChoicePath;
    switch (robotChoice) {
      case "Rock":
        robotChoicePath = "assets/rock_btn.png";
        break;
      case "Paper":
        robotChoicePath = "assets/paper_btn.png";
        break;
      case "Scisors":
        robotChoicePath = "assets/scisor_btn.png";
        break;
      default:
    }
    String? player_choice;
    switch (widget.gameChoice.type) {
      case "Rock":
        player_choice = "assets/rock_btn.png";
        break;
      case "Paper":
        player_choice = "assets/paper_btn.png";
        break;
      case "Scisors":
        player_choice = "assets/scisor_btn.png";
        break;
      default:
    }
    if (GameChoice.gameRules[widget.gameChoice.type]![robotChoice] ==
        "You Win") {
      setState(() {
        Game.gameScore++;
      });
    }

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
                    child: InkWell(
                      onTap: ()async{
                        await FacebookRewardedVideoAd.showRewardedVideoAd();
                        Get.offNamed('/home');
                        await UnityAds.showVideoAd(
                          placementId: "Video_Android",
                          onComplete: (placementId){
                            print("Ads is Completed by $placementId ok");
                            Get.offNamed('/home');

                          },

                        );

                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.yellow.shade700,
                        size: 35,
                      ),
                    ),
                  ),

                  ///Text
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.28, top: height * 0.04),
                    child: Text(
                      'Result',
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
              margin: EdgeInsets.only(top: height*0.1),
              padding: EdgeInsets.all(width*0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow.shade700, width: width*0.006),
                borderRadius: BorderRadius.circular(width*0.04),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Sscore text
                  Text(
                    "SCORE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins'
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

            /* Setting the Game play pad */
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "${widget.gameChoice.type}",
                      child: gameBtn(() {}, player_choice!, btnWidth - 20),
                    ),
                    Text(
                      "VS",
                      style: TextStyle(color: Colors.white, fontSize: 26.0),
                    ),
                    AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(seconds: 3),
                      child: gameBtn(() {}, robotChoicePath!, btnWidth - 20),
                    )
                  ],
                ),
              ),
            ),
            Text(
              "${GameChoice.gameRules[widget.gameChoice.type]![robotChoice]}",
              style: TextStyle(color: Colors.white, fontSize: 36.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                padding: EdgeInsets.all(24.0),
                onPressed: () async{
                  ///Unity ads
                  UnityAds.showVideoAd(
                      placementId: "Video_Android",
                      onComplete: (placementId) async {
                        print("Ads is Completed by $placementId ok");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RockMainScreenSTL()));

                        ///reward

                        ///ab yaha hum snapsot ka parameter banae ge or phr = ke bad hum database or phr node ka name or phr
                        /// sy child next child es liye ke data jaha sy aana or phr os child may hum firebaseauth ke zariye
                        /// email and passord ke zariye krwaya tha na tou waha hum firebaseauth.instance.currentuser!.uid cureentuser
                        /// es liye ke jo user data enter kry ga os ke liye then phr get() q ke hum ny data read krna
                        ///ab condition lgae ge check krny ke liye so
                        snapshot = await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();

                        ///Map value aleda aleda dekhany ke liye bana rha map ke 2 parameter hoty hai <> ke andr (requiered)
                        ///as map es liye kiya q ke hum ny convert krna tha snapshot ko map may
                        Map<dynamic,dynamic> map = snapshot.value as Map <dynamic,dynamic>;
                        if(snapshot.exists){
                          ///ab console may dekhy ge print kra kr agr sari values chaye tou hum print may snapshot.value  lekh dy ge
                          ///phr console may sari value show ho jae ge
                          // print(snapshot.value);
                          ///agr hum ny sab value aleda aleda console may show krani ho tou oske liye map banae ge conditon sy phly
                          ///oper map ban gya if ke oper so ab prinnt krwae ge values console may krwae ge phly phr dynamic
                          print(map['Current_Coins']);

                          ///abhi agr hum esy he run kry ge tou kuch b show nhi kry ga q ke hum ny osy map may convert kiya howa hai
                          ///enconvert krny ke liye hum setstate may lekhy ge
                          // setState(() {
                          // setState(() {
                          //   ///jo b print krwana oska variable phly bnae ge oper oska name phr nechy get kry ge variable function ke bahir
                          //   ///banae ge
                          //   showCoins= map['Current_Coins'];
                          // });
                          ///jo b print krwana oska variable phly bnae ge oper oska name phr nechy get kry ge variable function ke bahir
                          ///banae ge
                          DBcoins= map['Current_Coins'];

                          int re = Game.gameScore - Game.gameScore + 1;
                          int dbCoint = DBcoins;
                          int get = re + dbCoint;
                          print('${DBcoins}+${Game.gameScore} =  ${get}');
                          DatabaseReference database = FirebaseDatabase.instance.ref();
                          await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                              {
                                "Current_Coins":get,
                              });

                          // });
                        }else{
                          print('not exists');
                        }
                      },
                      onSkipped: (placementId){
                        Get.showSnackbar(
                            GetSnackBar(
                                messageText: Text("Please Don't Skipped the Ads. Please Try Again",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins')),
                                backgroundColor: Colors.grey.shade800,
                                duration: Duration(seconds: 4),
                                snackPosition: SnackPosition.BOTTOM,
                                titleText: Text("Ads Failed",style: TextStyle(color: Colors.white,fontFamily: 'poppins'))
                            )
                        );
                      },
                      onFailed: (placementId, error, message){
                        print('Video Ad $placementId failed: $error $message');

                      }
                  );
                  await FacebookRewardedVideoAd.showRewardedVideoAd();
                },
                shape: StadiumBorder(),
                fillColor: Colors.yellow.shade700,
                child: Text(
                  "Play Again",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ///Rules
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                padding: EdgeInsets.all(24.0),
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

  ///initial ads
  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true){
      FacebookInterstitialAd.showInterstitialAd();
     Navigator.pop(context);

    }
    else{

      print("Interstial Ad not yet loaded!");
      Navigator.pop(context);
    }
  }
  void _loadAd(String placementId) {
    UnityAds.load(
        placementId: placementId,
        onComplete: (placementId) {
          print('Load Complete $placementId');


        },
        onFailed: (placementId, error, message) {
          print('Load Failed $placementId: $error $message');
        }


    );
  }

  void _showAd(String placementId) {
    UnityAds.showVideoAd(
      placementId: 'Video_Android',
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
        Get.offNamed('/home');


      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
        Get.offNamed('/home');


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
