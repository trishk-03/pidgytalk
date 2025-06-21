import 'package:flutter/material.dart';
import 'package:pidgy_talk/common/widgets/custom_button.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height / 9),
          const Text("Welcome to Pidgy Talk",style: TextStyle(fontSize: 33,fontWeight: FontWeight.w600),),

          SizedBox(height: 50),
          Image.asset("assets/images/PidgyTalk_app-removebg-.png",height: 340,width: 340,),
          SizedBox(height: size.height / 9),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(width: size.width*0.75,
              child: CustomButton(text: "Agree and Continue",onPressed: (){},))
        ],
      )),
    );
  }
}
