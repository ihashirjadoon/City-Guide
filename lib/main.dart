import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'signin.dart';
import 'signup.dart';
import 'fpassword.dart';
import 'AddAttraction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  runApp(GetMaterialApp(
    title: 'City Guide',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    getPages: [
      GetPage(name: '/', page: () => const SignIn()),
      GetPage(name: '/signup', page: () => const SignUp()),
      GetPage(name: '/fpassword', page: () => const Fpassword()),
      GetPage(name: '/add-attraction', page: () => AddAttractionScreen()),
    ],
    debugShowCheckedModeBanner: false,
  ));
}
