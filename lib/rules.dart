import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/sizedbox.dart';
import 'package:start_and_earn/components/text_style.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'HomeScreen.dart';
import 'Widgets/appbar.dart';

class rulesSTL extends StatelessWidget {
  const rulesSTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: appBarJustLead(context: context,titleText: "Rules"),

          body: rulesSTF(),
        ),
      ),
    );
  }
}

///

class rulesSTF extends StatefulWidget {
  const rulesSTF({Key? key}) : super(key: key);

  @override
  State<rulesSTF> createState() => _rulesSTFState();
}

class _rulesSTFState extends State<rulesSTF> {
  ///Internet   Connectivity
  final Connectivity _connectivity = Connectivity();
  bool hideUi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    _loadInterstitialAd();

    ///Wifi Connectivity
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {
          hideUi = true;
        });
      } else {
        setState(() {
          hideUi = false;
        });
      }
    });
  }

  ///Facebook ads
  bool _isInterstitialAdLoaded = false;

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

  late double width;
  late double height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        margin: kPaddingHorizontal20,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///.1
              Container(
                child: RichText(
                  text: TextSpan(
                      text: "1. ",
                      style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text:
                              " Withdraw karty waqat Player ID or Reward Type thek sy check kary. Galt informations hony ki surat may or reward kesi or ko phonchny ki surat may Team Zimedar nahi ho ge.",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        )
                      ]),
                ),
              ),

              ///2
              Container(
                // margin: EdgeInsets.only(top: height * 0.006),
                child: RichText(
                  text: TextSpan(
                      text: "2. ",
                      style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text:
                              " Withdraw hony ke bad apka reward 24 hours tak Transfer ho jae ga.",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                          ),
                        )
                      ]),
                ),
              ),

              ///3
              Container(
                // margin: EdgeInsets.only(top: height * 0.006),

                child: RichText(
                  text: TextSpan(
                    text: "3. ",
                    style: txtStyle16AndMainBold,
                    children: [
                      TextSpan(
                        text: "Agr ap 1 sy zayada accounts sy Play And Win Application use kry ge apko parmanently block kr diya jae ga or reward bhi nahi mily ga.",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      )
                    ]
                  ),
                ),
              ),

              ///Withdraw Text
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Rewards",
                  style: txtStyle22AndMainBold,
                ),
              ),
              ///Withdraw 1
              Container(
                child: RichText(
                  text: TextSpan(
                    text: "1. ",style: txtStyle16AndMainBold,
                    children: [
                      TextSpan(
                        text: "5000 Coins = ",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      ///60Uc
                      TextSpan(
                        text: "60 UC",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(text: "  or  ",style: TextStyle(
                          fontFamily: "poppins",
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),),
                      ///Coins
                      TextSpan(
                        text: "5000 Coins = ",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      ///85 Diamonds
                      TextSpan(
                        text: "85 Diamonds",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(text: "  or  ",style: TextStyle(
                          fontFamily: "poppins",
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),),
                      ///Coins
                      TextSpan(
                        text: "5000 Coins = ",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      ///Ludo Coins
                      TextSpan(
                        text: "10k Ludo Coins",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(text: "  or  ",style: TextStyle(
                          fontFamily: "poppins",
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),),
                      ///Coins
                      TextSpan(
                        text: "5000 Coins = ",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      ///Chips
                      TextSpan(
                        text: "1 Cr Chip",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ]
                  ),
                ),
              ),
              ///Withdraw 2
              Container(
                margin: EdgeInsets.only(top: height*0.006),
                child: RichText(
                  text: TextSpan(
                      text: "2. ",style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text: "10000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///120Uc
                        TextSpan(
                          text: "120 UC",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "10000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///170 Diamonds
                        TextSpan(
                          text: "170 Diamonds",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "10000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Ludo Coins
                        TextSpan(
                          text: "20k Ludo Coins",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "10000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Chips
                        TextSpan(
                          text: "2 Cr Chip",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ]
                  ),
                ),
              ),
              ///Withdraw 3
              Container(
                margin: EdgeInsets.only(top: height*0.006),
                child: RichText(
                  text: TextSpan(
                      text: "3. ",style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text: "15000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///180Uc
                        TextSpan(
                          text: "180 UC",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "15000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///285 Diamonds
                        TextSpan(
                          text: "285 Diamonds",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "15000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Ludo Coins
                        TextSpan(
                          text: "30k Ludo Coins",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "15000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Chips
                        TextSpan(
                          text: "3 Cr Chip",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ]
                  ),
                ),
              ),
              ///Withdraw 4
              Container(
                margin: EdgeInsets.only(top: height*0.006),
                child: RichText(
                  text: TextSpan(
                      text: "4. ",style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text: "20000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///240Uc
                        TextSpan(
                          text: "240 UC",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "20000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///370 Diamonds
                        TextSpan(
                          text: "370 Diamonds",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "20000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Ludo Coins
                        TextSpan(
                          text: "40k Ludo Coins",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "20000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Chips
                        TextSpan(
                          text: "4 Cr Chip",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ]
                  ),
                ),
              ),
              ///Withdraw 5
              Container(
                margin: EdgeInsets.only(top: height*0.006),
                child: RichText(
                  text: TextSpan(
                      text: "5. ",style: txtStyle16AndMainBold,
                      children: [
                        TextSpan(
                          text: "25000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Royal Pass
                        TextSpan(
                          text: "Pubg Royal Pass",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "25000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///455 Diamonds
                        TextSpan(
                          text: "455 Diamonds",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "25000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Ludo Coins
                        TextSpan(
                          text: "50k Ludo Coins",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(text: "  or  ",style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),),
                        ///Coins
                        TextSpan(
                          text: "25000 Coins = ",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                        ///Chips
                        TextSpan(
                          text: "6 Cr Chip",
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ]
                  ),
                ),
              ),
                  Text("If you have any question and faced any issue Contact our email:",
                    style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: mainColor
                ),
                  onPressed: (){},
                  child: Text("securedoorstudio@gmail.com",style: txtStyle16AndMainBold,)),
              ///Text
              // Container(
              //   // margin: EdgeInsets.only(top: height*0.04),
              //   child: RichText(
              //     text: TextSpan(
              //       text: "If you have any question and faced any issue Contact ",
              //       style: TextStyle(
              //           fontFamily: 'poppins',
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500
              //       ),
              //       children: [
              //         TextSpan(
              //           text: " securedoorstudio@gmail.com  ",
              //           style: TextStyle(
              //               fontFamily: 'poppins',
              //               color: Colors.yellow.shade700,
              //               fontWeight: FontWeight.bold
              //
              //           ),
              //         ),
              //         TextSpan(
              //           text: "anytime. Thank You"
              //         )
              //       ]
              //     ),
              //   ),
              // ),
            ],
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
}
