import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start_and_earn/AuthScreens/signup_screen.dart';

import '../../Provider/auth_provider.dart';
import '../../Widgets/toast.dart';
import '../components/colors.dart';
import '../components/paths.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../widgets/button.dart';
import 'forgot_password.dart';
import 'login_screen.dart';
import 'signup_email_password.dart';
import 'comfirmYourNumber.dart';

class LoginScreenPhoneAndButtons extends StatefulWidget {
  const LoginScreenPhoneAndButtons({Key? key}) : super(key: key);

  @override
  State<LoginScreenPhoneAndButtons> createState() => _LoginScreenPhoneAndButtonsState();
}

class _LoginScreenPhoneAndButtonsState extends State<LoginScreenPhoneAndButtons> {
  final _number = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  final scrSize = MediaQuery.of(context).size;
    return Consumer<AuthenProvider>(builder: (context,provider,child){
      return SafeArea(
          child: Scaffold(
            // backgroundColor: whiteColor,
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: kPaddingHorizontal20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizeHeight30,
                      Text("Welcome Back!",style: txtStyle18AndBold,),
                      // sizeHeight10,
                      Text("Hello again, you're been missed!",style: txtStyle12AndOther,),
                      sizeHeight15,
                      Text("Email Address",style: txtStyle12AndBold,),
                      sizeHeight10,
                      // textField(hintText: "finjineers@gmail.com", controller: email),
                      SizedBox(
                        // height: 45,
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: mainColor,
                          style: txtStyle14,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            hintText: "Enter your email",
                            hintStyle: txtStyle12AndOther,
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
                          controller: _passwordController,
                          cursorColor: mainColor,
                          validator: _validatePassword,
                          style: txtStyle14,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: provider.isHidePasswordBool,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            hintText: "Enter your password",
                            hintStyle: txtStyle12AndOther,
                            border: OutlineInputBorder(
                              borderRadius: kBorderRadius10,
                              borderSide:  BorderSide(color: otherColor,width: 0.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: kBorderRadius10,
                              borderSide:  BorderSide(color: otherColor,width: 0.2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: kBorderRadius10,
                              borderSide:  BorderSide(color: otherColor,width: 0.2),
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
                      ///Remember or Forgot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Row(
                          //   children: [
                          //     Transform.scale(
                          //       scale: 0.9,
                          //       child: Checkbox(
                          //           activeColor: mainColor,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(4),
                          //             side: BorderSide(color: otherColor,width: 0.2),
                          //           ),
                          //           value: provider.rememberMeBool, onChanged: (val){
                          //         provider.rememberMeFun(val);
                          //       }),
                          //     ),
                          //     Text("Remember Me",style: txtStyle12AndBold,),
                          //
                          //   ],
                          // ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: redColor
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                              }, child: Text("Forgot Password",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: redColor,
                              fontSize: 12
                          ),)),
                        ],
                      ),
                      sizeHeight30,
                      button(context: context,btnText: "Login",onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // Process sign-up request, e.g., make API calls
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          // Perform sign-up logic here
                          await provider.loginEmailAndPassword(context: context,emailController: email,passwordController: password);
                          // Show success message or navigate to another screen
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text('Sign-up successful!'),
                          // ));
                        }

                      },btnTextColor: textColor),
                      sizeHeight15,
                      /// or with text
                      Row(
                        children: [
                          Expanded(child: divider),
                          Text(" Or Sign in With ",style: txtStyle12AndOther,),
                          Expanded(child: divider),
                        ],
                      ),
                      sizeHeight15,
                      ///Google And Facebook
                      iconButton(context: context, onTap: (){},btnText: "Sign in with Facebook",icon: Icon(Icons.facebook,color: blueColor,)),
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
                          btnText: "Sign in with Google"
                      ),
                      sizeHeight20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: txtStyle14AndOther,),
                          TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: mainColor,
                              ),
                              onPressed: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                              }, child: Text("Sign Up",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mainColor
                          ),)),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}
