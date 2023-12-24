import 'package:flutter/material.dart';

class UserInfoModal {
  String userName;
  String uid;
  String created_at;
  String bio;
  String? phone_number;
  String? email;
  String image_url;
  String token;
  String gender;
  String isRegisterMethod;
  List<dynamic> allGroups;
  List<dynamic> muteGroups;
  UserInfoModal({required this.gender,required this.isRegisterMethod,required this.allGroups,required this.muteGroups,required this.token,required this.image_url,this.email,required this.uid,required this.bio,required this.userName,required this.created_at,this.phone_number});
}