import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50,),
          const Text("Welcome to Pidgy Talk",style: TextStyle(fontSize: 33,fontWeight: FontWeight.w600,),)
        ],
      )),
    );
  }
}
