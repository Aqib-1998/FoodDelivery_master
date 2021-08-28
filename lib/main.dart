import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Utils/auth.dart';
import 'package:food_delivery/Utils/auth_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'Pages/LoginScreen.dart';
import 'package:page_transition/page_transition.dart';

Color defaultColor =  HexColor('#7AC301');
Color customButtonColor = HexColor('#F4F4F4');
Color ratingColor = HexColor('#FFD200');
Color textFieldColor = HexColor('#DEDEDE');
Color textFieldFillColor = HexColor('#e6e6e6');
Color totalFieldColor =HexColor('#C4C4C4');
String appId = "ebb451e6-249d-4e68-9b16-7a04100a8edb";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  void initState() {
    super.initState();
    configOneSignal();
  }
  void configOneSignal()
  {
    OneSignal.shared.init(appId);
  }

  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Food Delivery',
        theme: ThemeData(fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3,
            splash: "lib/Images/SplashScreen.jpg",
            nextScreen: CheckUser(auth: Auth(),),
            splashIconSize: 75.0,
            animationDuration: Duration(seconds: 1),
            pageTransitionType: PageTransitionType.leftToRightWithFade,
            splashTransition: SplashTransition.slideTransition,
            backgroundColor: Colors.white
        ),
      ),
    );
  }
}
