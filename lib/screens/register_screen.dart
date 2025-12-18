// import 'package:digital_wallett_system/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _passwordController.dispose();
//     _confirmController.dispose();
//     super.dispose();
//   }

//   void _onRegisterPressed() {
//     if (!_formKey.currentState!.validate()) return;

//     // Show SnackBar first
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Registration successful!")));

//     // Wait for 1.5 seconds and then navigate to Login
//     Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     const orange = Color(0xFFD87920);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Register New Account',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 32),

//                 /// Logo
//                 // Logo
//                 Container(
//                   padding: const EdgeInsets.only(top: 30),
//                   alignment: Alignment.center,
//                   child: SvgPicture.asset(
//                     "assets/images/logonovacash.svg", // your SVG file path
//                     height: 150, // adjust size as needed
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 /// Form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       _buildField(
//                         controller: _nameController,
//                         hint: 'Enter your full name',
//                       ),
//                       const SizedBox(height: 16),

//                       _buildField(
//                         controller: _mobileController,
//                         hint: 'Enter your mobile number',
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter mobile number';
//                           }
//                           if (value.length < 10) {
//                             return 'Mobile number must be at least 10 digits';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),

//                       _buildField(
//                         controller: _passwordController,
//                         hint: 'Enter your password',
//                         obscure: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),

//                       _buildField(
//                         controller: _confirmController,
//                         hint: 'Confirm password',
//                         obscure: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please confirm password';
//                           }
//                           if (value != _passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 /// Register Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _onRegisterPressed,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: orange,
//                       foregroundColor: Colors.white,
//                       shape: const StadiumBorder(),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text(
//                       'Register Account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Already have an account?  '),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'Log In',
//                         style: TextStyle(
//                           color: orange,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Reusable input field
//   Widget _buildField({
//     required TextEditingController controller,
//     required String hint,
//     bool obscure = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     const orange = Color(0xFFD87920);

//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: const Color(0xFFF4F4F4),
//         hintText: hint,
//         hintStyle: const TextStyle(color: orange, fontSize: 16),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator:
//           validator ??
//           (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Field required';
//             }
//             return null;
//           },
//     );
//   }
// }

import 'package:digital_wallett_system/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Registration successful!")));

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
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
                Text('Register New Account'),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/logonovacash.svg",
                    height: 150,
                  ),
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        controller: _nameController,
                        hint: 'Enter your full name',
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _mobileController,
                        hint: 'Enter your mobile number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter mobile number';
                          if (value.length < 10)
                            return 'Mobile number must be at least 10 digits';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _passwordController,
                        hint: 'Enter your password',
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter password';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _confirmController,
                        hint: 'Confirm password',
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please confirm password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    child: Text('Register Account'),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log In',
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
      validator:
          validator ??
          (value) =>
              (value == null || value.trim().isEmpty) ? 'Field required' : null,
    );
  }
}
