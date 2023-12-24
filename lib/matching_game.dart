

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'SpinWheel.dart';

class MatchingSTL extends StatelessWidget {
  const MatchingSTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MatchingSTF(),
    );
  }
}


class MatchingSTF extends StatefulWidget {
  @override
  _MatchingSTFState createState() => _MatchingSTFState();
}


class _MatchingSTFState extends State<MatchingSTF> {



  late List<ItemModel> items;
  late List<ItemModel>items2;

  late int score;
  late bool gameOver;
  int showCoins = 0 ;
  void _getCoins()async{

}
  @override
  void initState() {
    super.initState();
    initGame();
    UnityAds.init(
      gameId: AdManager.gameId,
      onComplete: () {
        print('Initialization Complete');
        // _loadAds();
      },
      onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );

    ///Facebook ads init
    /// please add your own device testingId
    /// (testingId will print in console if you don't provide  )
   FacebookRewardedVideoAd.showRewardedVideoAd();
    _loadInterstitialAd();
  }

  initGame(){
    gameOver = false;
    score=0;
    items=[
      ItemModel(icon:FontAwesomeIcons.coffee,name:"Coffee", value:"Coffee"),
      ItemModel(icon:FontAwesomeIcons.dog,name:"dog", value:"dog"),
      ItemModel(icon:FontAwesomeIcons.cat,name:"Cat", value:"Cat"),
      ItemModel(icon:FontAwesomeIcons.birthdayCake,name:"Cake", value: "Cake"),
      ItemModel(icon:FontAwesomeIcons.bus,name:"bus", value:"bus"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }
///
  late double width;
  late double height;

  late DataSnapshot snapshot;
  final database = FirebaseDatabase.instance.ref();
  late int DBcoins = 0;

  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
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

    if(items.length == 0)
      gameOver = true;



    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Container(
          child: SafeArea(
            child:  Column(
              children: <Widget>[
                ///Text And Back Button
                Container(
                  child: Row(
                    children: [
                      ///Back Button
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.07, top: height * 0.02),
                        child: InkWell(child: Icon(Icons.arrow_back, color: Colors.yellow.shade700) , onTap: () async {
                         await FacebookRewardedVideoAd.loadRewardedVideoAd();
                         Get.offNamed('/home');
                         await UnityAds.showVideoAd(
                           placementId: "Video_Android",
                           onComplete: (placementId){
                             print("Ads is Completed by $placementId ok");
                             Get.offNamed('/home');
                           },

                         );

                        },),

                      ),

                      ///Text
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.19, top: height * 0.02),
                        child: Text(
                          'Matching',
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
                  padding: EdgeInsets.only(bottom: height*0.1),
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(text: "Score: ", style: TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: 'poppins')),
                        TextSpan(text: "$score", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ))
                      ]
                  )
                  ),
                ),
                if(!gameOver)
                  Row(
                    children: <Widget>[
                      Column(
                          children: items.map((item) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Draggable<ItemModel>(
                                data: item,
                                childWhenDragging: Icon(
                                  item.icon, color: Colors.white,size: 50.0,),
                                feedback: Icon(item.icon,color: Colors.yellow.shade700,size: 50,),
                                child: Icon(item.icon, color: Colors.yellow.shade700, size:50,),
                              ),
                            );


                          }).toList()
                      ),
                      Spacer(

                      ),
                      Column(
                          children: items2.map((item){
                            return DragTarget<ItemModel>(
                              onAccept: (receivedItem){
                                if(item.value== receivedItem.value){
                                  setState(() {
                                    items.remove(receivedItem);
                                    items2.remove(item);
                                    score+=2;
                                    item.accepting =false;
                                  });

                                }else{
                                  setState(() {
                                    score-=1;
                                    item.accepting =false;

                                  });
                                }
                              },
                              onLeave: (receivedItem){
                                setState(() {
                                  item.accepting=false;
                                });
                              },
                              onWillAccept: (receivedItem){
                                setState(() {
                                  item.accepting=true;
                                });
                                return true;
                              },
                              builder: (context, acceptedItems,rejectedItem) => Container(
                                color: item.accepting? Colors.red:Colors.yellow.shade700,
                                height: 50,
                                width: 100,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(8.0),
                                child: Text(item.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                    fontSize: 18.0),),
                              ),


                            );

                          }).toList()

                      ),
                    ],
                  ),
                if(gameOver)
                  Container(
                    margin: EdgeInsets.only(bottom: height*0.03),
                    child: Text("GameOver", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),),
                  ),
                if(gameOver)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Colors.yellow.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width*0.03),
                        ),
                        padding: EdgeInsets.all(width*0.04),

                      ),
                      child: Text("New Game",
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 23.0
                        ),
                      ),
                      onPressed: ()async
                      {
                      // await FacebookRewardedVideoAd.showRewardedVideoAd();
                      try{
                        Get.off(MatchingSTL());
                        snapshot = await database.child("Spins").child(FirebaseAuth.instance.currentUser!.uid).get();
                        if(snapshot.exists){
                          print(snapshot.value);

                          Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;


                          showCoins = map["Current_Coins"];
                          int totalCoins = showCoins + score ;
                          print("${showCoins} + ${score} =  ${totalCoins}");


                          await database.child("Spins").child(FirebaseAuth.instance.currentUser!.uid).update(
                              {
                                "Current_Coins" : totalCoins,
                              });
                        }else{
                          print("Coins does not exists.");
                        }
                      }catch(e){print(e);}
                      // await UnityAds.showVideoAd(placementId: "Video_Ads");
                      },
                    ),
                  ),
                ///Banner
                Container(
                  margin: EdgeInsets.only(top: height*0.12),

                  child: UnityBannerAd(
                    placementId: "Banner_Ad_Android",
                  ),
                ),
                Container(
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
          size: 30,
        ),
      ),
    );
  }

  ///initial ads
  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true){
      FacebookInterstitialAd.showInterstitialAd();
    }
    else{

      print("Interstial Ad not yet loaded!");
    }
  }
  ///Rewarded ads
  _showRewardedAd() {
    if (_isRewardedAdLoaded == true){
      FacebookRewardedVideoAd.showRewardedVideoAd();
      _showAd;
      _loadInterstitialAd();
      _showInterstitialAd();

    }
    else{
      print("Rewarded Ad not yet loaded!");
    }
  }

}

class ItemModel {
  final String name;
  final String value;
  final IconData icon;
  bool accepting;








  ItemModel({required this.name, required this.value, required this.icon, this.accepting= false});}