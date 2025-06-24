import 'package:flutter/material.dart';
import 'package:pidgy_talk/common/utils/colors.dart';
import 'package:pidgy_talk/common/widgets/custom_button.dart';
import 'package:pidgy_talk/common/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    final isPortrait = size.height > size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                        print("Name: ${nameController.text}");
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");
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
