
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/sizedbox.dart';
import 'package:start_and_earn/components/text_style.dart';
import 'package:start_and_earn/rules.dart';
import 'package:start_and_earn/setting_screen.dart';
import 'package:start_and_earn/user_dashboard.dart';
import 'package:start_and_earn/widgets/listTile.dart';
import 'package:start_and_earn/winnersScreen.dart';
import 'package:start_and_earn/withDrawal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SpinWheel.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'matching_game.dart';
import 'memory.dart';

class HomeScreenSTL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreenSTF();
  }
}

class HomeScreenSTF extends StatefulWidget {
  const HomeScreenSTF({Key? key}) : super(key: key);
  @override
  _HomeScreenSTFState createState() => _HomeScreenSTFState();
}

class _HomeScreenSTFState extends State<HomeScreenSTF> {
  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  ///Ads
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

  ///load video
  Future<void> _loadRewardedVideoAd() async {
    await FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "781313709744134_834060271136144",
    );
    await FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: "781313709744134_781317496410422",
    );
   await FacebookRewardedVideoAd.loadRewardedVideoAd(
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

  ///Drawer
  final _advancedDrawerController = AdvancedDrawerController();
  late double width;
  late double height;
  final firedatabase = FirebaseFirestore.instance.collection("Users_Locations");
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UnityAds.init(
      gameId: AdManager.gameId,
      // onComplete: () {
      //   print('Initialization Complete');
      // },
      // onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );

    ///Facebook ads init
    /// please add your own device testingId
    /// (testingId will print in console if you don't provide  )
    FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,

    );
    getImg();
    _loadRewardedVideoAd;
    _loadInterstitialAd;
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
    ///App Update Firebase
    // try{
    //   widget.remoteConfig.setConfigSettings(RemoteConfigSettings(
    //       fetchTimeout: Duration(seconds: 10),
    //       minimumFetchInterval: Duration.zero)
    //   );
    //   widget.remoteConfig.fetchAndActivate();
    //   setState(() {
    //
    //   });
    // }catch(e){
    //   print(e.toString());
    // };
    UnityAds.load(placementId: 'Interstitial_Android');
  }
///Image Picker
//   File? Getimage;
  String getUserImage = "";
  // Future<dynamic> pickImage()async{
  //   try{
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if(image == null)return;
  //     final imageTemporary = File(image.path);
  //     print(imageTemporary);
  //     setState(() {
  //       Getimage = imageTemporary;
  //
  //     });
  //     /// FireStorage
  //     final ref = FirebaseStorage.instance.ref().child("Users_Profiles_Pick").child(FirebaseAuth.instance.currentUser!.uid);
  //     UploadTask uploadTask = ref.putFile(Getimage!);
  //     TaskSnapshot imageSnapshot = await uploadTask;
  //     String ImgDownLink = await imageSnapshot.ref.getDownloadURL();
  //     await database.child("User").child(FirebaseAuth.instance.currentUser!.uid).update(
  //         {
  //           "Image_URL" : ImgDownLink.toString(),
  //         });
  //   }catch (e){
  //     print(e);
  //   }
  // }
  ///Firebase Database Img Get
  late DataSnapshot snapshot;
  void getImg()async{
    snapshot = await database.child("Users").child(FirebaseAuth.instance.currentUser!.uid).get();
    if(snapshot.exists){
      print(snapshot.value);
    }
    Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
    setState(() {
      getUserImage = map['profilePhoto'];
    });
  }

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
///
  final database = FirebaseDatabase.instance.ref();
