import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidgy_talk/models/UserModel.dart';
import 'package:pidgy_talk/views/screens/complete_profile.dart';
import '../common/widgets/custom_alert_box.dart';
import '../common/widgets/custom_button.dart';
import '../common/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Signup function

  Future<void> signup(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty || nameController.text.isEmpty) {
      CustomAlert.showRequiredFieldsAlert(context);
      return;
    }

    try {
      // SIGN UP WITH FIREBASE AUTH
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // UPDATE NAME IN FIREBASE AUTH PROFILE
      await userCredential.user?.updateDisplayName(nameController.text.trim());

      // CREATE USER MODEL
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: nameController.text.trim(),
        profilepic: "",
      );

      // STORE USER IN FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newUser.toMap());

      print("New user created and saved in Firestore");

      // NAVIGATE TO COMPLETE PROFILE
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteProfile(
            userModel: newUser,
            uid: uid,
          ),
        ),
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.red[900],
          title: const Text('Signup Failed', style: TextStyle(color: Colors.white)),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
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
                    SizedBox(height: size.height * 0.04),


                    CircleAvatar(
                      radius: size.width * 0.15,
                      backgroundColor: Colors.green.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        size: size.width * 0.15,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // FORM CARD
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
                            hintText: 'Enter Your Full Name',
                            controller: nameController,
                            prefixIcon: Icons.person,
                          ),
                          const SizedBox(height: 20),
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

                    // BUTTON
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

                    SizedBox(height: size.height * 0.03),

                    // ALREADY HAVE ACCOUNT?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Already have an account?"),
                        SizedBox(width: 4),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
