// import 'package:digital_wallett_system/screens/onboarding_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigatetohome();
//   }

//   _navigatetohome() async {
//     await Future.delayed(Duration(milliseconds: 1500), () {});
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => OnBoardingScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: Text(
//                 "Welcome To",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
//               ),
//             ),
//             Container(
//               child: Text(
//                 "NovaCash",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(top: 30),
//               alignment: Alignment.center,
//               child: SvgPicture.asset(
//                 "assets/images/logonovacash.svg", //  SVG file
//                 height: 150, // adjust size as needed
//               ),
//             ),
//             SizedBox(height: 28),
//             Container(
//               child: Text(
//                 "Splash Screen",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:digital_wallett_system/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxHeight = constraints.maxHeight;
          final double maxWidth = constraints.maxWidth;

          // Use smaller side for font scaling
          final double minSide = maxHeight < maxWidth ? maxHeight : maxWidth;

          // Scale text

          double boldFontSize = minSide * 0.06;
          if (boldFontSize > 36) boldFontSize = 36;

          // Image height: 30-40% of screen height
          double imageHeight = maxHeight * 0.2;
          if (imageHeight > 140) imageHeight = 140;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "Welcome To",
                //   style: TextStyle(
                //     fontSize: normalFontSize,
                //     fontWeight: FontWeight.normal,
                //   ),
                // ),
                // SizedBox(height: minSide * 0.02),
                // Text(
                //   "NovaCash",
                //   style: TextStyle(
                //     fontSize: boldFontSize,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: minSide * 0.04),
                SvgPicture.asset(
                  "assets/images/logonovacash.svg",
                  height: imageHeight,
                ),
                SizedBox(height: minSide * 0.06),
                Text(
                  "NovaCash",
                  style: TextStyle(
                    fontFamily: 'Great Vibes',
                    fontSize: boldFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   "Splash Screen",
                //   style: TextStyle(
                //     fontSize: boldFontSize,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
