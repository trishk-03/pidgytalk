import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pidgy_talk/views/screens/homescreen.dart';
import 'package:pidgy_talk/views/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // call the function
  }
   // Navigation Logic
  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));

    // Check current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in go to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    } else {
      // User not logged in go to Login_Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/PidgyTalk_app-removebg-.png',
          width: 120,
        ),
      ),
    );
  }
}
