import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
// import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:start_and_earn/Widgets/appbar.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/sizedbox.dart';
import 'package:start_and_earn/components/text_style.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'HomeScreen.dart';
import 'SpinWheel.dart';

class winnerScreen extends StatelessWidget {
  const winnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return winnerScreenSTFF();
  }
}

///2
class winnerScreenSTFF extends StatefulWidget {
  const winnerScreenSTFF({Key? key}) : super(key: key);

  @override
  State<winnerScreenSTFF> createState() => _winnerScreenSTFFState();
}

class _winnerScreenSTFFState extends State<winnerScreenSTFF> {
  late double width;
  late double height;
  int i = 0;

  ///table
  late Query _ref;
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Today_Winners');


  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  ///Database
  final database = FirebaseDatabase.instance.ref();
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
  ///Data Get
  late  DataSnapshot snapshot;
  String email = '';
  String player_Id = '';
  String reward = '';
  String status = '';
  String game_Name = '';
  bool Datashow = true;
  void getData()async{
    snapshot = await database.child("Today_Winners").get();
    if(snapshot.exists){
      print(snapshot.value);
      Map<dynamic,dynamic> map = snapshot.value as Map<dynamic,dynamic>;
      setState(() {
        email = map['Email'];
        reward = map['Reward'];
        status = map['status'];
        game_Name = map['Game_Name'];
        player_Id = map['Player_ID'];
        Datashow = false;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permissions();
    _ref =
        FirebaseDatabase.instance.ref().child('Today_Winners').orderByChild('Email');
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
    ///Unity Ads
    UnityAds.init(
      gameId: AdManager.gameId,
      testMode: true,
      onComplete: () {
        print('Initialization Complete');
      },
      onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );
///

    ///Facebook ads init
    /// please add your own device testingId
    /// (testingId will print in console if you don't provide  )
    FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,
    );
    getData();

  }

  Widget _buildContactItem({required Map allWithdraw}) {
    // Color typeColor = getTypeColor(contact['Email']);
    print(allWithdraw.values);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        child: Icon(
                          Icons.numbers,
                          color: Colors.yellow.shade700,
                        )),

                    ///Id Text
                    Container(
                      child: Text(
                        'No :  ' + '${i++}'.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: width * 0.02, left: width * 0.02),
                      child: Icon(
                        Icons.person,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    Text(
                      "Email :  " + email.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  child: Icon(
                    Icons.videogame_asset_sharp,
                    color: Colors.yellow.shade700,
                  ),
                ),
                Text(
                  "Type :  " ,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 15),
                Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  child: Icon(
                    Icons.insert_drive_file,
                    color: Colors.yellow.shade700,
                  ),
                ),
                Text(
                  "ID  :  " ,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: Colors.yellow.shade700,
                  ),
                ),
                Text(
                  "Reward :  " ,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  margin:
                  EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                  child: Icon(
                    Icons.watch_later,
                    color: Colors.yellow.shade700,
                  ),
                ),
                Text(
                  "Status  :  " ,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: height * 0.04, left: width * 0.2),
              width: width * 0.6,
              height: height * 0.002,
              color: Colors.yellow.shade700,
            )
          ],
        ),
      ),
    );
  }

  ///Facebook ads
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
    ) : DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: appBarJustLead(context: context,titleText: "Winners"),
          body: Container(
            child: Column(
              children: [
                // sizeHeight20,
                ///tab bar
                Container(
                  margin: kPaddingHorizontal20,
                  // padding: const EdgeInsets.all(8.0),
                  // color: Colors.blue,
                  width: width,
                  // height: height * 0.7,
                  child: TabBar(
                    indicatorColor: mainColor,
                    unselectedLabelStyle: txtStyle14AndOther,
                    labelStyle: txtStyle14AndMainBold,
                    // indicatorPadding: ,
                    labelPadding: EdgeInsets.symmetric(vertical: 15),
                    tabs: [
                      Text(
                        'Today',
                        // style: TextStyle(
                        //     fontFamily: 'poppins',
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.white),
                      ) ,
                      Text(
                        'Weekly',
                        // style: TextStyle(
                        //     fontFamily: 'poppins',
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    // Datashow? Container(
                    //     // color: Colors.black,
                    //     child: Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'poppins',fontSize: 20),)))
                    //     :
                    // Container(
                    //     child: FirebaseAnimatedList(
                    //       query: _ref,
                    //       itemBuilder: (BuildContext context,
                    //           DataSnapshot snapshot,
                    //           Animation<double> animation,
                    //           int index) {
                    //         Map<dynamic, dynamic> contact =
                    //         snapshot.value as Map<dynamic, dynamic>;
                    //         print(snapshot.value.toString());
                    //
                    //         return _buildContactItem(allWithdraw: contact);
                    //       },
                    //     )
                    // ),
                    ///Today
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 30,
                        itemBuilder: (context,index){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizeHeight15,
                          Padding(
                            padding: kPaddingHorizontal20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                          // margin: EdgeInsets.only(right: width * 0.02),
                                          child: Icon(
                                            Icons.numbers,
                                            color: Colors.yellow.shade700,
                                          )),
                                      sizeWidth10,

                                      ///Id Text
                                      Container(
                                        child: Text(
                                          'No :  ' + '${index}'.toString(),
                                          style: txtStyle12AndBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(
                                        //     right: width * 0.02, left: width * 0.02),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.yellow.shade700,
                                        ),
                                      ),
                                      sizeWidth10,
                                      Expanded(
                                        child: Text(
                                          "Email :  securedoorstudio@gmail.com" + email.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: txtStyle12AndBold),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: kPaddingHorizontal20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                  Icon(
                                    Icons.videogame_asset_sharp,
                                    color: Colors.yellow.shade700,
                                  ),
                                  sizeWidth10,
                                  Expanded(
                                    child: Text(
                                      "Type :  " ,
                                      style: txtStyle12AndBold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.yellow.shade700,
                                  ),
                                  sizeWidth10,
                                  Expanded(
                                    child: Text(
                                      "ID  :  " ,
                                      style: txtStyle12AndBold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: kPaddingHorizontal20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                  Icon(
                                    Icons.restaurant_menu,
                                    color: Colors.yellow.shade700,
                                  ),
                                  sizeWidth10,
                                  Expanded(
                                    child: Text(
                                      "Reward :  " ,
                                      style: txtStyle12AndBold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                Icon(
                                  Icons.watch_later,
                                  color: Colors.yellow.shade700,
                                ),
                                sizeWidth10,
                                Expanded(
                                  child: Text(
                                    "Status  :  " ,
                                    style: txtStyle12AndBold,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: height * 0.04, left: width * 0.2),
                            width: width * 0.6,
                            height: height * 0.002,
                            color: Colors.yellow.shade700,
                          )
                        ],
                      );
                    }),
                    ///Weekly
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 30,
                        itemBuilder: (context,index){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sizeHeight15,
                              Padding(
                                padding: kPaddingHorizontal20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            // margin: EdgeInsets.only(right: width * 0.02),
                                              child: Icon(
                                                Icons.numbers,
                                                color: Colors.yellow.shade700,
                                              )),
                                          sizeWidth10,

                                          ///Id Text
                                          Container(
                                            child: Text(
                                              'No :  ' + '${index}'.toString(),
                                              style: txtStyle12AndBold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            // margin: EdgeInsets.only(
                                            //     right: width * 0.02, left: width * 0.02),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.yellow.shade700,
                                            ),
                                          ),
                                          sizeWidth10,
                                          Expanded(
                                            child: Text(
                                                "Email :  securedoorstudio@gmail.com" + email.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: txtStyle12AndBold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: kPaddingHorizontal20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.videogame_asset_sharp,
                                            color: Colors.yellow.shade700,
                                          ),
                                          sizeWidth10,
                                          Expanded(
                                            child: Text(
                                              "Type :  " ,
                                              style: txtStyle12AndBold,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.yellow.shade700,
                                          ),
                                          sizeWidth10,
                                          Expanded(
                                            child: Text(
                                              "ID  :  " ,
                                              style: txtStyle12AndBold,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: kPaddingHorizontal20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            color: Colors.yellow.shade700,
                                          ),
                                          sizeWidth10,
                                          Expanded(
                                            child: Text(
                                              "Reward :  " ,
                                              style: txtStyle12AndBold,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.watch_later,
                                            color: Colors.yellow.shade700,
                                          ),
                                          sizeWidth10,
                                          Expanded(
                                            child: Text(
                                              "Status  :  " ,
                                              style: txtStyle12AndBold,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: height * 0.04, left: width * 0.2),
                                width: width * 0.6,
                                height: height * 0.002,
                                color: Colors.yellow.shade700,
                              )
                            ],
                          );
                        }),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }


}


