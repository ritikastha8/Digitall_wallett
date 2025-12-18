import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final double balance; // value from DB

  const HomeScreen({super.key, required this.balance});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFD87920);

    return Scaffold(
      // backgroundColor: Colors.white,

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// WELCOME TEXT
                const Text(
                  "Welcome To Dashboard",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// BALANCE CARD
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     color: orange,
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       /// Balance Text
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "Your Balance",
                //             style: TextStyle(
                //               color: Colors.white70,
                //               fontSize: 16,
                //             ),
                //           ),
                //           const SizedBox(height: 6),
                //           Text(
                //             "NPR ${widget.balance}",
                //             style: const TextStyle(
                //               fontSize: 28,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ],
                //       ),

                //       /// Wallet Icon
                //       SvgPicture.asset(
                //         "assets/icons/wallet.svg",
                //         height: 55,
                //         colorFilter: const ColorFilter.mode(
                //           Colors.white,
                //           BlendMode.srcIn,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 32),

                /// OPERATIONS TITLE
                // const Text(
                //   "Operations",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),

                // const SizedBox(height: 20),

                /// OPERATIONS BUTTONS
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _buildOperation("Load", "assets/icons/load.svg"),
                //     _buildOperation("Send", "assets/icons/send.svg"),
                //     _buildOperation("Scan", "assets/icons/scanner.svg"),
                //     _buildOperation("My QR", "assets/icons/myqr.svg"),
                //     _buildOperation("Topup", "assets/icons/topup.svg"),
                //   ],
                // ),

                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      /// BOTTOM NAVIGATION BAR
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: orange,
      //   unselectedItemColor: Colors.black54,
      //   onTap: (index) {
      //     if (index == 0) {
      //       // Already in home
      //     } else if (index == 1) {
      //       Navigator.pushNamed(context, '/transactions');
      //     } else if (index == 2) {
      //       Navigator.pushNamed(context, '/profile');
      //     }
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: SvgPicture.asset("assets/icons/home.svg", height: 24),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SvgPicture.asset("assets/icons/history.svg", height: 24),
      //       label: "History",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SvgPicture.asset("assets/icons/profile.svg", height: 24),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }

  /// OPERATION BUTTON WIDGET
  // Widget _buildOperation(String title, String iconPath) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(14),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF4F4F4),
  //           shape: BoxShape.circle,
  //         ),
  //         child: SvgPicture.asset(iconPath, height: 26),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         title,
  //         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  //       ),
  //     ],
  //   );
  // }
}
