import 'package:digital_wallett_system/screens/dashboard_screen.dart';
import 'package:digital_wallett_system/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // Validate the form first
    if (!_formKey.currentState!.validate()) {
      // If validation fails, do nothing
      return;
    }

    // Show success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful!"),
        duration: Duration(seconds: 1),
      ),
    );

    // Navigate to HomeScreen after SnackBar disappears
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(balance: 5000),
        ),
      );
    });
  }

  void _onForgotPassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Forgot Password tapped")));
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFD87920);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Log In',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 36),

                /// LOGO
                // logo
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/logonovacash.svg", //  SVG file
                    height: 150, // adjust size as needed
                  ),
                ),

                const SizedBox(height: 48),

                /// FORM
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: const Color(0xFFF4F4F4),
                          hintText: 'Enter your mobile number',
                          // hintStyle: const TextStyle(
                          //   color: orange,
                          //   fontSize: 16,
                          // ),
                          // contentPadding: const EdgeInsets.symmetric(
                          //   horizontal: 20,
                          //   vertical: 16,
                          // ),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          //   borderSide: BorderSide.none,
                          // ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.trim().length < 10) {
                            return 'Enter valid mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: const Color(0xFFF4F4F4),
                          hintText: 'Enter your password',
                          // hintStyle: const TextStyle(
                          //   color: orange,
                          //   fontSize: 16,
                          // ),
                          // contentPadding: const EdgeInsets.symmetric(
                          //   horizontal: 20,
                          //   vertical: 16,
                          // ),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          //   borderSide: BorderSide.none,
                          // ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _onForgotPassword,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLoginPressed,
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: const Color.fromARGB(255, 216, 121, 32),
                    //   foregroundColor: Colors.white,
                    //   shape: const StadiumBorder(),
                    //   padding: const EdgeInsets.symmetric(vertical: 16),
                    // ),
                    child: Text(
                      'Log In',
                      // style: TextStyle(
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.w600,
                      // ),
                      style:
                          Theme.of(context).elevatedButtonTheme.style?.textStyle
                              ?.resolve(const {}) ??
                          const TextStyle(), // uses theme style
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium, // Roboto Regular
                      // style: TextStyle(color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: _onRegister,
                      child: const Text(
                        'Register here',

                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
