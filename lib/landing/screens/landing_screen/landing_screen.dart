import 'package:flutter/material.dart';
import 'package:pidgy_talk/common/widgets/custom_button.dart';
import 'package:pidgy_talk/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double verticalPadding = size.height * 0.05;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Helps in small screen sizes
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Pidgy Talk",
                  style: TextStyle(
                    fontSize: size.width * 0.08, // Responsive text size
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.04),

                // Responsive Image
                SizedBox(
                  height: size.height * 0.4,
                  width: size.width * 0.8,
                  child: Image.asset(
                    "assets/images/PidgyTalk_app-removebg-.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: size.height * 0.1),

                SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                    text: "Agree and Continue",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
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
