import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pidgy_talk/models/ChatRoomModel.dart';
import 'package:pidgy_talk/models/UserModel.dart';
import 'package:pidgy_talk/views/common/widgets/custom_textfield.dart';
import 'chatroom.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final String uid;

  const SearchScreen({super.key, required this.userModel, required this.uid});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(String targetUserId) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.$targetUserId", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs[0].data() as Map<String, dynamic>;
      chatRoom = ChatRoomModel.fromMap(data);
      log("Existing chatroom found");
    } else {
      String chatroomId = DateTime.now().millisecondsSinceEpoch.toString();
      ChatRoomModel newRoom = ChatRoomModel(
        chatroomid: chatroomId,
        lastMessage: "",
        participants: {
          widget.userModel.uid!: true,
          targetUserId: true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .set(newRoom.toMap());

      chatRoom = newRoom;
      log("New chatroom created");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: const Text("Search User"),
          backgroundColor: Colors.green.shade700,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomTextfield(
                hintText: "Search by name",
                controller: searchController,
                prefixIcon: Icons.search,
              ),
            ),
            const SizedBox(height: 10),

            searchController.text.trim().isEmpty
                ? const Text("Search someone by name")
                : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("fullname", isEqualTo: searchController.text.trim())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No user found");
                }

                var docs = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index)  {
                      var userData = docs[index].data();

                      UserModel targetUser = UserModel(
                        uid: userData["uid"] ?? "",
                        fullname: userData["fullname"] ?? "",
                        email: userData["email"] ?? "",
                        initialletter: userData["initialletter"] ?? "",
                      );

                      return Card(
                        color: Colors.green.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              targetUser.initialletter ?? "",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                          title: Text(targetUser.fullname ?? ""),
                          subtitle: Text(targetUser.email ?? ""),
                          onTap: () async {
                            ChatRoomModel? chatroom =
                            await getChatRoomModel(targetUser.uid ?? "");

                            if (chatroom != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Chatroom(
                                      targetUser: targetUser,
                                      userModel: widget.userModel,
                                      uid: widget.uid,
                                      chatroom: chatroom,
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }
}
