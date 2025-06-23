import 'package:flutter/material.dart';
import 'package:pidgy_talk/common/utils/colors.dart';
import 'package:pidgy_talk/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  // static const routeName ='/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  @override
  void dispose(){
    super.dispose();
    phoneController.dispose();
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Pidgy talk will need to verify your Phone Number"),
              const SizedBox(height: 10),
              TextButton(onPressed: (){}, child: Text('Pick Country')),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('+91'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width*0.7,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  )
                ],
              ),
             SizedBox(height: size.height*0.6),
              SizedBox(
                width: 90,
                child:CustomButton(text: "Next", onPressed: (){}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
