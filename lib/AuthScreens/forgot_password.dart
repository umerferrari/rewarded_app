import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/auth_provider.dart';
import '../../Widgets/appbar.dart';
import '../components/colors.dart';
import '../components/sizedbox.dart';
import '../components/text_style.dart';
import '../widgets/button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();
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


  @override
  void dispose() {
    email.dispose();
    // _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return Consumer<AuthenProvider>(builder: (context,provider,child){
      return SafeArea(
          child: Scaffold(
            // backgroundColor: scaffoldColor,
            appBar: appBarJustLead(bgColor: transparentColor,context: context),
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
                        Text("Forgot Password",style: txtStyle18AndBold,),
                        sizeHeight15,
                        Text("Hello again, Please enter you email",style: txtStyle12AndOther,),
                        sizeHeight15,
                        // textField(hintText: "finjineers@gmail.com", controller: email),
                        SizedBox(
                          // height: 45,
                          child: TextFormField(
                            controller: email,
                            cursorColor: mainColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              hintText: "Enter your email",
                              hintStyle: txtStyle12AndOther,
                              border: OutlineInputBorder(
                                borderRadius: kBorderRadius10,
                                borderSide:  BorderSide(color: otherColor,width: 0.2),
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
                        sizeHeight30,
                        button(context: context,btnText: "Reset Password",onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            provider.forgotPassword(emailController: email,context: context);
                          }

                        },btnTextColor: textColor),

                      ],
                    ),
                  ),
                )),
          ));
    });
  }
}
