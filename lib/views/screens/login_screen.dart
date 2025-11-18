import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidgy_talk/views/screens/complete_profile.dart';
import 'package:pidgy_talk/views/screens/signup_screen.dart';
import '../../models/UserModel.dart';
import '../common/widgets/custom_alert_box.dart';
import '../common/widgets/custom_button.dart';
import '../common/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Login function
  Future<void> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      CustomAlert.showRequiredFieldsAlert(context);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;


      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompleteProfile( userModel: userModel,
          uid: uid ),
      ));
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.red[900],
          title: const Text('Login Failed', style: TextStyle(color: Colors.white)),
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white70),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.03),

                    /// LOGO AVATAR
                    CircleAvatar(
                      radius: size.width * 0.18,
                      backgroundColor: Colors.green.withOpacity(0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/images/PidgyTalk_app-removebg-.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    /// FORM CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextfield(
                            hintText: 'Enter Your Email',
                            controller: emailController,
                            prefixIcon: Icons.email,
                          ),
                          const SizedBox(height: 20),
                          CustomTextfield(
                            hintText: 'Enter Your Password',
                            controller: passwordController,
                            obscureText: true,
                            prefixIcon: Icons.lock,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // LOGIN BUTTON
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        login(
                          context,
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New User?',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.03),
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
