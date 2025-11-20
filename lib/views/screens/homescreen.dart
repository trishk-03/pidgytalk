import 'package:flutter/material.dart';
import 'package:pidgy_talk/models/UserModel.dart';
import 'package:pidgy_talk/views/screens/search_screen.dart';

class Homescreen extends StatefulWidget {
  final UserModel userModel;
  final String uid;

  const Homescreen({
    super.key,
    required this.userModel,
    required this.uid,
  });

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green.shade700,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hey ${widget.userModel.fullname}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(Icons.person, color: Colors.green.shade700),
            ),
          )
        ],
      ),

      body: Center(
        child: Text(
          "Your Home Screen Content",
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ),

      // Floating Action Button for Search
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  SearchScreen()),
          );
        },
        child: const Icon(Icons.search, size: 28),
      ),
    );
  }
}
