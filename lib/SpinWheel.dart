

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:start_and_earn/Widgets/appbar.dart';
import 'package:start_and_earn/widgets/check_coin_balance.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'components/sizedbox.dart';

class SpinWheel extends StatefulWidget {
  final String idfa;

  const SpinWheel({Key? key, this.idfa = ''}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {

  final selected = BehaviorSubject<int>();
  int rewards = 0;


TextEditingController reward = TextEditingController();
  List<int> items = [
    05,
    20,
    15,
    25,
    10,
    0,
  ];
  final colors = <Color>[
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.indigo,
    Colors.deepOrange,
    Colors.green,
  ];
  ///
 int showCoins=0  ;
  ///
  late DataSnapshot snapshot;
  final database = FirebaseDatabase.instance.ref();

  int Database_coins = 0;
  ///reward
  Future getData( int rewards)async{
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

      int re = rewards;
      int dbCoint = Database_coins;
      int get = re + dbCoint;
      print('${Database_coins}+${rewards} =  ${get}');
      DatabaseReference database = FirebaseDatabase.instance.ref();
      await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
          {
            "Current_Coins":get,
          });

      // });
    }else{
      print('not exists');
    }
  }
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //getData();
  //   Database_coins=0;
  //   UnityAds.init(
  //     gameId: AdManager.gameId,
  //     onComplete: () {
  //       print('Initialization Complete');
  //       _loadAds();
  //     },
  //     onFailed: (error, message) => print('Initialization Failed: $error $message'),
  //   );
  //
  //   ///Facebook ads init
  //   /// please add your own device testingId
  //   /// (testingId will print in console if you don't provide  )
  //   FacebookAudienceNetwork.init(
  //     testingId: "a77955ee-3304-4635-be65-81029b0f5201",
  //     iOSAdvertiserTrackingEnabled: true,
  //   );
  //   ///Wifi Connectivity
  //   _connectivity.onConnectivityChanged.listen((event) {
  //     if(event == ConnectivityResult.none){
  //       setState(() {
  //         hideUi = true;
  //       });
  //     }else{
  //       setState(() {
  //         hideUi = false;
  //       });
  //     }
  //   });
  //   ///Value
  //   chamgedData();
  //   ///Count Data Storage
  //   // if(data.read('count')!=null){
  //   //   count = data.read('count');
  //   // }
  //   Permissions();
  // }
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
  //
  // @override
  // void dispose() {
  //   selected.close();
  //   super.dispose();
  // }
///height and width
  late double width;
  late double height;
  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  ///Initial
  void _loadInterstitialAd() {
    _loadRewardedVideoAd();
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "781313709744134_781317253077113",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
          // setState(() {
          //   selected.add(Fortune.randomInt(0, items.length));
          // });
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
          setState(() {
            selected.add(Fortune.randomInt(0, items.length));
          });
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
///Unity update 3.07
  bool _showBanner = false;
  Map<String, bool> placements = {
    AdManager.interstitialVideoAdPlacementId: false,
    AdManager.rewardedVideoAdPlacementId: false,
  };
var count= 0.obs ;
final data = GetStorage();
  void chamgedData(){
     Timer(Duration(minutes: 4), () {
      setState(() {
        count = 0.obs;

      });
    });
  }
// Obtain shared preferences.

  @override
  Widget build(BuildContext context) {
data.writeIfNull('count', 0);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBarJustLead(context: context,titleText: "Spinner"),
      // backgroundColor: Colors.black,
             body: hideUi? Container(
        margin: EdgeInsets.only(top: Get.height*0.3),
        alignment: Alignment.center,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ///Icon
            Icon(Icons.wifi_off, color: Colors.yellow.shade700,size: 160,),
            ///Size Box
            Container(
              child: SizedBox(
                height: Get.height*0.01,
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
      ) : SingleChildScrollView(

        child: Padding(
          padding: kPaddingHorizontal20,
          child: Column(
            children: [
              sizeHeight15,
              ///Banner
              Container(
                // margin: EdgeInsets.only(top: Get.height*0.11),
                // height: Get.height,width: Get.width,
                // color: Colors.blue,
                child: FacebookBannerAd(
                  placementId: "781313709744134_781317063077132",
                ),
              ),
              ///Check balance
              checkCoinBalanceFun(context: context),
              sizeHeight20,
              ///wheel
              Container(
                // margin: EdgeInsets.only(top: Get.height*0.34),
                child: SizedBox(
                  height: 300,

                  child: FortuneWheel(

                    selected: selected.stream,
                    animateFirst: true,
                    items: [
                      // for(int i = 0; i < items.length; i++)...<FortuneItem>{
                      //   FortuneItem(child: Text(items[i].toString())),
                      //
                      // },
                      ///
                      FortuneItem(
                        child: Text('05'),
                        style: FortuneItemStyle(
                          color: Colors.orange,
                            borderColor: Colors.yellow.shade700

                        ),
                      ),
                      FortuneItem(
                        child: Text('20'),
                        style: FortuneItemStyle(
                          color: Colors.blue,
                          borderColor: Colors.yellow.shade700
                        ),
                      ),
                      FortuneItem(
                        child: Text('15'),
                        style: FortuneItemStyle(
                          color: Colors.green,
                          borderColor: Colors.yellow.shade700
                        ),
                      ),
                      FortuneItem(
                        child: Text('25'),
                        style: FortuneItemStyle(
                          color: Colors.grey,
                            borderColor: Colors.yellow.shade700

                        ),
                      ),
                      FortuneItem(
                        child: Text('10'),
                        style: FortuneItemStyle(
                          color: Colors.red,
                            borderColor: Colors.yellow.shade700

                        ),
                      ),
                      FortuneItem(
                        child: Text('0'),
                        style: FortuneItemStyle(
                          color: Colors.deepPurple,
                            borderColor: Colors.yellow.shade700

                        ),
                      ),
                    ],
                    onFocusItemChanged: (e){
                      print("object3 $e");
                    },

                    onAnimationEnd: () async{
                      print("itemValue ${items[selected.stream.value]}");
                      setState(() {
                        rewards = items[selected.value];
                      });
                      print("reward ${reward.text}");
                     // print(rewards);


                      // await getData(rewards);


                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "You just won " + rewards.toString() + " Points!",

                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
              ),
              sizeHeight20,
              ///Button1
              Container(

                // margin: EdgeInsets.only(top: Get.height*0.73, left: Get.width*0.355),

                child: GestureDetector(

                  onTap: () async{
                   // await UnityAds.showVideoAd(
                   //    placementId: "Video_Android",
                   //    onComplete: (placementId){
                   //      print("Ads is Completed by $placementId ok");
                   //      setState(() {
                   //        selected.add(Fortune.randomInt(0, items.length));
                   //      });
                   //    },
                   //    onSkipped: (placementId){
                   //      Get.showSnackbar(
                   //        GetSnackBar(
                   //            messageText: Text("Please Don't Skipped the Ads. Please Try Again",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins')),
                   //            backgroundColor: Colors.grey.shade800,
                   //            duration: Duration(seconds: 4),
                   //            snackPosition: SnackPosition.BOTTOM,
                   //            titleText: Text("Ads Failed",style: TextStyle(color: Colors.white,fontFamily: 'poppins'))
                   //        )
                   //      );
                   //    },
                   //    onFailed: (placementId, error, message){
                   //      print('Video Ad $placementId failed: $error $message');
                   //      _showAd(placementId);
                   //      _showRewardedAd();
                   //      _loadInterstitialAd();
                   //
                   //      Get.showSnackbar(GetSnackBar(
                   //        duration: Duration(seconds: 4),
                   //        snackPosition: SnackPosition.BOTTOM,
                   //        backgroundColor: Colors.grey.shade800,
                   //          titleText : Text("Ads Failed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                   //        messageText: Text("Ads is not available now. Please Try Later. Thank You",style: TextStyle(color: Colors.white,fontFamily: 'poppins') ),
                   //      ));
                   //    }
                   //  );
                   // await FacebookRewardedVideoAd.showRewardedVideoAd();
                    print("object");
                    setState(() {
                      selected.add(Fortune.randomInt(0, items.length));
                    });
                  },
                  child: Container(
                    height: Get.height*0.06,
                    width: Get.width*0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                      border: Border.all(color: Colors.yellow.shade700),
                    ),
                    child: Center(
                      child: Text("SPIN",
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600, fontSize: 20,
                        color: Colors.white
                      ),
                      ),
                    ),
                  ),
                ),
              ),
//               sizeHeight10,
//               ///Button2
//               Container(
//                 // margin: EdgeInsets.only(top: Get.height*0.82, left: Get.width*0.355),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("You Have ${data.read('count').toString()}/5 Ads Availble", style: TextStyle(color: Colors.white),)
// ,
//                     Container(
//                       // margin: EdgeInsets.only(top: Get.height*0.03),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           side: BorderSide(color: Colors.yellow.shade700),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(Get.width)
//                           ),
//                         ),
//                         onPressed: () async{
//                          if(count<=4){
//                            count++;
//                            data.write('count', count);
//                            // Save an integer value to 'counter' key.
//
//                            print(count);
//                            await FacebookRewardedVideoAd.showRewardedVideoAd();
//                              setState(() {
//                                selected.add(Fortune.randomInt(0, items.length));
//                                _isRewardedAdLoaded = false;
//                                showCoins;
//                              });
//                              await FacebookRewardedVideoAd.loadRewardedVideoAd(
//                                placementId: "781313709744134_834060271136144",
//                                listener: (result, value) {
//                                  print(">> FAN > Interstitial Ad: $result --> $value");
//                                  if (result == InterstitialAdResult.LOADED) {
//                                    _isInterstitialAdLoaded = true;
//                                    setState(() {
//                                      showCoins;
//                                      _isInterstitialAdLoaded = false;
//                                    });
//                                  }
//                                  /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//                                  /// load a fresh Ad by calling this function.
//                                  if (result == InterstitialAdResult.DISMISSED &&
//                                      value["invalidated"] == true) {
//                                    _isInterstitialAdLoaded = false;
//                                    _loadInterstitialAd();
//                                  }
//                                },
//
//                              );
//                              await FacebookRewardedVideoAd.loadRewardedVideoAd(
//                                placementId: "781313709744134_781317496410422",
//                                listener: (result, value) {
//                                  print(">> FAN > Interstitial Ad: $result --> $value");
//                                  if (result == InterstitialAdResult.LOADED) {
//                                    _isInterstitialAdLoaded = true;
//                                    setState(() {
//                                      showCoins;
//                                      _isInterstitialAdLoaded = false;
//                                    });
//                                  }
//                                  /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//                                  /// load a fresh Ad by calling this function.
//                                  if (result == InterstitialAdResult.DISMISSED &&
//                                      value["invalidated"] == true) {
//                                    _isInterstitialAdLoaded = false;
//                                    _loadInterstitialAd();
//                                  }
//                                },
//
//                              );
//                          }else{
//                            Get.showSnackbar(
//                                       GetSnackBar(
//                                           messageText: Text("Ad Video Limit is Complete 5/5. Please Try Later",style: TextStyle(color: Colors.white,fontFamily: 'poppins')),
//                                           backgroundColor: Colors.grey.shade800,
//                                           duration: Duration(seconds: 4),
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           titleText: Text("limit Complete",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'))
//                                       )
//                                   );
//                          }
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: Get.width*0.04,vertical: Get.height*0.013),
//                           child: Text("Spin 2",style:TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'poppins',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ),
              sizeHeight20,
            ],
          ),
        ),
      ),
    );
  }
  ///Rewarded ads
  _showRewardedAd() async{
    if (_isRewardedAdLoaded == true){
    await  FacebookRewardedVideoAd.showRewardedVideoAd();
      _loadAd;
      setState(() {
        selected.add(Fortune.randomInt(0, items.length));
      });
    }
    else {
      print("Rewarded Ad not yet loaded!");
    }}
  ///Rewarded 2
  _showRewardedAd2() async{
    if (_isRewardedAdLoaded == true){
      await  FacebookRewardedVideoAd.showRewardedVideoAd();
      _loadAd;
    }
    else {
      print("Rewarded2 Ad not yet loaded!");
    }}
///Unity 3.07 update
  void _loadAds() async{
    for (var placementId in placements.keys) {
      _loadAd(placementId);

    }
  }

  void _loadAd(String placementId) async{
   await UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
      },
      onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
    );
  }

  void _showAd(String placementId) async{
   await UnityAds.showVideoAd(
      placementId: 'Video_Android',
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
        setState(() {
          selected.add(Fortune.randomInt(0, items.length));
        });
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
///New Unity 3.07
class AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '4920099';
    }

    return '';
  }

  static String get bannerAdPlacementId {
    return 'Banner_Ad_Android';
  }

  static String get interstitialVideoAdPlacementId {
    return 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return 'Video_Android';
  }
  ///

}

