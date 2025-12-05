// import 'package:digital_wallett_system/screens/login_screen.dart';
// import 'package:digital_wallett_system/screens/dashboard_screen.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:digital_wallett_system/screens/onboarding_screen.dart';
import 'package:digital_wallett_system/screens/splash_screen.dart';
// import 'package:digital_wallett_system/screens/sendmoney_screen.dart';
import 'package:flutter/material.dart';
// import 'package:digital_wallett_system/screens/register_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // dummy value for balance in HomeScreen

      // home: HomeScreen(balance: 0.0),

      // home: LoginScreen(),
      // routes: {'/register': (context) => const RegisterScreen()},

      //
      home: const SplashScreen(),

      // home: AnimatedSplashScreen(
      //   splash: Icons.home,
      //   duration: 3000,
      //   splashTransition: SplashTransition.scaleTransition,
      //   backgroundColor: Colors.white,
      //   // Center(
      //   // child: Column(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: [
      //   //     Container(height: 100, width: 100, color: Colors.purpleAccent),
      //   //     Container(
      //   //       child: Text(
      //   //         "Splash Screen",
      //   //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //   //       ),
      //   //     ),
      //   //   ],
      //   // ),
      //   // ),
      //   nextScreen: OnBoardingScreen(),
      // ),
    );
  }
}
