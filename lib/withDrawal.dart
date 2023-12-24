import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:customizable_dropdown/customizable_dropdown.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:start_and_earn/components/sizedbox.dart';
import 'package:start_and_earn/widgets/appbar.dart';
import 'package:start_and_earn/widgets/button.dart';
import 'package:start_and_earn/widgets/check_coin_balance.dart';
import 'package:start_and_earn/widgets/textfield.dart';
import 'package:start_and_earn/widgets/toast.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'HomeScreen.dart';
import 'Provider/withdraw_provider.dart';
import 'SpinWheel.dart';
import 'components/colors.dart';
import 'components/text_style.dart';


class withDrawal extends StatelessWidget {
  const withDrawal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: appBarJustLead(context: context,titleText: "Withdrawal"),
        body: withDrawalSTF(),
      ),
    );
  }
}
///stf
class withDrawalSTF extends StatefulWidget {
  const withDrawalSTF({Key? key}) : super(key: key);

  @override
  State<withDrawalSTF> createState() => _withDrawalSTFState();
}

class _withDrawalSTFState extends State<withDrawalSTF> {
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
  late double width;
  late double height;
  ///Firebase sent id and categaries withdraw
  TextEditingController rewardController = TextEditingController();
  TextEditingController holderController = TextEditingController();
  // TextEditingController playerID = TextEditingController();
  TextEditingController categories = TextEditingController();
  TextEditingController coinController = TextEditingController();
  ///input feild data sent firebase
  // void inputDataSent()async{
  //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).set(
  //       {
  //         "Player_ID": "playerID",
  //         "Game_Name": "categories",
  //         "Old_Coins": 0,
  //         "New_Coins": 0,
  //
  //       });
  // }
  ///Firebase Firestore
  final cdatabase = FirebaseFirestore.instance.collection("Withdraw");
  String name = '';
  String email = '';
  void insertDataFirestore()async{
    snapshot = await database.child('User').child(FirebaseAuth.instance.currentUser!.uid).get();
    if(snapshot.exists){
      print(snapshot.value);
    }
    Map <dynamic,dynamic> map = snapshot.value as Map <dynamic,dynamic>;
    setState(() {
      name = map['name'];
      email = map['email'];
    });
  }
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    //deleteCoins();
    coins_data();
    insertDataFirestore();
    Permissions();
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
  }
  ///Firebase real time

  late DataSnapshot snapshot;

  final database = FirebaseDatabase.instance.ref();
