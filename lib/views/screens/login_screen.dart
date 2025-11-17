import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidgy_talk/views/screens/homescreen.dart';
import 'package:pidgy_talk/views/screens/signup_screen.dart';
import '../common/utils/colors.dart';
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

      // Navigate to HomeScreen if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );

      print("Login successful: ${userCredential.user?.email}");
    } catch (e) {
      //  Show alert dialog for login error
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
    final isPortrait = size.height > size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: backgroundColor,
        elevation: 0,
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
                      text: "Login",
                      onPressed: () {
                        login(
                          context,
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                    ),
                    SizedBox(height:
                      30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New User'),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                        }, child: Text('Sign up'))
                      ],
                    )
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
