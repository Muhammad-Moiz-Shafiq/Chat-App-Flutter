import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/auth/auth_services.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../Components/userTile.dart';

class NewChatAdder extends StatefulWidget {
  const NewChatAdder({super.key});
  static const String id = 'newChatAdder';
  @override
  State<NewChatAdder> createState() => _NewChatAdderState();
}

class _NewChatAdderState extends State<NewChatAdder> {
  final _auth = AuthService();
  final _firestore = FirebaseFirestore.instance;
  late final loggedInUser;
  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  StreamBuilder<QuerySnapshot> GetUserIDs() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final userIDs = snapshot.data?.docs;
          List<UserTile> userTiles = [];
          for (var userID in userIDs!) {
            final temp = userID.data()! as Map<String, dynamic>;
            final senderEmail = temp['email'];
            final name = temp['name'];
            final currentUser = loggedInUser?.email;
            final userName = UserTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen(
                      senderName: name,
                      senderEmail: senderEmail,
                    );
                  }));
                },
                idName: senderEmail,
                displayName: name,
                isMe: currentUser == senderEmail);
            userTiles.add(userName);
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: userTiles,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Start a New Chat...'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(child: GetUserIDs()),
        ],
      ),
    );
  }
}
