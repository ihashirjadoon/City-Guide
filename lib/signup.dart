import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController userEmail = TextEditingController();
TextEditingController userPhone = TextEditingController();
TextEditingController userPassword = TextEditingController();
TextEditingController userConfirmP = TextEditingController();
User? currentUser = FirebaseAuth.instance.currentUser;

class _SignUpState extends State<SignUp> {
  // Boolean variables to control password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyProject'),
        backgroundColor: Colors.lightGreen[600], // Light green app bar
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightGreen[100], // Light green background
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            margin: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[800], // Light green text
                  ),
                ),
                // Email field
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userEmail,
                    decoration: InputDecoration(
                      label: Text(
                        "Enter Your Email",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[600]!),
                      ),
                    ),
                  ),
                ),
                // Phone number field
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userPhone,
                    decoration: InputDecoration(
                      label: Text(
                        "Phone Number",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[600]!),
                      ),
                    ),
                  ),
                ),
                // Password field
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userPassword,
                    obscureText:
                        !_isPasswordVisible, // Toggle password visibility
                    decoration: InputDecoration(
                      label: Text(
                        "Enter Your Password",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[600]!),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.lightGreen[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // Confirm Password field
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: userConfirmP,
                    obscureText:
                        !_isConfirmPasswordVisible, // Toggle confirm password visibility
                    decoration: InputDecoration(
                      label: Text(
                        "Confirm Password",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[600]!),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.lightGreen[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // Sign up button
                Container(
                  width: double.infinity,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      var email = userEmail.text.trim();
                      var phone = userPhone.text.trim();
                      var password = userPassword.text.trim();
                      var confirmPassword = userConfirmP.text.trim();

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Passwords do not match!")),
                        );
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) {
                          log("User Created");
                          SignupUser(email, phone, password, confirmPassword);
                        });
                      } on FirebaseAuthException catch (e) {
                        log("Error: ${e.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(e.message ?? "Sign-up failed")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[600], // Button color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Sign Up"),
                  ),
                ),
                // Sign-in link
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Colors.lightGreen[700],
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void SignupUser(
    String email, String phone, String password, String confirmPassword) {
  if (password != confirmPassword) {
    log("Passwords do not match");
    return;
  }

  log("User signed up successfully!");
  log("Email: $email, Phone: $phone");
}
