import 'package:flutter/material.dart';
import 'package:start_and_earn/components/colors.dart';
import 'package:start_and_earn/components/text_style.dart';
import 'package:start_and_earn/user_dashboard.dart';

checkCoinBalanceFun({context}){
  return Card(
    // decoration: BoxDecoration(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      ),
        color: blackOtherColor,
        // border: Border.all(
        //   color: Colors.yellow.shade700,
        // )
    child: InkWell(
      onTap: (){
        // FacebookRewardedVideoAd.loadRewardedVideoAd(
        //     placementId: "781313709744134_781317253077113"
        // );
        // Get.offNamed('/home/DashBoard');
        Navigator.push(context, MaterialPageRoute(builder: (context) => userDashboard()));
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Text
              Container(
                // margin: EdgeInsets.only(top: height*0.035),
                child: Column(
                  children: [
                    Text("Click & check",style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold
                    ), ),
                    RichText(
                      text: TextSpan(
                          text: "Coins ", style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold
                      ),
                          children: [
                            TextSpan(
                              text: "Balance", style: TextStyle(
                                color: mainColor,
                                fontSize: 16,
                                fontFamily: 'poppins',
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
    ),
  );
}