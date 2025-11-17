import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/utils/colors.dart';
import '../common/widgets/custom_alert_box.dart';
import '../common/widgets/custom_button.dart';
import '../common/widgets/custom_textfield.dart';
import 'homescreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //  Sign up function
  Future<void> signup(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      CustomAlert.showRequiredFieldsAlert(context);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //  Optional: Update display name
      if (nameController.text.isNotEmpty) {
        await userCredential.user?.updateDisplayName(nameController.text);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );

      //  Navigate or show success message
      print("Signed up: ${userCredential.user?.email}");
    } catch (e) {
      print("Signup error: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.red[900],
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }
  }

  @override

  // disposing the controllers
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isPortrait ? size.height * 0.06 : 30),
                    CustomTextfield(
                      hintText: 'Enter Your Name',
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: 'Enter Your Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      hintText: 'Enter Your Password',
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: "Sign Up",
                      onPressed: () {
                        signup(
                          context,
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
