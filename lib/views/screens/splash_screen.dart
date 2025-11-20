import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidgy_talk/models/UserModel.dart';
import 'package:pidgy_talk/views/screens/complete_profile.dart';
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

    try {
      // Check current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Not logged in -> go to login screen
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final String uid = user.uid;

      // Try to fetch user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .get();

      if (!mounted) return;

      if (!userDoc.exists || userDoc.data() == null) {
        // No Firestore record -> send to CompleteProfile with a minimal model
        UserModel minimalModel = UserModel(
          uid: uid,
          email: user.email ?? '',
          fullname: '',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CompleteProfile(userModel: minimalModel, uid: user.uid),
          ),
        );
        return;
      }

      // Firestore record exists -> create model and go to Home
      UserModel userModel = UserModel.fromMap(userDoc.data()!);

      // If you want to check whether the profile is "complete", inspect fields, e.g. fullname:
      if (userModel.fullname == null || userModel.fullname!.trim().isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfile(userModel: userModel, uid: uid),
          ),
        );
        return;
      }

      // Profile exists & is complete -> go to Home (adjust if Homescreen accepts userModel)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Homescreen(
          userModel: userModel, uid: user.uid,)),
      );
    } catch (e, st) {
      // Log and fallback to LoginScreen
      debugPrint('Error checking login status: $e\n$st');
      if (!mounted) return;
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
