import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/paths.dart';
import 'package:start_and_earn/components/sizedbox.dart';
import 'package:start_and_earn/history.dart';
import 'package:start_and_earn/rules.dart';
import 'package:start_and_earn/widgets/user_dashboard_card.dart';
import 'AuthScreens/authScreen.dart';
import 'SpinWheel.dart';
import 'Widgets/appbar.dart';
import 'components/text_style.dart';
import 'feed and Contact.dart';
import 'logInForm.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:get/get.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:url_launcher/url_launcher.dart';
class userDashboard extends StatelessWidget {
  const userDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: appBarJustLead(context: context,titleText: "Dashboard",
            // action: TextButton(
            //   style: TextButton.styleFrom(
            //     foregroundColor: mainColor
            //   ),
            // onPressed: (){},
            // child: Text("Edit Profile",style: txtStyle14AndMainBold,))
        ),
        body: userDashboardSTF(),
      ),
    );
  }
}

///stf
class userDashboardSTF extends StatefulWidget {
  const userDashboardSTF({Key? key}) : super(key: key);

  @override
  State<userDashboardSTF> createState() => _userDashboardSTFState();
}

class _userDashboardSTFState extends State<userDashboardSTF> {
  late double width;
  late double height;

  ///firebase sy data mobile app may lany ka taariqa
  late DataSnapshot datasnapshot;
  late DataSnapshot snapshot1;

