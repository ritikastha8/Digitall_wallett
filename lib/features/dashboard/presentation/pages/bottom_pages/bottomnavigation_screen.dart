import 'package:digital_wallett_system/features/dashboard/presentation/pages/bottom_pages/home_screen.dart';
import 'package:digital_wallett_system/screens/bottom_screen/home_screen.dart';
import 'package:digital_wallett_system/screens/bottom_screen/profile_screen.dart';
import 'package:digital_wallett_system/screens/bottom_screen/transaction_screen.dart';

import 'package:flutter/material.dart';

class BottomnavigationScreen extends StatefulWidget {
  const BottomnavigationScreen({super.key});

  @override
  State<BottomnavigationScreen> createState() => _BottomnavigationScreenState();
}

class _BottomnavigationScreenState extends State<BottomnavigationScreen> {
  //
  int _selectedIndex = 0;
  List<Widget> lstBottomScreen = [
    const HomesScreen(),
    const TransactionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NovaCash",
          style: TextStyle(
            // color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 26,
          ),
        ),
        // backgroundColor: Color(0xFFD87920),
      ),

      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_rounded),
            label: 'Transaction History',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],

        // backgroundColor: Colors.white,
        // selectedItemColor: Color(0xFFD87920),
        // unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
