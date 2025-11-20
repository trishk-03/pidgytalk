import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidgy_talk/models/UserModel.dart';
import 'package:pidgy_talk/models/UIHelper.dart';
import 'package:pidgy_talk/views/common/widgets/custom_button.dart';
import 'package:pidgy_talk/views/common/widgets/custom_textfield.dart';
import 'package:pidgy_talk/views/screens/homescreen.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final String uid;

  const CompleteProfile({super.key, required this.userModel, required this.uid});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  final TextEditingController fullname = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;


  late String initialLetter;

  @override
  void initState() {
    super.initState();

    // Safely extract first letter
    initialLetter = (widget.userModel.fullname != null &&
        widget.userModel.fullname!.isNotEmpty)
        ? widget.userModel.fullname![0].toUpperCase()
        : "";
  }


  void checkvalues() {
    if (fullname.text.trim().isEmpty) {
      UIHelper.showAlertDialog(context, "Incomplete Data", "All fields required");
    } else {
      uploadData();
    }
  }

  Future<void> uploadData() async {

    try {

      widget.userModel.fullname = fullname.text.trim();
      widget.userModel.initialletter = widget.userModel.fullname![0].toUpperCase();


      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .set(widget.userModel.toMap(),);

      log("Data uploaded successfully");

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen(
            userModel: widget.userModel, uid: user!.uid,
        )),
      );

    } catch (e) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(context, "Error", e.toString());
    }
  }

  @override
  void dispose() {
    fullname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.06),

                InkWell(
                  child: CircleAvatar(
                    radius: width * 0.18,
                    backgroundColor: Colors.green.shade700,
                    child: Text(
                      fullname.text.trim().isNotEmpty
                          ? fullname.text.trim()[0].toUpperCase()
                          : (widget.userModel.fullname != null &&
                          widget.userModel.fullname!.isNotEmpty)
                          ? widget.userModel.fullname![0].toUpperCase()
                          : "",
                      style: TextStyle(
                        fontSize: width * 0.1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: height * 0.06),

                Container(
                  padding: const EdgeInsets.all(16),
                  child: CustomTextfield(
                    hintText: "Enter your Full Name",
                    prefixIcon: Icons.person,
                    controller: fullname,
                  ),
                ),

                SizedBox(height: height * 0.07),

                CustomButton(
                  text: "Submit",
                  onPressed: checkvalues,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