int showCoins = 0 ;

  Future coins_data()async{
  snapshot = await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
  if(snapshot.exists){
    print(snapshot.value);
    Map <dynamic,dynamic> map = snapshot.value as Map <dynamic,dynamic>;
  setState(() {
    showCoins= map['Current_Coins'];
  });

  }
  }
  ///dropdown
  List<String> dropdownList = [
    'Pubg UC',
    'FreeFire Diamonds',
    'Ludo Coins',
    '3 Patti Gold Chips',
  ];
  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  ///google map geolocator
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  //   required;
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
  //       Permissions();
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     Permissions();
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }
  String selectedValue = "";
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return hideUi? Container(
      // margin: EdgeInsets.only(top: height*0.3),
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
    ) : Consumer<WithdrawProvider>(
      builder: (context,withdrawProvider,child){
        return Container(
          child: SingleChildScrollView(
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
                  ///Check Balance
                  checkCoinBalanceFun(context: context),
                  sizeHeight15,
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Choose Reward",
                        style: txtStyle12AndBold,
                      )),
                  sizeHeight10,
                  // DropdownButtonHideUnderline(
                  //   child: SizedBox(
                  //     width: width,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: kBorderRadius10,
                  //         border: Border.all(
                  //             color: otherColor,
                  //             width: 0.2
                  //         ),
                  //       ),
                  //       padding: kPaddingHorizontal20,
                  //       child: DropdownButton<String>(
                  //         value: selectedValue,
                  //         dropdownColor: blackOtherColor,
                  //         iconEnabledColor: mainColor,
                  //         hint: Text("Select Reward"),
                  //         onChanged: (String? newValue) {
                  //           setState(() {
                  //             selectedValue = newValue!;
                  //             print(selectedValue);
                  //           });
                  //         },
                  //         items: <String>[
                  //           '',
                  //           'JazzCash',
                  //           'EasyPaisa',
                  //           'Pubg UC',
                  //           'Free Fire Diamond',
                  //         ].map<DropdownMenuItem<String>>((String value) {
                  //           return DropdownMenuItem<String>(
                  //
                  //             value: value,
                  //             child: Text(value,style: txtStyle14,),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  DropdownButtonHideUnderline(
                    child: SizedBox(
                      width: width,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: otherColor,
                            width: 0.2,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButton<String>(
                          value: selectedValue.isNotEmpty ? selectedValue : null, // Check if selectedValue is not empty
                          dropdownColor: blackOtherColor,
                          iconEnabledColor: mainColor,
                          hint: Text("Select Reward",style: txtStyle14,),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedValue = newValue;
                                print(selectedValue);
                              });
                            }
                          },
                          items: <String>[
                            'JazzCash',
                            'EasyPaisa',
                            'Pubg UC',
                            'Free Fire Diamond',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.isNotEmpty ? value : "Select Reward", // Show hint text for empty value
                                style: TextStyle(fontSize: 14,color: textColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  selectedValue == ""? Container() : sizeHeight15,
                  ///Account number && Player ID
                  selectedValue == ""? Container() : Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        selectedValue == "JazzCash" || selectedValue == "EasyPaisa"?
                        "Account Number"
                            :
                        selectedValue == "Pubg UC" || selectedValue == "Free Fire Diamond"?
                        "Player ID"
                            :
                        "",

                        style: txtStyle12AndBold,
                      )),
                  selectedValue == ""? Container() : sizeHeight10,
                  selectedValue == "JazzCash" || selectedValue == "EasyPaisa"?
                  TextFormField(
                    controller: rewardController,
                    cursorColor: mainColor,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10), // Limit the input to 10 characters
                    ],
                    // toolbarOptions: ToolbarOptions(),
                    style: txtStyle14,
                    keyboardType: TextInputType.number,
                    onChanged: (e){
                      withdrawProvider.storePhoneNumberFun(value: e);
                    },
                    decoration: InputDecoration(
                      counterText: "${withdrawProvider.storePhoneNumber.length} / 10",
                      counterStyle: txtStyle12AndMainBold,
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 60,
                        maxWidth: 60,
                      ),
                      prefixIcon:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            child: Text(
                              '+92',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      hintText: "Number Format 3XXXXXXXXX without 0",
                      hintStyle: txtStyle12AndOther,
                      border: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide:  BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      // suffixIcon: suffixIcon?? Container(),
                    ),
                  )
                      :
                  selectedValue == "Pubg UC" || selectedValue == "Free Fire Diamond"?
                  TextFormField(
                    controller: rewardController,
                    cursorColor: mainColor,
                    maxLines: 1,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    // toolbarOptions: ToolbarOptions(),
                    style: txtStyle14,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      hintText: "Enter Player ID",
                      hintStyle: txtStyle12AndOther,
                      border: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide:  BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      // suffixIcon: suffixIcon?? Container(),
                    ),
                  )
                  :
                  Container(),
                  selectedValue == ""? Container() : sizeHeight15,
                  ///Account holder && Player Name

                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        selectedValue == "JazzCash" || selectedValue == "EasyPaisa"?
                        "Holder Name"
                            :
                        selectedValue == "Pubg UC" || selectedValue == "Free Fire Diamond"?
                        "Player Name"
                        :
                        "",
                        style: txtStyle12AndBold,
                      )),
                  selectedValue == ""? Container() : sizeHeight10,
                  selectedValue == "JazzCash" || selectedValue == "EasyPaisa"?
                  TextFormField(
                    controller: holderController,
                    cursorColor: mainColor,
                    maxLines: 1,
                    style: txtStyle14,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      hintText: "Enter Holder Number",
                      hintStyle: txtStyle12AndOther,
                      border: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide:  BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                    ),
                  )
                      :
                  selectedValue == "Pubg UC" || selectedValue == "Free Fire Diamond"?
                  TextFormField(
                    controller: holderController,
                    cursorColor: mainColor,
                    maxLines: 1,
                    style: txtStyle14,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      hintText: "Enter Player Name",
                      hintStyle: txtStyle12AndOther,
                      border: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide:  BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                    ),
                  )
                      :
                  Container(),
                  selectedValue == ""? Container() :  sizeHeight15,
                  selectedValue == ""? Container() : Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Coins",
                        style: txtStyle12AndBold,
                      )),
                  selectedValue == ""? Container() : sizeHeight10,
                  selectedValue == ""? Container() : TextFormField(
                    controller: coinController,
                    cursorColor: mainColor,
                      keyboardType: TextInputType.number,
                    // toolbarOptions: ToolbarOptions(),
                    style: txtStyle14,
                    onChanged: (e){
                      print("object $e");
                      // withdrawProvider.storePhoneNumberFun(value: e);
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Coins",
                    contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      hintStyle: txtStyle12AndOther,
                      border: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide:  BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: kBorderRadius10,
                        borderSide: BorderSide(
                            color: otherColor, width: 0.2),
                      ),
                      // suffixIcon: suffixIcon?? Container(),
                    ),
                  ),
                  selectedValue == ""? Container() :  sizeHeight15,
                  /// TExt
                  Container(
                    // margin: EdgeInsets.only(top: height*0.6, left: width*0.081),
                    child: Text('Terms & Conditions',
                      style: txtStyle22AndMainBold,
                    ),
                  ),
                  sizeHeight15,

                  ///Rules
                  Container(
                    // margin: EdgeInsets.only(top: height*0.65, left: width*0.09),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// text1
                        RichText(
                          text: TextSpan(
                              text: "1. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "Your current id details should be correct.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /// text2
                        RichText(
                          text: TextSpan(
                              text: "2. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "You will get reward within 24 hours.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /// text3
                        RichText(
                          text: TextSpan(
                              text: "3. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "You will Withdrawal after Complete tasks.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /// text4
                        RichText(
                          text: TextSpan(
                              text: "4. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "If you enter the wrong number, you will be responsible for it.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /// text5
                        RichText(
                          text: TextSpan(
                              text: "5. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "If you come across any example, you can easily contact.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),
                        /// text6
                        RichText(
                          text: TextSpan(
                              text: "6. ",style: txtStyle16AndMainBold,
                              children: [
                                TextSpan(
                                  text: "For full Withdrawal information, you can read your Dashboard May Terms and Conditions.",
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),

                              ]
                          ),
                        ),


                      ],
                    ),
                  ),
                  sizeHeight15,
                  // textField(),
                  ///submit
                  button(
                      context: context,
                    onTap: (){
                        if(selectedValue == "" || rewardController.text.isEmpty || holderController.text.isEmpty || coinController.text.isEmpty){
                          // print("object")
                        AppToast.show("Please Enter All Fields");
                        }
                        else{

                        print("selectedValue--> $selectedValue Reward --> ${rewardController.text} holderController --> ${holderController.text} Coins --> ${coinController.text}");
                        }
                      // await UnityAds.showVideoAd(placementId: "Video_Android");
                      // await FacebookRewardedVideoAd.showRewardedVideoAd();
                      // snapshot = await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).get();
                      //
                      // ///
                      // if(showCoins >=0 && showCoins <= 4999 ){
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      //
                      //   print('not exists less 5000');
                      //   // SnackBar(content: Text('Your Coins  is < 300. You cannot exists'));
                      //   Get.showSnackbar(
                      //       GetSnackBar(
                      //         titleText: Text(
                      //           "Withdraw",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'poppins'
                      //           ),
                      //         ), duration: Duration(seconds: 35),messageText: Text(
                      //         "Your Coins  is < 5000. You cannot exists",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontFamily: 'poppins'
                      //         ),),));
                      // }
                      // else if(showCoins >= 5000 && showCoins <= 9999 ){
                      //   int result = showCoins -5000 ;
                      //   print(result = showCoins -5000);
                      //   await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                      //       {
                      //         "Current_Coins" : result
                      //       });
                      //   ///USer Coins sent firebase
                      //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).update(
                      //       {
                      //         "Player_ID":playerID.text,
                      //         "Game_Name": categories.text,
                      //         "Old_Coins": showCoins,
                      //         "User_Enter_Coin": coinDraw.text,
                      //         "New_Coins": result,
                      //         "Reward": "5000 "+categories.text,
                      //         "Email": email,
                      //
                      //       });
                      //   database.child("Today_Winners").child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Email" : email,
                      //         "Player_ID" : playerID.text,
                      //         "Reward" : "5000 " +categories.text,
                      //         "Game_Name" : categories.text,
                      //         "status" : "Pending",
                      //
                      //       });
                      //   ///FireStore
                      //   var timestamp =DateTime.now().toString();
                      //   await cdatabase.doc(timestamp).set({
                      //     "Name": name,
                      //     "Email": email,
                      //     "UID": FirebaseAuth.instance.currentUser!.uid,
                      //     "Player_ID": playerID.text,
                      //     "Game_Name": categories.text,
                      //     "Old_Coins": showCoins,
                      //     "User_Enter_Coin": coinDraw.text,
                      //     "New_Coins": result,
                      //     "Data_Time": timestamp,
                      //     "Reward": "5000 "+categories.text,
                      //
                      //
                      //   });
                      //   Get.showSnackbar(
                      //       GetSnackBar(
                      //         titleText: Text("Withdraw",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'poppins'
                      //           ),), duration: Duration(seconds: 35),
                      //         messageText: Text(
                      //           "Your are succesfully 5000 coins withdraw. You reward sent in your account within 24 hours. ThankYou"
                      //           ,
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontFamily: 'poppins'
                      //           ),
                      //         ),
                      //
                      //       ));
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      // }
                      // else if(showCoins >= 10000 && showCoins <= 14999 ){
                      //   int result1 = showCoins - 10000 ;
                      //   print(result1 = showCoins - 10000);
                      //   await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                      //       {
                      //
                      //         "Current_Coins": result1
                      //
                      //       });
                      //   ///USer Coins sent firebase
                      //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Player_ID": playerID.text,
                      //         "Game_Name": categories.text,
                      //         "Old_Coins": showCoins,
                      //         "User_Enter_Coin": coinDraw.text,
                      //         "New_Coins": result1,
                      //         "Reward": "10000 "+categories.text,
                      //         "Email": email,
                      //         "Data_and_Time": DateTime.now().toString(),
                      //
                      //       });
                      //   ///FireStore
                      //   var timestamp =DateTime.now().toString();
                      //   await cdatabase.doc(timestamp).set({
                      //     "Name": name,
                      //     "Email": email,
                      //     "UID": FirebaseAuth.instance.currentUser!.uid,
                      //     "Player_ID": playerID.text,
                      //     "Game_Name": categories.text,
                      //     "Old_Coins": showCoins,
                      //     "User_Enter_Coin": coinDraw.text,
                      //     "New_Coins": result1,
                      //     "Data_Time": timestamp,
                      //     "Reward": "10000 "+categories.text,
                      //     "Data_and_Time": DateTime.now().toString(),
                      //
                      //
                      //   });
                      //   database.child("Today_Winners").child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Email" : email,
                      //         "Player_ID" : playerID.text,
                      //         "Reward" : "10000 " +categories.text,
                      //         "Game_Name" : categories.text,
                      //         "status" : "Pending",
                      //
                      //       });
                      //   Get.showSnackbar(GetSnackBar(
                      //     titleText: Text("Withdraw",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: 'poppins'
                      //       ),),
                      //     duration: Duration(seconds: 35),
                      //     messageText: Text("Your are succesfully 10000 coins withdraw. You reward sent in your account within 24 hours. ThankYou"
                      //       ,
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontFamily: 'poppins'
                      //       ),
                      //     ),
                      //   ));
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      // }
                      // else if(showCoins >= 15000 && showCoins <= 19999 ){
                      //   int result7 = showCoins - 15000 ;
                      //   print(result7 = showCoins - 15000);
                      //   await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                      //       {
                      //
                      //         "Current_Coins": result7
                      //
                      //       });
                      //   ///USer Coins sent firebase
                      //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Player_ID": playerID.text,
                      //         "Game_Name": categories.text,
                      //         "Old_Coins": showCoins,
                      //         "User_Enter_Coin": coinDraw.text,
                      //         "New_Coins": result7,
                      //         "Reward": "15000 "+categories.text,
                      //         "Email": email,
                      //         "Data_and_Time": DateTime.now().toString(),
                      //
                      //       });
                      //   ///FireStore
                      //   var timestamp =DateTime.now().toString();
                      //   await cdatabase.doc(timestamp).set({
                      //     "Name": name,
                      //     "Email": email,
                      //     "UID": FirebaseAuth.instance.currentUser!.uid,
                      //     "Player_ID": playerID.text,
                      //     "Game_Name": categories.text,
                      //     "Old_Coins": showCoins,
                      //     "User_Enter_Coin": coinDraw.text,
                      //     "New_Coins": result7,
                      //     "Data_Time": timestamp,
                      //     "Reward": "15000 "+categories.text,
                      //     "Data_and_Time": DateTime.now().toString(),
                      //
                      //
                      //   });
                      //   database.child("Today_Winners").child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Email" : email,
                      //         "Player_ID" : playerID.text,
                      //         "Reward" : "15000 " +categories.text,
                      //         "Game_Name" : categories.text,
                      //         "status" : "Pending",
                      //
                      //       });
                      //   Get.showSnackbar(GetSnackBar(
                      //     titleText: Text("Withdraw",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: 'poppins'
                      //       ),),
                      //     duration: Duration(seconds: 35),
                      //     messageText: Text("Your are succesfully 15000 coins withdraw. You reward sent in your account within 24 hours. ThankYou"
                      //       ,
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontFamily: 'poppins'
                      //       ),
                      //     ),
                      //   ));
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      //
                      // }
                      // else if(showCoins >= 20000 && showCoins <= 24999 ){
                      //   int result9 = showCoins - 20000 ;
                      //
                      //   print(result9 = showCoins - 20000);
                      //   await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).update(
                      //       {
                      //         "Current_Coins": result9
                      //       });
                      //   ///USer Coins sent firebase
                      //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Player_ID": playerID.text,
                      //         "Game_Name": categories.text,
                      //         "Old_Coins": showCoins,
                      //         "User_Enter_Coin": coinDraw.text,
                      //         "New_Coins": result9,
                      //         "Reward": "20000 "+categories.text,
                      //         "Email": email,
                      //         "Data_and_Time": DateTime.now().toString(),
                      //
                      //       });
                      //   ///FireStore
                      //   var timestamp =DateTime.now().toString();
                      //   await cdatabase.doc(timestamp).set({
                      //     "Name": name,
                      //     "Email": email,
                      //     "UID": FirebaseAuth.instance.currentUser!.uid,
                      //     "Player_ID": playerID.text,
                      //     "Game_Name": categories.text,
                      //     "Old_Coins": showCoins,
                      //     "User_Enter_Coin": coinDraw.text,
                      //     "New_Coins": result9,
                      //     "Data_Time": timestamp,
                      //     "Reward": "20000 "+categories.text,
                      //     "Data_and_Time": DateTime.now().toString(),
                      //
                      //
                      //   });
                      //   database.child("Today_Winners").child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Email" : email,
                      //         "Player_ID" : playerID.text,
                      //         "Reward" : "20000 " +categories.text,
                      //         "Game_Name" : categories.text,
                      //         "status" : "Pending",
                      //
                      //       });
                      //   Get.showSnackbar(GetSnackBar(
                      //     titleText: Text("Withdraw",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: 'poppins'
                      //       ),),
                      //     duration: Duration(seconds: 35),
                      //     messageText: Text("Your are succesfully 20000 coins withdraw. You reward sent in your account within 24 hours. ThankYou"
                      //       ,
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontFamily: 'poppins'
                      //       ),
                      //     ),
                      //   ));
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      // }
                      // else if(showCoins >= 25000 ){
                      //   int  result3 = showCoins - 25000 ;
                      //   print(result3);
                      //   await database.child('Spins').child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //
                      //         "Current_Coins" : result3
                      //
                      //       });
                      //   ///USer Coins sent firebase
                      //   // var rng =  Random();
                      //   // var k = rng.nextInt(10);
                      //
                      //   await database.child('Withdraw').child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Player_ID": playerID.text,
                      //         "Game_Name": categories.text,
                      //         "Old_Coins": showCoins,
                      //         "User_Enter_Coin": coinDraw.text,
                      //         "New_Coins": result3,
                      //         "Reward": "25000 "+categories.text,
                      //         "Email": email,
                      //         "Data_and_Time": DateTime.now().toString(),
                      //
                      //
                      //       });
                      //   ///FireStore
                      //   var timestamp =DateTime.now().toString();
                      //   await cdatabase.doc(timestamp).set({
                      //     "Name": name,
                      //     "Email": email,
                      //     "UID": FirebaseAuth.instance.currentUser!.uid,
                      //     "Player_ID": playerID.text,
                      //     "Game_Name": categories.text,
                      //     "Old_Coins": showCoins,
                      //     "User_Enter_Coin": coinDraw.text,
                      //     "New_Coins": result3,
                      //     "Data_Time": timestamp,
                      //     "Reward": "25000 "+categories.text,
                      //
                      //
                      //
                      //   });
                      //   database.child("Today_Winners").child(FirebaseAuth.instance.currentUser!.uid).set(
                      //       {
                      //         "Email" : email,
                      //         "Player_ID" : playerID.text,
                      //         "Reward" : "25000 " +categories.text,
                      //         "Game_Name" : categories.text,
                      //         "status" : "Pending",
                      //
                      //       });
                      //   Get.showSnackbar(GetSnackBar(
                      //     titleText: Text("Withdraw",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontFamily: 'poppins'
                      //       ),),
                      //     duration: Duration(seconds: 35),
                      //     messageText: Text("Your are succesfully 25000 coins withdraw. You reward sent in your account within 24 hours. ThankYou",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontFamily: 'poppins'
                      //       ),),
                      //   ));
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      //
                      //
                      // }
                      // else{
                      //   print('not_exists');
                      //   // SnackBar(content: Text('Your Coins  is cannot exists. Please Try Later' ));
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //         "Your Coins  is cannot exists. Please Try Later. ThankYou",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: 'poppins'
                      //         ),),
                      //     ),
                      //   );
                      //   await FacebookRewardedVideoAd.showRewardedVideoAd();
                      //   await UnityAds.showVideoAd(placementId: "Video_Android");
                      // }
                      print("coinController ${coinController.text}");

                    },
                    btnText: "Submit",
                    btnTextColor: textColor
                  ),
                  sizeHeight15,

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
