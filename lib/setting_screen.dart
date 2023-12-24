import 'package:flutter/material.dart';
import 'package:start_and_earn/Widgets/appbar.dart';
import 'package:start_and_earn/components/paths.dart';
import 'package:start_and_earn/widgets/user_dashboard_card.dart';

import 'EditProfile/edit_profile.dart';
import 'components/colors.dart';
import 'components/sizedbox.dart';
import 'components/text_style.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: appBarJustLead(context: context,titleText: "Settings",
            action: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: mainColor
              ),
            onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
            child: Text("Edit Profile",style: txtStyle14AndMainBold,))
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: kPaddingHorizontal20,
              child: Column(
                children: [
                  sizeHeight20,
                  CircleAvatar(
                    // child: ,
                    radius: 60,
                    backgroundColor: blackOtherColor,
                    child: Icon(Icons.camera_alt_outlined,color: mainColor,size: 40,),
                  ),
                  sizeHeight15,
                  Text("Umer Ferrari",style: txtStyle16AndBold,),
                  sizeHeight20,
                  userDashboardCardWithOnTap(
                    title: "Privacy Policy",
                    subtitle: "Please take the time to read our privacy policy.",
                    imagePath: ruleIcon,
                    onTap: (){},
                    iconColor: Colors.green,
                  ),
                  sizeHeight10,
                  userDashboardCardWithOnTap(
                    onTap: (){},
                    title: "Support",
                    imagePath: supportIcon,
                    subtitle: "Contact us & send your Feedback",
                    iconColor: purpleColor,
                  ),
                  sizeHeight10,
                  userDashboardCardWithOnTap(
                    title: "Delete Account",
                    subtitle: "To delete your account, please click on this link.",
                    imagePath: deleteIcon,
                    onTap: (){},
                    // iconColor:
                  ),
                  sizeHeight10,
                  userDashboardCardWithOnTap(
                    title: "Logout",
                    subtitle: "To log out, simply click on the Logout.",
                    imagePath: logoutIcon,
                    onTap: (){},
                    iconColor: blueColor,
                  ),
                  sizeHeight15,
                ],
              ),
            ),
          ),
        ));
  }
}
