import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  File? imageFile;
  final TextEditingController fullname = TextEditingController();

  // PICK IMAGE
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) cropImage(pickedFile.path);
  }

  // CROP IMAGE
  void cropImage(String filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressQuality: 20,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  // SHOW OPTIONS DIALOG
  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void checkvalues() {
    if (fullname.text.trim().isEmpty || imageFile == null) {
      UIHelper.showAlertDialog(context, "Incomplete Data", "All fields required");
    } else {
      uploadData();
    }
  }

  Future<void> uploadData() async {
    UIHelper.showLoadingDialog(context, "Uploading Image..");

    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.uid)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      widget.userModel.fullname = fullname.text.trim();
      widget.userModel.profilepic = downloadUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .set(widget.userModel.toMap());

      log("Data uploaded successfully");

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
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
                  onTap: showPhotoOptions,
                  child: CircleAvatar(
                    radius: width * 0.18,
                    backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null)
                        ? Icon(Icons.person, size: width * 0.18)
                        : null,
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
