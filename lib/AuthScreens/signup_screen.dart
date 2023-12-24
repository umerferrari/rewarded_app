import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_and_earn/AuthScreens/signup_profile_info.dart';
import '../../Provider/auth_provider.dart';
import '../Widgets/toast.dart';
import '../components/DB_keys.dart';
import '../components/colors.dart';
import '../components/paths.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../widgets/button.dart';
import 'signup_email_password.dart';
import 'comfirmYourNumber.dart';
import 'login_phone_and_buttons.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String verificationId = '';
  // static String email = '';
  // static String password = '';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email address.';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$').hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters.';
    }
    return null;
  }
  FutureOr<String?> _validateNumber(PhoneNumber) {
    if (PhoneNumber!.isEmpty) {
      return 'Please enter a Mobile Number.';
    }
    if (PhoneNumber.length < 9) {
      return 'Password should be at least 9 characters.';
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
    _number.dispose();
  }
  // final _email = TextEditingController();
  // final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final scrSize = MediaQuery.of(context).size;
    return Consumer<AuthenProvider>(builder: (context,provider,child){
      return SafeArea(
          child: Scaffold(
            // backgroundColor: scaffoldColor,
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: kPaddingHorizontal20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeHeight30,
                    Text("Create Account",style: txtStyle18AndBold,),
                    // sizeHeight10,
                    Text("Connect with your friends today!",style: txtStyle12AndOther,),
                    sizeHeight15,
                    Text("Email Address",style: txtStyle12AndBold,),
                    sizeHeight10,
                    // textField(hintText: "finjineers@gmail.com", controller: email),
                    SizedBox(
                      // height: 45,
                      child: TextFormField(
                        controller: _email,
                        cursorColor: mainColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        style: txtStyle14,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          hintText: "Enter your email",
                          hintStyle: txtStyle14AndOther,
                          border: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide:  BorderSide(color: otherColor,width: 0.2),
                          ),
                          // suffixIcon: suffixIcon?? Container(),
                        ),
                      ),
                    ),
                    sizeHeight15,
                    Text("Password",style: txtStyle12AndBold,),
                    sizeHeight10,
                    SizedBox(
                      // height: 45,
                      child: TextFormField(
                        controller: _password,
                        style: txtStyle14,
                        cursorColor: mainColor,
                        keyboardType: TextInputType.visiblePassword,
                        // validator: _validateConfirmPassword,
                        validator: _validatePassword,
                        obscureText: provider.isHidePasswordBool,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          hintText: "Enter your password",
                          hintStyle: txtStyle14AndOther,
                          border: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(provider.isHidePasswordBool ? Icons.visibility : Icons.visibility_off,color: provider.isIconColorChange.isEmpty? textColor : mainColor,),
                            onPressed: () {
                              provider.isHidePasswordFun();
                            },
                          ),
                          // suffixIcon: suffixIcon?? Container(),
                        ),
                        onChanged: (val){
                          provider.isIconColorChangeFun(val);
                        },
                      ),
                    ),
                    sizeHeight15,
                    Text("Confirm Password",style: txtStyle12AndBold,),
                    sizeHeight10,
                    SizedBox(
                      // height: 45,
                      child: TextFormField(
                        controller: _confirmPassword,
                        cursorColor: mainColor,
                        style: txtStyle14,
                        keyboardType: TextInputType.visiblePassword,
                        validator: _validatePassword,
                        obscureText: provider.isHidePasswordBool,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          hintText: "Enter your confirm-password",
                          hintStyle: txtStyle14AndOther,
                          border: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius10,
                            borderSide: BorderSide(color: otherColor,width: 0.2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(provider.isHidePasswordBool ? Icons.visibility : Icons.visibility_off,color: provider.isIconColorChange.isEmpty? textColor : mainColor,),
                            onPressed: () {
                              provider.isHidePasswordFun();
                            },
                          ),
                          // suffixIcon: suffixIcon?? Container(),
                        ),
                        onChanged: (val){
                          provider.isIconColorChangeFun(val);
                        },
                      ),
                    ),
                    // sizeHeight10,
                    ///agree terms & condition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: Checkbox(
                              activeColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: textColor,width: 1.0),
                              ),
                              value: provider.agreeBool, onChanged: (val){
                            provider.agreeFun(val);
                          }),
                        ),
                        Text("I agree to the terms and conditions",style: txtStyle12AndBold,),

                      ],
                    ),
                    sizeHeight15,
                    button(context: context,btnText: "Sign Up",onTap: ()async{
                      if(_formKey.currentState!.validate()){
                        if (_password.text.isEmpty || _confirmPassword.text.isEmpty) {
                          // Show error message for empty password fields
                          AppToast.show("Please enter a password and confirm password.");
                        }
                        else if (_password.text.length < 6) {
                          // Show error message for password length less than 6 characters
                          AppToast.show("Password must be at least 6 characters long.");
                        }
                        else if (_password.text != _confirmPassword.text) {
                          // Show error message for password mismatch

                          AppToast.show("Password and confirm password do not match.");
                        } else if (provider.agreeBool == false){
                          AppToast.show("Accept terms and conditions.");
                        }
                        else {
                          // Password and confirm password are valid
                          // Proceed with further actions
                          // provider.signupEmailAndPassword(context: context,emailController: _email.text,passwordController: _password.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpProfileInfo()));

                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmYourNumber()));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()));
                      }
                      // else{
                      //   AppToast.show("Accept terms and conditions.");

                      // }
                    },btnTextColor: textColor),
                    // sizeHeight20,
                    sizeHeight15,
                    /// or with text
                    Row(
                      children: [
                        Expanded(child: divider),
                        Text(" Or Sign Up With ",style: txtStyle12AndOther,),
                        Expanded(child: divider),
                      ],
                    ),
                    sizeHeight15,
                    ///Google And Facebook

                    iconButton(context: context, onTap: (){},btnText: "Sign up with Facebook",icon: Icon(Icons.facebook,color: blueColor,)),
                    sizeHeight10,
                    iconButton(
                        context: context,
                        onTap: (){
                          provider.signInWithGoogle(context: context);
                        },
                        icon: SizedBox(
                          height: 25,
                          child: Image.asset(googleIcon),
                        ),
                        btnText: "Sign up with Google"
                    ),
                    sizeHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",style: txtStyle14AndOther,),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: mainColor,
                            ),
                            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreenPhoneAndButtons()));
                            }, child: Text("Login",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mainColor
                        ),)),

                      ],
                    ),

                  ],
                ),
              ),
            )),
          ));
    });

  }
}
