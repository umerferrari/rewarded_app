import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../AuthScreens/authScreen.dart';

class PhoneScreen extends StatefulWidget {
  static String routeName = '/phone';
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
  late double width;
  late double height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
          child: Stack(
            children: [
              ///First Section
              Container(
                margin: EdgeInsets.only(left: height*0.02),
                child: Row(
                  children: [
                    ///Icon
                    Container(
                      child: InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back, color: Colors.yellow.shade700,)),
                    ),
                    ///Text
                    Container(
                      margin: EdgeInsets.only(left: height*0.04),
                      child: Text("Mobile Number", style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),),
                    ),
                  ],
                ),
              ),
              ///Line
              Container(
                margin: EdgeInsets.only(top: height*0.05),
                color: Colors.yellow.shade700,
                width: width,
                height: height*0.002,
              ),
              ///Text
              Container(
                margin: EdgeInsets.only(top: height*0.15, right: width*0.1, left: width*0.1),
                child: Text("Enter Your Phone Number with country code just Like (+923XXXXXXX)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins',
                  fontSize: 20
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height*0.4, right: width*0.1, left: width*0.1),

                child: TextFormField(
                  autofocus: false,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.yellow.shade700,

                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: "Enter phone number",
                    labelStyle: TextStyle(
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.grey.shade400),
                    border: InputBorder.none,
                    hintText: '+923*******',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height*0.48, right: width*0.1, left: width*0.1),

                height: height * 0.002,
                width: width,
                color: Colors.yellow.shade700,
              ),
              Container(
                margin: EdgeInsets.only(top: height*0.55, right: width*0.1, left: width*0.1),
                width: width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700
                  ),
                  onPressed: () {
                    FirebaseAuthMethods(FirebaseAuth.instance)
                        .phoneSignIn(context, phoneController.text);
                    // FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(width*0.035),
                      child: Text("Verify",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold
                      ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}