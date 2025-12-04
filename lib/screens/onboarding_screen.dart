// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});

//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   late PageController _pageController;

//   int _pageIndex = 0;
//   @override
//   void initState() {
//     _pageController = PageController(initialPage: 0);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: demoData.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _pageIndex = index;
//                   });
//                 },
//                 itemBuilder: (context, index) => OnboardContent(
//                   image: demoData[index].image,
//                   title: demoData[index].title,
//                   description: demoData[index].description,
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 ...List.generate(
//                   demoData.length,
//                   (index) => Padding(
//                     padding: EdgeInsets.only(right: 4),
//                     child: DotIndicator(isActive: index == _pageIndex),
//                   ),
//                 ),

//                 const Spacer(),
//                 SizedBox(
//                   height: 80,
//                   width: 80,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _pageController.nextPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.ease,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: const CircleBorder(),
//                     ),
//                     child: SvgPicture.asset("assets/icons/rightarroww.svg"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DotIndicator extends StatelessWidget {
//   const DotIndicator({super.key, this.isActive = false});

//   final bool isActive;
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       height: isActive ? 12 : 4,
//       width: 4,
//       decoration: BoxDecoration(
//         color: isActive ? Colors.amber.withValues(alpha: 0.4) : Colors.amber,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
// }

// class Onboard {
//   final String image, title, description;
//   Onboard({
//     required this.image,
//     required this.title,
//     required this.description,
//   });
// }

// final List<Onboard> demoData = [
//   Onboard(
//     image: "assets/images/onboardingmanagemoney.png",
//     title: "Manage Money Easily",
//     description:
//         "Check wallet balance, load money, and track transactions instantly. ",
//   ),
//   Onboard(
//     image: "assets/images/onboardingsecurepayment.png",
//     title: "Secure Payment",
//     description:
//         "Make payments with confidence using our advanced security features.",
//   ),
//   Onboard(
//     image: "assets/images/onboardingtrackexpenses.png",
//     title: "Track Expenses",
//     description:
//         "Monitor your spending habits and stay within your budget effortlessly.",
//   ),
// ];

// class OnboardContent extends StatelessWidget {
//   const OnboardContent({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.description,
//   });
//   final String image, title, description;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Spacer(),
//         Image.asset(image, height: 250),
//         const Spacer(),
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: Theme.of(
//             context,
//           ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         Text(description, textAlign: TextAlign.center),
//         const Spacer(),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/onboard_model.dart';
import '../widgets/onboard_widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: demoData.length,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  image: demoData[index].image,
                  title: demoData[index].title,
                  description: demoData[index].description,
                ),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                  demoData.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: DotIndicator(isActive: index == _pageIndex),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: SvgPicture.asset("assets/icons/rightarroww.svg"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
