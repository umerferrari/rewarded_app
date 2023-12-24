import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_and_earn/Provider/auth_provider.dart';
import 'package:start_and_earn/Provider/image_picker.dart';
import 'AuthScreens/authScreen.dart';
import 'AuthScreens/onboarding.dart';
import 'HomeScreen.dart';
import 'Provider/user_dashboard_provider.dart';
import 'Provider/withdraw_provider.dart';
import 'SpinWheel.dart';
import 'components/colors.dart';
import 'feed and Contact.dart';
import 'history.dart';
import 'logInForm.dart';
import 'matching_game.dart';
import 'memory.dart';
import 'rules.dart';
import 'screens/main_screen.dart';
import 'signUpForm.dart';
import 'user_dashboard.dart';
import 'winnersScreen.dart';
import 'withDrawal.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
SharedPreferences pref = SharedPreferences.getInstance() as SharedPreferences;
void main() async{
  ///firebase auth 2 require
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pref = await SharedPreferences.getInstance();
  // await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus()async{
    String? value = await storage.read(key: "uid");
    if(value == null ){
      return false;
    }
    return true;
  }
  runApp( DevicePreview(
          enabled: true,
          tools: [...DevicePreview.defaultTools],
          builder: (BuildContext context) => MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),

        ChangeNotifierProvider<AuthenProvider>(
          create: (_) => AuthenProvider(),
        ),
        ChangeNotifierProvider<WithdrawProvider>(
          create: (_) => WithdrawProvider(),
        ),
        ChangeNotifierProvider<ImagePickerProvider>(
          create: (_) => ImagePickerProvider(),
        ),
        ChangeNotifierProvider<UserDashboardProvider>(
          create: (_) => UserDashboardProvider(),
        ),
        // StreamProvider(
        //   create: (context) => context.read<FirebaseAuthMethods>().authState,
        //   initialData: null,
        // ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
          // backgroundColor: Colors.black,
          scaffoldBackgroundColor: bgColor,
          fontFamily: GoogleFonts.poppins().fontFamily,

        ),
        routes: {
          // '/': (context) => AuthCheck(),
          // '/': (context) => OnBoarding(),
          '/': (context) => HomeScreenSTL(),
          // '/SignUp': (context) => signInFormSTL(),
          '/home': (context) => HomeScreenSTL(),
          // '/home/pubgDetails': (context) => PubgDetails(),
          // '/home/freeFireDetails': (context) => freeFireDetails(),
          // '/home/ludoDetails': (context) => ludoDetails(),
          // '/home/teenPattiDetails': (context) => TeenPattiDetails(),
          '/home/pubgDetails/Spins': (context)=> SpinWheel(),
          '/home/withDraw': (context)=> withDrawal(),
          '/home/DashBoard': (context)=> userDashboard(),
          '/home/DashBoard/history': (context)=> historySTL(),
          '/home/DashBoard/feedBack': (context)=> feedAndContact(),
          '/home/winners': (context)=> winnerScreen(),
          '/home/pubgDetails/memoryGame': (context)=> memoryGame(),
          '/home/pubgDetails/matching_game': (context)=> MatchingSTL(),
          '/home/pubgDetails/Rock,paper': (context)=> RockMainScreenSTL(),
          '/home/rules': (context)=> rulesSTL(),

        },

      ),
    ),
  ));

  ///Permission
}
class AuthCheck extends StatelessWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomeScreenSTL();
    }
    return const logInFormSTL();
  }
}