  ///variables get data jo b print krwana oske
  String username = '';
  String phone = '';
  String email = '';
  String userImg = '';
  ///sab sy phly hum 1 function banae ge may getDAta  ke name sy bana rha
  /// ho lekin os sy phly database lekhy ge jaha sy data aana
  final Database = FirebaseDatabase.instance.ref();
  Future getData() async {
    ///ab yaha hum snapsot ka parameter banae ge or phr = ke bad hum database or phr node ka name or phr
    /// sy child next child es liye ke data jaha sy aana or phr os child may hum firebaseauth ke zariye
    /// email and passord ke zariye krwaya tha na tou waha hum firebaseauth.instance.currentuser!.uid cureentuser
    /// es liye ke jo user data enter kry ga os ke liye then phr get() q ke hum ny data read krna
    datasnapshot = await Database.child('Users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get();

    ///ab condition lgae ge check krny ke liye so

    ///Map value aleda aleda dekhany ke liye bana rha map ke 2 parameter hoty hai <> ke andr (requiered)
    ///as map es liye kiya q ke hum ny convert krna tha snapshot ko map may
    Map<dynamic, dynamic> map = datasnapshot.value as Map<dynamic, dynamic>;
    if (datasnapshot.exists) {
      ///ab console may dekhy ge print kra kr agr sari values chaye tou hum print may snapshot.value  lekh dy ge
      ///phr console may sari value show ho jae ge
      // print(snapshot.value);
      ///agr hum ny sab value aleda aleda console may show krani ho tou oske liye map banae ge conditon sy phly
      ///oper map ban gya if ke oper so ab prinnt krwae ge values console may krwae ge phly phr dynamic
      print(map['username']);
      print(map['password']);

      ///abhi agr hum esy he run kry ge tou kuch b show nhi kry ga q ke hum ny osy map may convert kiya howa hai
      ///enconvert krny ke liye hum setstate may lekhy ge
      setState(() {
        ///jo b print krwana oska variable phly bnae ge oper oska name phr nechy get kry ge variable function ke bahir
        ///banae ge
        username = map['username'];
        email = map['email'];
        phone = map['phone'];
        userImg = map['profilePhoto'];
      });
      print("The Done");
    } else {
      print('database data not exists===');
    }
    ///
    snapshot1 = await Database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
    if (snapshot1.exists) {
      print(snapshot1.value);
      Map<dynamic,dynamic> map1 = snapshot1.value as Map<dynamic,dynamic>;
      setState(() {
        coinsData = map1['Current_Coins'];
      });
    }else{
      print('Not Exists');
    }
  }

  ///last pr check krny ke liye ke data waqae may arha ya nhi oske liye hum initState ke zariye key ge

  ///Coins
  int coinsData = 0;
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context,dashboardProvider,child){
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
        ) : SingleChildScrollView(
          child: Padding(
            padding: kPaddingHorizontal20,
            child: Column(
              children: [
                ///Banner
                Container(
                  // // margin: EdgeInsets.only(top: height*0.13),
                  // height: height,
                  width: width,
                  // color: Colors.blue,
                  child: FacebookBannerAd(
                    placementId: "781313709744134_781317063077132",
                  ),
                ),
                sizeHeight20,
                // CircleAvatar(
                //   // child: ,
                //   radius: 60,
                //   backgroundColor: blackOtherColor,
                //   child: Icon(Icons.camera_alt_outlined,color: mainColor,size: 40,),
                // ),
                // sizeHeight15,
                // Text("Umer Ferrari",style: txtStyle16AndBold,),
                // sizeHeight20,
                Card(
                  color: blackOtherColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      SizedBox(
                          height: 60,
                          child: Image.asset(userDashboardMainIcon)),
                      Column(
                    children: [
                      ///Text
                      Container(
                        child: Text(
                          'My Coin',
                          style: txtStyle18AndBold,
                        ),
                      ),

                      ///Coins_values
                      Container(
                        child: Text(
                          '${coinsData}',
                          style: txtStyle20AndBold,
                        ),
                      ),
                    ],
                  ),
                      ],
                    ),
                  ),
                ),
                sizeHeight15,
                Card(
                  color: blackOtherColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last withdraw status',
                          style: txtStyle16AndBold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Container(
                            child: Text(
                              'Pending',
                              style: txtStyle14AndMainBold,
                            ),
                          ),
                          SizedBox(
                                height: 60,
                                child: Image.asset(pendingIcon)),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                sizeHeight15,
                userDashboardCardWithOnTap(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => historySTL()));},
                  title: "History",
                  imagePath: historyIcon,
                  subtitle: "Wallet and Reward History",
                  iconColor: redColor,
                ),
                sizeHeight15,
                userDashboardCardWithOnTap(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => rulesSTL()));},
                  title: "Rules",
                  imagePath: ruleIcon,
                  subtitle: "Carefully read the rules before making a withdrawal.",
                  iconColor: Colors.green,
                ),
                sizeHeight15,
                userDashboardCardWithOnTap(
                  onTap: (){},
                  title: "Support",
                  imagePath: supportIcon,
                  subtitle: "Contact us & send your Feedback",
                  iconColor: blueColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'AuthScreens/authScreen.dart';
// import 'SpinWheel.dart';
// import 'feed and Contact.dart';
// import 'logInForm.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';
// import 'package:get/get.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'package:url_launcher/url_launcher.dart';
// class userDashboard extends StatelessWidget {
//   const userDashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: userDashboardSTF(),
//       ),
//     );
//   }
// }
//
// ///stf
// class userDashboardSTF extends StatefulWidget {
//   const userDashboardSTF({Key? key}) : super(key: key);
//
//   @override
//   State<userDashboardSTF> createState() => _userDashboardSTFState();
// }
//
// class _userDashboardSTFState extends State<userDashboardSTF> {
//   late double width;
//   late double height;
//
//   ///firebase sy data mobile app may lany ka taariqa
//   late DataSnapshot datasnapshot;
//   late DataSnapshot snapshot1;
//
//   ///variables get data jo b print krwana oske
//   String username = '';
//   String phone = '';
//   String email = '';
//   String userImg = '';
//   ///sab sy phly hum 1 function banae ge may getDAta  ke name sy bana rha
//   /// ho lekin os sy phly database lekhy ge jaha sy data aana
//   final Database = FirebaseDatabase.instance.ref();
//   Future getData() async {
//     ///ab yaha hum snapsot ka parameter banae ge or phr = ke bad hum database or phr node ka name or phr
//     /// sy child next child es liye ke data jaha sy aana or phr os child may hum firebaseauth ke zariye
//     /// email and passord ke zariye krwaya tha na tou waha hum firebaseauth.instance.currentuser!.uid cureentuser
//     /// es liye ke jo user data enter kry ga os ke liye then phr get() q ke hum ny data read krna
//     datasnapshot = await Database.child('Users')
//         .child(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//
//     ///ab condition lgae ge check krny ke liye so
//
//     ///Map value aleda aleda dekhany ke liye bana rha map ke 2 parameter hoty hai <> ke andr (requiered)
//     ///as map es liye kiya q ke hum ny convert krna tha snapshot ko map may
//     Map<dynamic, dynamic> map = datasnapshot.value as Map<dynamic, dynamic>;
//     if (datasnapshot.exists) {
//       ///ab console may dekhy ge print kra kr agr sari values chaye tou hum print may snapshot.value  lekh dy ge
//       ///phr console may sari value show ho jae ge
//       // print(snapshot.value);
//       ///agr hum ny sab value aleda aleda console may show krani ho tou oske liye map banae ge conditon sy phly
//       ///oper map ban gya if ke oper so ab prinnt krwae ge values console may krwae ge phly phr dynamic
//       print(map['username']);
//       print(map['password']);
//
//       ///abhi agr hum esy he run kry ge tou kuch b show nhi kry ga q ke hum ny osy map may convert kiya howa hai
//       ///enconvert krny ke liye hum setstate may lekhy ge
//       setState(() {
//         ///jo b print krwana oska variable phly bnae ge oper oska name phr nechy get kry ge variable function ke bahir
//         ///banae ge
//         username = map['username'];
//         email = map['email'];
//         phone = map['phone'];
//         userImg = map['profilePhoto'];
//       });
//       print("The Done");
//     } else {
//       print('database data not exists===');
//     }
//     ///
//     snapshot1 = await Database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
//     if (snapshot1.exists) {
//       print(snapshot1.value);
//       Map<dynamic,dynamic> map1 = snapshot1.value as Map<dynamic,dynamic>;
//       setState(() {
//         coinsData = map1['Current_Coins'];
//       });
//     }else{
//       print('Not Exists');
//     }
//   }
//
//   ///last pr check krny ke liye ke data waqae may arha ya nhi oske liye hum initState ke zariye key ge
//
//   ///Coins
//   int coinsData = 0;
//   ///Internet   Connectivity
//   final Connectivity _connectivity = Connectivity();
//   bool hideUi = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//     ///Unity Ads
//     UnityAds.init(
//       gameId: AdManager.gameId,
//       onComplete: () {
//         print('Initialization Complete');
//       },
//       onFailed: (error, message) => print('Initialization Failed: $error $message'),
//     );
//
//     ///Facebook ads init
//     /// please add your own device testingId
//     /// (testingId will print in console if you don't provide  )
//     FacebookAudienceNetwork.init(
//       testingId: "a77955ee-3304-4635-be65-81029b0f5201",
//       iOSAdvertiserTrackingEnabled: true,
//     );
//     _loadInterstitialAd();
//     ///Wifi Connectivity
//     _connectivity.onConnectivityChanged.listen((event) {
//       if(event == ConnectivityResult.none){
//         setState(() {
//           hideUi = true;
//         });
//       }else{
//         setState(() {
//           hideUi = false;
//         });
//       }
//     });
//     Permissions();
//   }
//   ///Permission
//   void Permissions()async{
//     if ( await Permission.locationWhenInUse.serviceStatus.isEnabled) {
//       // Use location.
//     }
//     if(await Permission.location.serviceStatus.isDisabled){
//
//       await Permission.locationAlways.serviceStatus.isEnabled;
//     }
//     ///Permissions
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.location,
//       Permission.storage,
//     ].request();
//     print(statuses[Permission.location]);
//   }
//   ///Facebook ads
//   bool _isInterstitialAdLoaded = false;
//   bool _isRewardedAdLoaded = false;
//
//   ///Initial
//   void _loadInterstitialAd() {
//     FacebookInterstitialAd.loadInterstitialAd(
//       // placementId: "YOUR_PLACEMENT_ID",
//       placementId: "781313709744134_781317253077113",
//       listener: (result, value) {
//         print(">> FAN > Interstitial Ad: $result --> $value");
//         if (result == InterstitialAdResult.LOADED)
//           _isInterstitialAdLoaded = true;
//
//         /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//         /// load a fresh Ad by calling this function.
//         if (result == InterstitialAdResult.DISMISSED &&
//             value["invalidated"] == true) {
//           _isInterstitialAdLoaded = false;
//           _loadInterstitialAd();
//         }
//       },
//     );
//   }
//   final storage = FlutterSecureStorage();
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     return hideUi? Container(
//       // margin: EdgeInsets.only(top: height*0.3),
//       alignment: Alignment.center,
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.center,
//
//         children: [
//           ///Icon
//           Icon(Icons.wifi_off, color: Colors.yellow.shade700,size: 160,),
//           ///Size Box
//           Container(
//             child: SizedBox(
//               // height: height*0.01,
//             ),
//           ),
//           ///Text
//           Container(
//             child: Text("No Internet Connection",style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'poppins',
//                 fontSize: 25,
//                 fontWeight: FontWeight.w600
//             ),),
//           )
//         ],
//       ),
//     ) : Container(
//       child: SafeArea(
//         child: Column(
//           children: [
//             ///Text And Back Button
//             Container(
//               child: Row(
//                 children: [
//                   ///Back Button
//                   Container(
//                     // // margin: EdgeInsets.only(
//                     //     left: width * 0.07, top: height * 0.04),
//                     child: InkWell(
//                       child: Icon(Icons.arrow_back,
//                           color: Colors.yellow.shade700),
//                       onTap: ()async{
//                         await FacebookRewardedVideoAd.loadRewardedVideoAd(
//                           placementId: "781313709744134_834060271136144",
//                         );
//                         await FacebookRewardedVideoAd.loadRewardedVideoAd(
//                           placementId: "781313709744134_781317496410422",
//                         );
//                         await FacebookRewardedVideoAd.showRewardedVideoAd();
//                         Get.offNamed('/home');
//                         await UnityAds.showVideoAd(
//                           placementId: "Video_Android",
//                           onComplete: (placementId){
//                             print("Ads is Completed by $placementId ok");
//                             Get.offNamed('/home');
//                           },
//
//                         );
//
//                       },
//                     ),
//                   ),
//
//                   ///Text
//                   Container(
//                     // // margin: EdgeInsets.only(
//                     //     left: width * 0.19, top: height * 0.04),
//                     child: Text(
//                       'Dashboard',
//                       style: TextStyle(
//                           fontFamily: 'poppins',
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           fontSize: 25),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///User Details
//             Container(
//               alignment: Alignment.center,
//               // // height: height * 0.2,
//               // width: width,
//               // margin: EdgeInsets.symmetric(
//               //     horizontal: width * 0.05, vertical: height * 0.1),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.05),
//                   border: Border.all(
//                     color: Colors.yellow.shade700,
//                   )),
//
//               ///ROw
//               child: Row(
//                 children: [
//                   /// Avasteer
//                   Container(),
//                 ],
//               ),
//             ),
//
//             ///User_Image
//             Container(
//               // // margin: EdgeInsets.only(top: height * 0.135, left: width * 0.1),
//               // // width: width*0.275,
//               // // height: height*0.125,
//               child: CircleAvatar(
//                 // child: Getimage != false
//                 //     ? Image.network(
//                 //   getUserImage,
//                 // )
//                 //     : Container(
//                 //     color: Colors.yellow.shade700,
//                 //     child: Image.asset(
//                 //       "assets/images/user.png",fit: BoxFit.cover,
//                 //     ))),
//                 // radius: width*0.3,
//                 backgroundImage: NetworkImage(userImg.toString()),
//               ),
//               // child: ClipRRect(
//               //     borderRadius: BorderRadius.circular(width),
//               //     child: userImg != null? Image.network(userImg,fit: BoxFit.fill,) : Container(
//               //         color: Colors.yellow.shade700,
//               //         child: Image.asset("assets/images/user.png"))
//               // ),
//             ),
//
//             ///User_Info
//             Container(
//               // // margin: EdgeInsets.only(top: height * 0.14, left: width * 0.41),
//               child: Column(
//                 children: [
//                   ///NAme
//                   Container(
//                     child: Row(
//                       children: [
//                         ///FieldText
//                         Container(
//                           child: Text(
//                             'Name  :  ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontFamily: 'poppins',
//                                 fontSize: 20,
//                                 color: Colors.white),
//                           ),
//                         ),
//
//                         ///Name
//                         Container(
//                           // // width: width*0.3,
//                           child: Text(
//                             username,
//                             maxLines: 2,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'poppins',
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   ///Email
//                   Container(
//                     child: Row(
//                       children: [
//                         ///FieldText
//                         Container(
//                           child: Text(
//                             'Email : ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w300,
//                                 fontFamily: 'poppins',
//                                 fontSize: 15,
//                                 color: Colors.white),
//                           ),
//                         ),
//
//                         ///email
//                         Container(
//                           // // width: width*0.4,
//                           child: Text(
//                             email,
//
//                             maxLines: 2,
//                             style: TextStyle(
//                                 fontFamily: 'poppins',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 15,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   ///Phone_Number
//                   Container(
//                     child: Row(
//                       children: [
//                         ///FieldText
//                         Container(
//                           child: Text(
//                             'Phone : ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w300,
//                                 fontFamily: 'poppins',
//                                 fontSize: 15,
//                                 color: Colors.white),
//                           ),
//                         ),
//
//                         ///number
//                         Container(
//                           child: Text(
//                             phone,
//                             style: TextStyle(
//                                 fontFamily: 'poppins',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 15,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///2nd Border
//             Container(
//               // // height: height * 0.14,
//               // width: width,
//               // margin: EdgeInsets.symmetric(
//               //     horizontal: width * 0.05, vertical: height * 0.31),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.05),
//                   border: Border.all(
//                     color: Colors.yellow.shade700,
//                   )),
//             ),
//
//             ///Coins_Image
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.33, left: width * 0.1),
//               // height: height * 0.1,
//               child: Image.asset('assets/images/coin_dashboard.png'),
//             ),
//
//             ///Coins_Data
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.33, left: width * 0.58),
//               child: Column(
//                 children: [
//                   ///Text
//                   Container(
//                     child: Text(
//                       'My Coin',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'poppins',
//                           fontSize: 25,
//                           color: Colors.white),
//                     ),
//                   ),
//
//                   ///Coins_values
//                   Container(
//                     child: Text(
//                       '${coinsData}',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 30,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///history Image
//             Container(
//               // height: height * 0.07,
//               // width: width * 0.15,
//               // margin:
//               //     EdgeInsets.only(top: height * 0.465, left: width * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.03),
//                   color: Colors.blue.shade700),
//               child: Image.asset('assets/images/history_white.png'),
//             ),
//
//             ///History text
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.465, left: width * 0.3),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ///Text
//                   Container(
//                     child: InkWell(
//                       onTap: (){
//                         Get.offNamed('/home/DashBoard/history');
//
//                       },
//                       child: Text(
//                         'History',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'poppins',
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   ///Text_description
//                   Container(
//                     child: InkWell(
//                       onTap: (){
//                         Get.offNamed('/home/DashBoard/history');
//
//
//                       },
//                       child: Text(
//                         'Wallet history & Reward History',
//                         style: TextStyle(
//                             fontFamily: 'poppins', color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///line
//             Container(
//               alignment: Alignment.center,
//               // margin: EdgeInsets.only(top: height * 0.555, left: width * 0.1),
//               // width: width * 0.8,
//               // height: height * 0.001,
//               color: Colors.yellow.shade700,
//             ),
//
//             ///Support Image
//             Container(
//               // height: height * 0.07,
//               // width: width * 0.15,
//               // margin:
//               //     EdgeInsets.only(top: height * 0.577, left: width * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.03),
//                   color: Colors.deepPurple.shade400),
//               child: Image.asset('assets/images/support_white.png'),
//             ),
//
//             ///Support text
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.577, left: width * 0.3),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ///Text
//                   Container(
//                     child: InkWell(
//                       onTap: (){
//                         Get.offNamed('/home/DashBoard/feedBack');
//
//                       },
//                       child: Text(
//                         'Support',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'poppins',
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   ///Text_description
//                   Container(
//                     child: InkWell(
//                       onTap: (){
//                         Get.offNamed('/home/DashBoard/feedBack');
//
//                       },
//                       child: Text(
//                         'Contact us & send your Feedback',
//                         style: TextStyle(
//                             fontFamily: 'poppins', color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///line
//             Container(
//               alignment: Alignment.center,
//               // margin: EdgeInsets.only(top: height * 0.667, left: width * 0.1),
//               // // width: width * 0.8,
//               // // height: height * 0.001,
//               color: Colors.yellow.shade700,
//             ),
//
//             ///Privacy And Policy Image
//             Container(
//               // height: height * 0.07,
//               // width: width * 0.15,
//               // margin:
//               //     EdgeInsets.only(top: height * 0.691, left: width * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.03),
//                   color: Colors.red),
//               child: Image.asset('assets/images/privacy.png'),
//             ),
//
//             ///Privacy And Policy text
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.691, left: width * 0.3),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ///Text
//                   Container(
//                     child: Text(
//                       'Privacy & Policy',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'poppins',
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//
//                   ///Text_description
//                   Container(
//                     child: InkWell(
//                       onTap: (){
//                         launchUrl( Uri.parse("https://securedoorstudio.blogspot.com/2022/10/privacy-policy.html"), mode: LaunchMode.inAppWebView );
//
//                       },
//                       child: Text(
//                         'Click to read Privacy policy',
//                         style: TextStyle(
//                             fontFamily: 'poppins', color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///line
//             Container(
//               alignment: Alignment.center,
//               // margin: EdgeInsets.only(top: height * 0.782, left: width * 0.1),
//               // width: width * 0.8,
//               // height: height * 0.001,
//               color: Colors.yellow.shade700,
//             ),
//
//             ///LogOut Image
//             Container(
//               // height: height * 0.07,
//               // width: width * 0.15,
//               // margin:
//               //     EdgeInsets.only(top: height * 0.807, left: width * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.03),
//                   color: Colors.green),
//               child: Container(
//                 child: InkWell(
//                   onTap: () async {
//                     await DialogBackground(
//                       // barrierColor: Colors.cyan,
//
//                       dialog: AlertDialog(
//                         backgroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(width * 0.04),
//                           side: BorderSide(color: Colors.yellow.shade700),
//                         ),
//                         title: Text(
//                           "Delete Account?",
//                           style: TextStyle(
//                               fontFamily: 'poppins', color: Colors.white),
//                         ),
//                         content: Text(
//                           "Are you sure want to delete ?",
//                           style: TextStyle(
//                               fontFamily: 'poppins', color: Colors.white),
//                         ),
//                         actions: <Widget>[
//                           ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                         color: Colors.yellow.shade700),
//                                     borderRadius:
//                                     BorderRadius.circular(width * 0.012),
//                                   )),
//                               child: Text(
//                                 "Delete",
//                                 style: TextStyle(
//                                     fontFamily: 'poppins',
//                                     color: Colors.white),
//                               ),
//                               onPressed: () async{
//                                 await FirebaseAuthMethods(FirebaseAuth.instance).deleteAccount(context);
//                                 await storage.delete(key: "uid");
//                                 Get.off(logInFormSTL());
//                               }),
//                           ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                         color: Colors.yellow.shade700),
//                                     borderRadius:
//                                     BorderRadius.circular(width * 0.012),
//                                   )),
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                     fontFamily: 'poppins',
//                                     color: Colors.white),
//                               ),
//                               onPressed: () {
//                                 Get.back();
//                               }),
//                         ],
//                       ),
//                     ).show(context);
//                   },
//                   child: Container(
//                     child: Image.asset('assets/images/logoutEdit.png'),
//                   ),
//                 ),
//               ),
//             ),
//
//             ///LogOut text
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.807, left: width * 0.3),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ///Text
//                   Container(
//                     child: Text(
//                       'Delete Account',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'poppins',
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//
//                   ///Text_description
//                   Container(
//                     child: InkWell(
//                       onTap: () async {
//                         await DialogBackground(
//                           // barrierColor: Colors.cyan,
//
//                           dialog: AlertDialog(
//                             backgroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.circular(width * 0.04),
//                               side: BorderSide(color: Colors.yellow.shade700),
//                             ),
//                             title: Text(
//                               "Delete Account?",
//                               style: TextStyle(
//                                   fontFamily: 'poppins', color: Colors.white),
//                             ),
//                             content: Text(
//                               "Are you sure want to delete account?",
//                               style: TextStyle(
//                                   fontFamily: 'poppins', color: Colors.white),
//                             ),
//                             actions: <Widget>[
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.black,
//                                       shape: RoundedRectangleBorder(
//                                         side: BorderSide(
//                                             color: Colors.yellow.shade700),
//                                         borderRadius: BorderRadius.circular(
//                                             width * 0.012),
//                                       )),
//                                   child: Text(
//                                     "Delete",
//                                     style: TextStyle(
//                                         fontFamily: 'poppins',
//                                         color: Colors.white),
//                                   ),
//                                   onPressed: () {
//                                     FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
//                                   }),
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.black,
//                                       shape: RoundedRectangleBorder(
//                                         side: BorderSide(
//                                             color: Colors.yellow.shade700),
//                                         borderRadius: BorderRadius.circular(
//                                             width * 0.012),
//                                       )),
//                                   child: Text(
//                                     "Cancel",
//                                     style: TextStyle(
//                                         fontFamily: 'poppins',
//                                         color: Colors.white),
//                                   ),
//                                   onPressed: () {
//                                     Get.back();
//                                   }),
//                             ],
//                           ),
//                         ).show(context);
//                       },
//                       child: Text(
//                         'Delete this account',
//                         style: TextStyle(
//                             fontFamily: 'poppins', color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             ///line
//             Container(
//               alignment: Alignment.center,
//               // margin: EdgeInsets.only(top: height * 0.897, left: width * 0.1),
//               // // width: width * 0.8,
//               // // height: height * 0.001,
//               color: Colors.yellow.shade700,
//             ),
//
//             ///Banner
//             Container(
//               // margin: EdgeInsets.only(top: height * 0.905),
//               child: FacebookBannerAd(
//                 placementId: "781313709744134_781317063077132",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
