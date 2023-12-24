///
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'HomeScreen.dart';
import 'components/info_card.dart';
import 'utils/game_utils.dart';


class memoryGame extends StatelessWidget {
   memoryGame({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play and Win',
      home: memorySTF(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class memorySTF extends StatefulWidget {
  const memorySTF({Key? key}) : super(key: key);

  @override
  _memorySTFState createState() => _memorySTFState();
}

class _memorySTFState extends State<memorySTF> {
  //setting text style
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  Game _game = Game();

  //game stats
  int tries = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _game.initGame();
    readDataCoins();
    UnityAds.init(
      gameId: '4920099',

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
  ///firebase
int coinsData  = 0;

late  int Database_coins ;
final database = FirebaseDatabase.instance.ref();

  late DataSnapshot snapshot;
void readDataCoins()async{
  snapshot = await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();


  if(snapshot.exists){
    print(snapshot.value);


  }
  Map <dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
setState(() {
  coinsData = map['Current_Coins'];

});

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            Container(

              margin: EdgeInsets.only(bottom: height*0.02),
              child: Row(
                children: [
                  ///Back Button
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.07, top: height * 0.04),
                    child: InkWell(child: Icon(Icons.arrow_back, color: Colors.yellow.shade700)
                      , onTap: () async {
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
                  ///SizeBox
                  SizedBox(
                    width: width*0.2,
                  ),
                  ///Text
                  Container(
                    margin: EdgeInsets.only(
                         top: height * 0.04),
                    child: Text(
                      'Free Earn',
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
            ///2nd Border
            Container(
              height: height * 0.14,
              width: width,
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.11),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.05),
                  border: Border.all(
                    color: Colors.yellow.shade700,
                  )),
            ),
            ///Check Balance
            Container(
              // color: Colors.blue,
              height: height*0.12,
              margin: EdgeInsets.only(left: width*0.1, right: width*0.1, top: height*0.115),
              child: InkWell(
                onTap: (){
                  FacebookRewardedVideoAd.loadRewardedVideoAd(
                    placementId: "781313709744134_781317253077113"
                  );
                  Get.offNamed('/home/DashBoard');

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Text
                    Container(
                      margin: EdgeInsets.only(top: height*0.035),
                      child: Column(
                        children: [
                          Text("Click & check",style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ), ),
                          RichText(
                            text: TextSpan(
                                text: " coins ", style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                                children: [
                                  TextSpan(
                                    text: "Balance", style: TextStyle(
                                      color: Colors.yellow.shade700,
                                      fontFamily: 'poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                  )
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Icon
                    Container(
                      child: Icon(Icons.wallet_outlined, color: Colors.yellow.shade700,size: 40,),
                    ),
                  ],
                ),
              ),
            ),
            ///1

            Container(
              margin: EdgeInsets.only(top: height*0.26),
              // padding: EdgeInsets.only(top: height*0.0001),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  info_card("Tries", "$tries"),
                  info_card("Score", "$score"),
                ],
              ),
            ),
           ///
            Container(
              margin: EdgeInsets.only(top: height*0.41),
              child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      itemCount: _game.gameImg!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      padding: EdgeInsets.all(16.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print(_game.matchCheck);
                            setState(() {
                              //incrementing the clicks
                              tries++;
                              _game.gameImg![index] = _game.cards_list[index];
                              _game.matchCheck
                                  .add({index: _game.cards_list[index]});
                              print(_game.matchCheck.first);
                            });
                            if (_game.matchCheck.length == 2) {
                              if (_game.matchCheck[0].values.first ==
                                  _game.matchCheck[1].values.first) {
                                print("true");
                                //incrementing the score
                                score += 1;
                                _game.matchCheck.clear();
                                ///
                                final database = FirebaseDatabase.instance.ref();
                                Future getData()async{
                                  ///ab yaha hum snapsot ka parameter banae ge or phr = ke bad hum database or phr node ka name or phr
                                  /// sy child next child es liye ke data jaha sy aana or phr os child may hum firebaseauth ke zariye
                                  /// email and passord ke zariye krwaya tha na tou waha hum firebaseauth.instance.currentuser!.uid cureentuser
                                  /// es liye ke jo user data enter kry ga os ke liye then phr get() q ke hum ny data read krna
                                  snapshot =await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
                                  ///ab condition lgae ge check krny ke liye so

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
                                    Database_coins= map['Current_Coins'];
                                    int re = score - score + 1;
                                    int dbCoint = Database_coins;
                                    int get = re + dbCoint;
                                    print('${Database_coins}+${score} =  ${get}');
                                    DatabaseReference database = FirebaseDatabase.instance.ref();
                                    await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                                        {
                                          "Current_Coins":get,
                                        });

                                    // });
                                  }else{
                                    print('not exists');
                                  }
                                };
                                setState(() {
                                  getData();
                                });

                              } else {
                                print("false");

                                Future.delayed(Duration(milliseconds: 500), () {
                                  print(_game.gameColors);
                                  setState(() {
                                    _game.gameImg![_game.matchCheck[0].keys.first] =
                                        _game.hiddenCardpath;
                                    _game.gameImg![_game.matchCheck[1].keys.first] =
                                        _game.hiddenCardpath;
                                    _game.matchCheck.clear();
                                  });
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(_game.gameImg![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      })),
            ),
            ///New Game
            Container(

              margin: EdgeInsets.only(top: height*0.88, left: width*0.355),

              child: GestureDetector(

                onTap: (){
                  UnityAds.showVideoAd(
                    placementId: "Video_Android",
                    onComplete: (placementId){
                      print("Ads is Coomplete ");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));
                      setState(() {
                        coinsData;
                      });
                    },
                    onFailed: (placementId, error, message){
                      print('Video Ad $placementId failed: $error $message');
                      Get.showSnackbar(GetSnackBar(
                        duration: Duration(seconds: 4),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey.shade800,
                        titleText : Text("Ads Failed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                        messageText: Text("Ads is not available now. Please Try Later. Thank You",style: TextStyle(color: Colors.white,fontFamily: 'poppins') ),
                      ));
                    }
                  );
                },
                child: Container(
                  height: height*0.06,
                  width: width*0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                    border: Border.all(color: Colors.yellow.shade700),
                  ),
                  child: Center(
                    child: Text("New Game",
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600, fontSize: 15,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Banner
            Container(
              margin: EdgeInsets.only(top: height*0.95),

              child: FacebookBannerAd(
                placementId: "781313709744134_781317063077132",

              )
            ),
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
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));

    }
    else{

      print("Interstial Ad not yet loaded!");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreenSTL()));
    }
  }
}