import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // for space
            SizedBox(height: 100),
            // text that is login
            Text("LOGIN", style: TextStyle(fontSize: 54)),

            // logo
            Container(
              padding: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Image.asset("assets/images/logonovac.png", height: 150),
            ),

            // for space
            SizedBox(height: 40),
            // for enter mobile number box and text
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Mobile Number",

                border: OutlineInputBorder(),
              ),
            ),
            // space
            SizedBox(height: 40),

            // for password
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Password",
                border: OutlineInputBorder(),
              ),
            ),

            // for forgot button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  //ACTION FOR THIS FORGOT SHOULD BE HERE
                },
                child: Text(
                  "Forgot Password ?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            // space
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, // sets button color
                foregroundColor: Colors.black, // sets text color
                padding: EdgeInsets.symmetric(vertical: 16), // optional height
                textStyle: TextStyle(fontSize: 18), // optional font size
              ),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
