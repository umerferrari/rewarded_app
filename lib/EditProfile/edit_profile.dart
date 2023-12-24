import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:start_and_earn/Widgets/appbar.dart';
import 'package:start_and_earn/components/sizedbox.dart';

import '../components/colors.dart';
import '../components/text_style.dart';
import '../widgets/button.dart';

class EditProfileScreen extends StatefulWidget {
   EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController email = TextEditingController();
  String selectedValue = "";
  String isRegisterMethod = "";
  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: appBarJustLead(context: context,titleText: "Edit Profile"),
          body: SingleChildScrollView(
            child: Padding(
              padding:kPaddingHorizontal20,
              child: Form(
                key: formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeHeight20,
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          // backgroundColor: blackOtherColor,
                          child: Icon(Icons.camera_alt_outlined,color: mainColor,size: 40,),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: blackOtherColor,
                            child: IconButton(
                              onPressed: (){},
                                icon: Icon(Icons.camera,size: 20,)),
                          ),
                        ),
                      ],
                    ),
                    sizeHeight15,
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Name", style: txtStyle12AndBold,)),
                    sizeHeight10,
                    TextFormField(
                      controller: name,
                      style: txtStyle14,
                      keyboardType: TextInputType.name,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter a name";
                        }
                        return null;
                      },
                      cursorColor: mainColor,
                      decoration: InputDecoration(
                        contentPadding:  EdgeInsets
                            .symmetric(
                            vertical: 0, horizontal: 10),
                        hintText: "Enter your name",
                        hintStyle: txtStyle12AndOther,
                        border: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        // suffixIcon: suffixIcon?? Container(),
                      ),
                    ),
                    sizeHeight15,
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Bio", style: txtStyle12AndBold,)),
                    sizeHeight10,
                    TextFormField(
                      controller: bio,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter a bio";
                        }
                        return null;
                      },
                      cursorColor: mainColor,
                      style: txtStyle14,
                      decoration: InputDecoration(
                        contentPadding:  EdgeInsets
                            .symmetric(
                            vertical: 0, horizontal: 10),
                        hintText: "Enter your bio",
                        hintStyle: txtStyle12AndOther,
                        border: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        // suffixIcon: suffixIcon?? Container(),
                      ),
                    ),
                    sizeHeight15,
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Gender", style: txtStyle12AndBold,)),
                    sizeHeight10,
                    DropdownButtonHideUnderline(
                      child: SizedBox(
                        width: scrSize.width,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: kBorderRadius10,
                            border: Border.all(
                                color: otherColor,
                                width: 0.2
                            ),
                          ),
                          padding: kPaddingHorizontal20,
                          child: DropdownButton<String>(
                            // value: selectedValue,
                            dropdownColor: blackOtherColor,
                            iconEnabledColor: mainColor,
                            hint: Text("Select Gender",style: txtStyle14,),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                                print(selectedValue);
                              });
                            },
                            items: <String>[
                              'Male',
                              'Female',
                              'Other',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(

                                value: value,
                                child: Text(value,style: txtStyle14,),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    sizeHeight15,
                    isRegisterMethod == "number"? Container() :     Align(
                        alignment: Alignment.topLeft,
                        child: Text("Email",
                          style: txtStyle12AndBold,)),
                    isRegisterMethod == "number"? Container() :    sizeHeight10,
                    isRegisterMethod == "number"? Container() :    TextFormField(
                      controller: email,
                      style: txtStyle14,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter a email";
                        }
                        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$').hasMatch(value)) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },

                      cursorColor: mainColor,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding:  EdgeInsets
                            .symmetric(
                            vertical: 0, horizontal: 10),
                        hintText: "Enter your email",
                        hintStyle: txtStyle12AndOther,
                        border: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: kBorderRadius10,
                          borderSide:  BorderSide(
                              color: otherColor, width: 0.2),
                        ),
                        // suffixIcon: suffixIcon?? Container(),
                      ),
                    ),
                    isRegisterMethod == "number"? Container() :  sizeHeight10,
                    ///Email not change
                    isRegisterMethod == "number"? Container() : Container(
                      child: email.text.isNotEmpty? Align(
                          alignment: Alignment.topRight,
                          child: Text("Not Changed",
                            style: txtStyle12AndOther,)) : Container(),
                    ),
                    sizeHeight15,
                    isRegisterMethod == "emailpassword" || isRegisterMethod == "google" ? Container() : Align(
                      alignment: Alignment.topLeft,
                      child: Text("Mobile Number",
                        style: txtStyle12AndBold,),
                    ),
                    isRegisterMethod == "emailpassword" || isRegisterMethod == "google" ? Container() :  sizeHeight10,
                    isRegisterMethod == "emailpassword" || isRegisterMethod == "google" ? Container() : Container(
                      child: phoneNumber.text.isNotEmpty? Column(
                        children: [
                          SizedBox(
                            // height: 67,
                            width: scrSize.width,
                            child: TextFormField(
                              readOnly: true,
                              style: txtStyle14,
                              controller: phoneNumber,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return 'Please enter a number.';
                                }
                                // if (value.length < ) {
                                //   return 'Password should be at least 6 characters.';
                                // }
                                return null;
                              },

                              cursorColor: mainColor,
                              decoration: InputDecoration(
                                contentPadding:  EdgeInsets
                                    .symmetric(
                                    vertical: 0, horizontal: 10),
                                hintText: "Enter your number",
                                hintStyle: txtStyle12AndOther,
                                border: OutlineInputBorder(
                                  borderRadius: kBorderRadius10,
                                  borderSide:  BorderSide(
                                      color: otherColor,
                                      width: 0.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: kBorderRadius10,
                                  borderSide:  BorderSide(
                                      color: otherColor,
                                      width: 0.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: kBorderRadius10,
                                  borderSide:  BorderSide(
                                      color: otherColor,
                                      width: 0.2),
                                ),
                                // suffixIcon: suffixIcon?? Container(),
                              ),
                            ),
                          ),
                          sizeHeight10,
                          isRegisterMethod == "emailpassword" || isRegisterMethod == "google" ? Container() :   Container(
                            child: email.text.isNotEmpty? Align(
                                alignment: Alignment.topRight,
                                child: Text("Not Changed",
                                  style: txtStyle12AndOther,)) : Container(),
                          ),

                        ],
                      )
                          :
                      SizedBox(
                        // height: 67,
                        width: scrSize.width,
                        child: IntlPhoneField(
                          cursorColor: mainColor,
                          // readOnly: phone_number!.isNotEmpty?true : false,
                          controller: phoneNumber,
                          style: txtStyle14,
                          // validator: _validateNumber,
                          validator: (e){},
                          onSaved:(e){
                            print("Complete ${e!.completeNumber}");
                          },
                          // Set the allowed countries here (only 'PK' in this case)
                          // countries: ['PK'],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding:  EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            hintText: "Enter your mobile number",
                            hintStyle: txtStyle14AndOther,
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
                          ),
                          initialCountryCode: 'PK',

                          onChanged: (phone) {
                            // authProvider.storePhoneNumFun(phone.completeNumber);
                            print(phone.completeNumber);
                          },
                        ),
                      ),
                    ),

                    sizeHeight20,
                    button(context: context,
                        btnText: "Update",
                        btnTextColor: textColor,
                        onTap: () async {
                          if(formKey.currentState!.validate()){
                            // showMyWaitingModal(context: context);
                            // await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                            //     {
                            //       DBkeys.userName : name.text,
                            //       DBkeys.userBio : bio.text,
                            //       DBkeys.userGender : selectedValue,
                            //       "email" : email.text,
                            //       "phone_number" : authProvider.storePhoneNum,
                            //     });
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar()), (route) => false);
                            // Navigator.pop(context);
                          }
                          // Navigator.pop(context);
                        },
                        bgColor: mainColor,
                        ),
                    sizeHeight15,
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
