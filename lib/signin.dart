import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'HomeScreen.dart';
import 'fpassword.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

TextEditingController loginEmail = TextEditingController();
TextEditingController loginPassword = TextEditingController();

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;

  Future<bool> isAdmin(String userId) async {
    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('Admin')
          .doc('FirstAdmin')
          .get();

      if (adminDoc.exists && adminDoc.data()?['UserID'] == userId) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Guide'),
        backgroundColor: Colors.lightGreen[600],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightGreen[100],
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
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
                  "Sign In",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[800],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: loginEmail,
                    decoration: InputDecoration(
                      label: Text(
                        "Enter Your Email",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.lightGreen[700]!),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  width: double.infinity,
                  child: TextFormField(
                    controller: loginPassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      label: Text(
                        "Enter Your Password",
                        style: TextStyle(color: Colors.lightGreen[800]),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.lightGreen[700]!),
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
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Fpassword()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.lightGreen[700],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      var loginemail = loginEmail.text.trim();
                      var loginpassword = loginPassword.text.trim();
                      try {
                        final User? firebaseUser = (await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: loginemail, password: loginpassword))
                            .user;

                        if (firebaseUser != null) {
                          bool isAdminUser = await isAdmin(firebaseUser.uid);
                          if (isAdminUser) {
                            Get.to(() => const HomeScreen());
                          } else {
                            Get.to(() => const HomeScreen());
                          }
                        } else {
                          print("Check Email or Password");
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage =
                            'Something went wrong. Please try again.';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Incorrect password provided for that user.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'The email address is not valid.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Sign In"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: Colors.lightGreen[700],
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/signup');
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