///aPP uPDATER
//
//   Widget cancel = ElevatedButton(onPressed: (){
//     Get.off(logInFormSTL());
//   }, child: Text("Cancel"));
//   Widget update = ElevatedButton(onPressed: (){
//
//     launchUrl( Uri.parse("https://drive.google.com/drive/folders/1zxWhX39XkTGR_Ntf4Xa2maTH8vMQRAlH"), mode: LaunchMode.inAppWebView );
//
//   }, child: Text("Update"));
//   AlertDialog shoAlertDialog(BuildContext context, FirebaseRemoteConfig remoteConfig){
//     return AlertDialog(
//       title: Text(remoteConfig.getString("Title")),
//       content: Text(remoteConfig.getString("Message")),
//       actions: <Widget>[
//         cancel,
//         update
//       ],
//     );
//   }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return AdvancedDrawer(
      backdropColor: bgColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Free Earn',
            style: TextStyle(fontFamily: 'poppins', color: mainColor,fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    color: mainColor,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              ///Slider
              Container(
                child: ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: Colors.white,
                  indicatorBackgroundColor: Colors.grey,
                  onPageChanged: (value) {
                    // debugPrint('Page changed: $value');
                  },
                  autoPlayInterval: 6000,
                  isLoop: true,
                  children: [
                    Image.asset(
                      'assets/images/battleground_neon_1.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/cigar-chips-gamblings-drink-playing-cards.jpg',
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/doomsday-scene-catastrophe-digital-illustration.jpg',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              ///changing
              //
              // ///Pubg
              // Container(
              //   child: Stack(
              //     children: [
              //       ///Pubg
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.35, left: width * 0.02),
              //         child: Stack(
              //           children: [
              //             /// border
              //             Container(
              //               width: width * 0.47,
              //               height: height * 0.228,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.circular(width * 0.05),
              //                   border:
              //                       Border.all(color: mainColor)),
              //             ),
              //
              //             ///Text
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.13, left: width * 0.04),
              //               child: Text(
              //                 'Pubg',
              //                 style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                     fontSize: 22),
              //               ),
              //             ),
              //
              //             ///Icon And Views
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.18, left: width * 0.04),
              //               child: Row(
              //                 children: [
              //                   ///ICon
              //                   Container(
              //                     child: Icon(
              //                       Icons.remove_red_eye_sharp,
              //                       size: 20,
              //                       color: mainColor,
              //                     ),
              //                   ),
              //
              //                   ///Review
              //                   Container(
              //                     margin: EdgeInsets.only(left: width * 0.02),
              //                     child: Text(
              //                       '36k  Views',
              //                       style: TextStyle(
              //                           fontFamily: 'poppins',
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //
              //             ///Play Button
              //             Container(
              //               height: height * 0.052,
              //               width: width * 0.112,
              //               margin: EdgeInsets.only(
              //                   top: height * 0.15, left: width * 0.326),
              //               decoration: BoxDecoration(
              //                   color: mainColor,
              //                   borderRadius: BorderRadius.circular(width)),
              //               child: InkWell(
              //                 onTap: (){
              //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>PubgDetails()));
              //                 },
              //                 child: Icon(
              //                   Icons.play_arrow_rounded,
              //                   color: Colors.white,
              //                   size: 32,
              //                   shadows: [Shadow(color: Colors.black)],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       ///Image Pubg
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.27, left: width * 0.05),
              //         height: height * 0.2,
              //         child: Image.asset('assets/images/pubg-banner.png'),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // ///Free Fire
              // Container(
              //   child: Stack(
              //     children: [
              //       ///free fire
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.35, left: width * 0.511),
              //         child: Stack(
              //           children: [
              //             /// border
              //             Container(
              //               width: width * 0.47,
              //               height: height * 0.228,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.circular(width * 0.05),
              //                   border:
              //                       Border.all(color: mainColor)),
              //             ),
              //
              //             ///Text
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.13, left: width * 0.04),
              //               child: Text(
              //                 'Free Fire',
              //                 style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                     fontSize: 22),
              //               ),
              //             ),
              //
              //             ///Icon And Views
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.18, left: width * 0.04),
              //               child: Row(
              //                 children: [
              //                   ///ICon
              //                   Container(
              //                     child: Icon(
              //                       Icons.remove_red_eye_sharp,
              //                       size: 20,
              //                       color: mainColor,
              //                     ),
              //                   ),
              //
              //                   ///Review
              //                   Container(
              //                     margin: EdgeInsets.only(left: width * 0.02),
              //                     child: Text(
              //                       '22k  Views',
              //                       style: TextStyle(
              //                           fontFamily: 'poppins',
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //
              //             ///Play Button
              //             Container(
              //               height: height * 0.052,
              //               width: width * 0.112,
              //               margin: EdgeInsets.only(
              //                   top: height * 0.15, left: width * 0.326),
              //               decoration: BoxDecoration(
              //                   color: mainColor,
              //                   borderRadius: BorderRadius.circular(width)),
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>freeFireDetails()));
              //
              //                 },
              //                 child: Icon(
              //                   Icons.play_arrow_rounded,
              //                   color: Colors.white,
              //                   size: 32,
              //                   shadows: [Shadow(color: Colors.black)],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       ///Image free fire
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.27, left: width * 0.52),
              //         height: height * 0.2,
              //         child: Image.asset(
              //             'assets/images/Garena-Free-Fire-PNG-Background.png'),
              //       ),
              //
              //       ///freefire img
              //       Container(
              //         margin: EdgeInsets.only(
              //             left: width * 0.56, top: height * 0.416),
              //         width: width * 0.37,
              //         child: Image.asset(
              //             'assets/images/yellloow_Logo_of_Garena_Free_Fire.png'),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // ///Ludo
              // Container(
              //   child: Stack(
              //     children: [
              //       ///ludo
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.65, left: width * 0.02),
              //         child: Stack(
              //           children: [
              //             /// border
              //             Container(
              //               width: width * 0.47,
              //               height: height * 0.228,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.circular(width * 0.05),
              //                   border:
              //                       Border.all(color: mainColor)),
              //             ),
              //
              //             ///Text
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.13, left: width * 0.04),
              //               child: Text(
              //                 'Ludo',
              //                 style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                     fontSize: 22),
              //               ),
              //             ),
              //
              //             ///Icon And Views
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.18, left: width * 0.04),
              //               child: Row(
              //                 children: [
              //                   ///ICon
              //                   Container(
              //                     child: Icon(
              //                       Icons.remove_red_eye_sharp,
              //                       size: 20,
              //                       color: mainColor,
              //                     ),
              //                   ),
              //
              //                   ///Review
              //                   Container(
              //                     margin: EdgeInsets.only(left: width * 0.02),
              //                     child: Text(
              //                       '19k  Views',
              //                       style: TextStyle(
              //                           fontFamily: 'poppins',
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //
              //             ///Play Button
              //             Container(
              //               height: height * 0.052,
              //               width: width * 0.112,
              //               margin: EdgeInsets.only(
              //                   top: height * 0.15, left: width * 0.326),
              //               decoration: BoxDecoration(
              //                   color: mainColor,
              //                   borderRadius: BorderRadius.circular(width)),
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ludoDetails()));
              //
              //                 },
              //                 child: Icon(
              //                   Icons.play_arrow_rounded,
              //                   color: Colors.white,
              //                   size: 32,
              //                   shadows: [Shadow(color: Colors.black)],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       ///ludo Pubg
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.56, left: width * 0.05),
              //         height: height * 0.2,
              //         child: Image.asset(
              //             'assets/images/—Pngtree—cartoon element golden yellow dice_5754662.png'),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // ///Teen Patti Gold
              // Container(
              //   child: Stack(
              //     children: [
              //       ///Teen Patti Gold
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.65, left: width * 0.511),
              //         child: Stack(
              //           children: [
              //             /// border
              //             Container(
              //               width: width * 0.47,
              //               height: height * 0.228,
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                       BorderRadius.circular(width * 0.05),
              //                   border:
              //                       Border.all(color: mainColor)),
              //             ),
              //
              //             ///Text
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.13, left: width * 0.04),
              //               child: Text(
              //                 'Teen Patti',
              //                 style: TextStyle(
              //                     fontFamily: 'poppins',
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                     fontSize: 22),
              //               ),
              //             ),
              //
              //             ///Icon And Views
              //             Container(
              //               margin: EdgeInsets.only(
              //                   top: height * 0.18, left: width * 0.04),
              //               child: Row(
              //                 children: [
              //                   ///ICon
              //                   Container(
              //                     child: Icon(
              //                       Icons.remove_red_eye_sharp,
              //                       size: 20,
              //                       color: mainColor,
              //                     ),
              //                   ),
              //
              //                   ///Review
              //                   Container(
              //                     margin: EdgeInsets.only(left: width * 0.02),
              //                     child: Text(
              //                       '22k  Views',
              //                       style: TextStyle(
              //                           fontFamily: 'poppins',
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w500),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //
              //             ///Play Button
              //             Container(
              //               height: height * 0.052,
              //               width: width * 0.112,
              //               margin: EdgeInsets.only(
              //                   top: height * 0.15, left: width * 0.326),
              //               decoration: BoxDecoration(
              //                   color: mainColor,
              //                   borderRadius: BorderRadius.circular(width)),
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>TeenPattiDetails()));
              //
              //                 },
              //                 child: Icon(
              //                   Icons.play_arrow_rounded,
              //                   color: Colors.white,
              //                   size: 32,
              //                   shadows: [Shadow(color: Colors.black)],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       ///Image Teen Patti Gold
              //       Container(
              //         margin: EdgeInsets.only(
              //             top: height * 0.594, left: width * 0.602),
              //         height: height * 0.14,
              //         child: Image.asset('assets/images/3 patti gold.png'),
              //       ),
              //     ],
              //   ),
              // ),
              sizeHeight30,
              ///Text
              Container(
                margin: kPaddingHorizontal20,
                child: RichText(
                  text: TextSpan(
                    text: 'All ',
                    style: txtStyle22AndBold,
                    children: [
                      TextSpan(
                        text: 'Catogaries',
                        style: txtStyle22AndMainBold,
                      )
                    ]
                  ),
                ),
              ),
              sizeHeight20,
              ///Tasks
              Container(
                margin:kPaddingHorizontal20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Daily TAsk

                    ///spin
                    ///Spins
                    Container(
                      child: Column(
                        children: [
                          ///wheel
                          Container(
                            child: InkWell(
                              onTap: ()async{
                               //  await FacebookRewardedVideoAd.loadRewardedVideoAd(
                               //    placementId: "781313709744134_834060271136144",
                               //  );
                               //  await FacebookRewardedVideoAd.loadRewardedVideoAd(
                               //    placementId: "781313709744134_781317496410422",
                               //  );
                               //  await FacebookRewardedVideoAd.showRewardedVideoAd();
                               //  await UnityAds.showVideoAd(
                               //    placementId: "Video_Android",
                               //    onComplete: (placementId){
                               //      print("Ads is Completed by $placementId ok");
                               //      Get.offNamed('/home/withDraw');
                               //    },
                               //
                               //  );
                               // Get.offNamed('/home/pubgDetails/Spins');
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SpinWheel()));

                              },
                              child: Image.asset('assets/images/spin_gif.gif',
                                height: 80,
                              ),
                            ),
                          ),
                          sizeHeight10,
                          ///Text
                          Container(
                            child: Text('Spin',
                              style: txtStyle16AndBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Memory game
                    Container(
                      child: Column(
                        children: [
                          ///Memory Game
                          Container(
                            child: InkWell(
                              onTap: () async {
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_834060271136144",
                                );
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_781317496410422",
                                );
                                await FacebookRewardedVideoAd.showRewardedVideoAd();
                                await UnityAds.showVideoAd(
                                  placementId: "Video_Android",
                                  onComplete: (placementId){
                                    print("Ads is Completed by $placementId ok");
                                    Get.offNamed('/home/withDraw');
                                  },

                                );
                                Get.offNamed('/home/pubgDetails/memoryGame');
                              },
                              child: Image.asset('assets/images/memory-game_gif.gif',
                                height: 80,
                              ),
                            ),
                          ),
                          sizeHeight10,
                          ///Text
                          Container(
                            child: Text('Memory',
                              style: txtStyle16AndBold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              sizeHeight15,
              ///Tasks 2 Row
              Container(
                margin: kPaddingHorizontal20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Rock,paper,scccesor
                    Container(
                      // margin: EdgeInsets.only(top: height*0.56),
                      child: Column(
                        children: [
                          ///Rock,paper and sccesor
                          Container(

                            child: InkWell(
                              onTap: () async {
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_834060271136144",
                                );
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_781317496410422",
                                );
                                await FacebookRewardedVideoAd.showRewardedVideoAd();
                                await UnityAds.showVideoAd(
                                  placementId: "Video_Android",
                                  onComplete: (placementId){
                                    print("Ads is Completed by $placementId ok");
                                    Get.offNamed('/home/withDraw');
                                  },

                                );
                               Get.offNamed('/home/pubgDetails/Rock,paper');

                              },
                              child: Image.asset('assets/images/rockGameGif.gif',
                                height: 80,
                              ),
                            ),
                          ),
                          sizeHeight10,
                          ///Text
                          Container(
                            child: Text('R, P & S',
                              style: txtStyle16AndBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Drag and drop
                    Container(
                      child: Column(
                        children: [
                          ///Drag and droop
                          Container(
                            child: InkWell(
                              onTap: () async {
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_834060271136144",
                                );
                                await FacebookRewardedVideoAd.loadRewardedVideoAd(
                                  placementId: "781313709744134_781317496410422",
                                );
                                await FacebookRewardedVideoAd.showRewardedVideoAd();
                                await UnityAds.showVideoAd(
                                  placementId: "Video_Android",
                                  onComplete: (placementId){
                                    print("Ads is Completed by $placementId ok");
                                    Get.offNamed('/home/withDraw');
                                  },

                                );
                               Get.offNamed('/home/pubgDetails/matching_game');

                              },
                              child: Image.asset('assets/images/drag and drop gif.gif',
                                height: 80
                              ),
                            ),
                          ),
                          sizeHeight10,
                          ///Text
                          Container(
                            child: Text('Drag & Drop',
                              style: txtStyle16AndBold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
                  sizeHeight20,
              ///ads
              ///Banner
              Container(
                  // margin: EdgeInsets.only(top: height*0.75),

                  child: FacebookBannerAd(
                    placementId: "781313709744134_781317063077132",

                  )
              ),
                  sizeHeight20,

              ///Banner2
              Container(
                // margin: EdgeInsets.only(top: height*0.92),

                child: UnityBannerAd(

                  placementId: "Banner_Ad_Android",
                ),
              ),
            ]),
          ),
        ),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                sizeHeight20,
                Text("Good morning",
                  style: txtStyle14AndMainBold,),
                sizeHeight15,
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(getUserImage.toString()),
                ),
                sizeHeight10,
                Text("Umer Ferrari",
                  style: txtStyle16AndBold,),
                spacer,
                ///All ListTile
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // ListTile(
                    //   onTap: () async {
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_834060271136144",
                    //     );
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_781317496410422",
                    //     );
                    //     await FacebookRewardedVideoAd.showRewardedVideoAd();
                    //     Get.offNamed('/home');
                    //     await UnityAds.showVideoAd(
                    //         placementId: "Video_Android",
                    //       onComplete: (placementId){
                    //         print("Ads is Completed by $placementId ok");
                    //         Get.offNamed('/home');
                    //
                    //       },
                    //
                    //     );
                    //   },
                    //   leading: Icon(Icons.home, color: mainColor),
                    //   title: Text('Home'),
                    // ),
                    // divider,
                    listTileLeadWidgetAndTitleTextString(
                        onTap: () async {
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_834060271136144",
                          // );
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_781317496410422",
                          // );
                          // await FacebookRewardedVideoAd.showRewardedVideoAd();
                          // Get.offNamed('/home/winners');
                          //
                          // await UnityAds.showVideoAd(
                          //   placementId: "Video_Android",
                          //   onComplete: (placementId){
                          //     print("Ads is Completed by $placementId ok");
                          //     Get.offNamed('/home/winners');
                          //   },
                          //
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => userDashboard()));

                        },
                        title: 'Dashboard',
                        lead: Icon(Icons.dashboard, color: mainColor)
                    ),
                    divider,
                    listTileLeadWidgetAndTitleTextString(
                        onTap: () async {
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_834060271136144",
                          // );
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_781317496410422",
                          // );
                          // await FacebookRewardedVideoAd.showRewardedVideoAd();
                          // Get.offNamed('/home/winners');
                          //
                          // await UnityAds.showVideoAd(
                          //   placementId: "Video_Android",
                          //   onComplete: (placementId){
                          //     print("Ads is Completed by $placementId ok");
                          //     Get.offNamed('/home/winners');
                          //   },
                          //
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => winnerScreen()));

                        },
                        title: 'Today Winners',
                        lead: Icon(Icons.ac_unit, color: mainColor)
                    ),
                    // ListTile(
                    //   onTap: () async {
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_834060271136144",
                    //     );
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_781317496410422",
                    //     );
                    //     await FacebookRewardedVideoAd.showRewardedVideoAd();
                    //     Get.offNamed('/home/winners');
                    //
                    //     await UnityAds.showVideoAd(
                    //       placementId: "Video_Android",
                    //       onComplete: (placementId){
                    //         print("Ads is Completed by $placementId ok");
                    //         Get.offNamed('/home/winners');
                    //       },
                    //
                    //     );
                    //
                    //
                    //   },
                    //   leading: Icon(Icons.ac_unit, color: mainColor),
                    //   title: Text('Today Winners'),
                    // ),
                    divider,
                    listTileLeadWidgetAndTitleTextString(
                        onTap: () async {
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_834060271136144",
                          // );
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_781317496410422",
                          // );
                          // await FacebookRewardedVideoAd.showRewardedVideoAd();
                          // await UnityAds.showVideoAd(
                          //   placementId: "Video_Android",
                          //   onComplete: (placementId){
                          //     print("Ads is Completed by $placementId ok");
                          //     Get.offNamed('/home/rules');
                          //   },
                          // );
                          // Get.offNamed('/home/rules');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => rulesSTL()));

                        },
                        title: 'Rules',
                        lead: Icon(Icons.rule, color: mainColor)
                    ),
                    // ListTile(
                    //   onTap: () async {
                    //           await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_834060271136144",
                    //     );
                    //           await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_781317496410422",
                    //     );
                    //           await FacebookRewardedVideoAd.showRewardedVideoAd();
                    //           await UnityAds.showVideoAd(
                    //             placementId: "Video_Android",
                    //             onComplete: (placementId){
                    //               print("Ads is Completed by $placementId ok");
                    //               Get.offNamed('/home/rules');
                    //             },
                    //           );
                    //     Get.offNamed('/home/rules');
                    //   },
                    //   leading: Icon(Icons.rule, color: mainColor),
                    //   title: Text('Rules'),
                    // ),
                    divider,
                    listTileLeadWidgetAndTitleTextString(
                        onTap: () async {
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_834060271136144",
                          // );
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_781317496410422",
                          // );
                          // await FacebookRewardedVideoAd.showRewardedVideoAd();
                          // Get.offNamed('/home/withDraw');
                          // await UnityAds.showVideoAd(
                          //   placementId: "Video_Android",
                          //   onComplete: (placementId){
                          //     print("Ads is Completed by $placementId ok");
                          //     Get.offNamed('/home/withDraw');
                          //   },
                          //
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => withDrawal()));

                        },
                        title: 'WithDraw',
                        lead: Icon(Icons.account_balance_wallet,
                            color: mainColor)
                    ),
                    // ListTile(
                    //   onTap: () async {
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_834060271136144",
                    //     );
                    //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                    //       placementId: "781313709744134_781317496410422",
                    //     );
                    //     await FacebookRewardedVideoAd.showRewardedVideoAd();
                    //     Get.offNamed('/home/withDraw');
                    //     await UnityAds.showVideoAd(
                    //       placementId: "Video_Android",
                    //       onComplete: (placementId){
                    //         print("Ads is Completed by $placementId ok");
                    //         Get.offNamed('/home/withDraw');
                    //       },
                    //
                    //     );
                    //
                    //   },
                    //   leading: Icon(Icons.account_balance_wallet,
                    //       color: mainColor),
                    //   title: Text('WithDraw'),
                    // ),
                    divider,
                    listTileLeadWidgetAndTitleTextString(
                        onTap: () async {
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_834060271136144",
                          // );
                          // await FacebookRewardedVideoAd.loadRewardedVideoAd(
                          //   placementId: "781313709744134_781317496410422",
                          // );
                          // await FacebookRewardedVideoAd.showRewardedVideoAd();
                          // Get.offNamed('/home/DashBoard');
                          // await UnityAds.showVideoAd(
                          //   placementId: "Video_Android",
                          //   onComplete: (placementId){
                          //     print("Ads is Completed by $placementId ok");
                          //     Get.offNamed('/home/DashBoard');
                          //   },
                          //
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));

                        },
                        title: 'Settings',
                        lead: Icon(Icons.settings, color: mainColor)
                    ),
                    divider,
                  ],
                ),
                // ListTile(
                //   onTap: () async {
                //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                //       placementId: "781313709744134_834060271136144",
                //     );
                //     await FacebookRewardedVideoAd.loadRewardedVideoAd(
                //       placementId: "781313709744134_781317496410422",
                //     );
                //     await FacebookRewardedVideoAd.showRewardedVideoAd();
                //     Get.offNamed('/home/DashBoard');
                //     await UnityAds.showVideoAd(
                //       placementId: "Video_Android",
                //       onComplete: (placementId){
                //         print("Ads is Completed by $placementId ok");
                //        Get.offNamed('/home/DashBoard');
                //       },
                //
                //     );
                //
                //   },
                //   leading: Icon(Icons.settings, color: mainColor),
                //   title: Text('Settings'),
                // ),
                spacer,
                Container(
                  child: FacebookBannerAd(
                    placementId: "781313709744134_781317063077132",
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Terms & Conditions
                        Container(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: mainColor,
                            ),
                            onPressed: (){
                              launchUrl( Uri.parse("https://securedoorstudio.blogspot.com/2022/10/terms-conditions.html"), mode: LaunchMode.inAppWebView );
                            },
                            child: Text("Terms & Conditions ", style: txtStyle12AndMainBold,),
                          ),
                        ),
                        ///Text
                        Text(" | "),
                        ///Privacy Policy
                        Container(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: mainColor,
                            ),
                            onPressed: (){
                              launchUrl( Uri.parse("https://securedoorstudio.blogspot.com/2022/10/privacy-policy.html"), mode: LaunchMode.inAppWebView );
                            },
                            child: Text(" Privacy Policy", style: txtStyle12AndMainBold,),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

}
