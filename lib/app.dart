import 'package:digital_wallett_system/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_wallett_system/screens/register_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {'/register': (context) => const RegisterScreen()},
    );
  }
}