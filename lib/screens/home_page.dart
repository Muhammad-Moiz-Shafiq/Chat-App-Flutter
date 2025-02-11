import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../Components/drawer.dart';
import '../Components/userTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    //Implement logout functionality
    _auth.signOut();
    Navigator.pop(context);
  }

  StreamBuilder<QuerySnapshot> GetUserIDs() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final messages = snapshot.data?.docs;
          List<UserTile> userTiles = [];
          for (var message in messages!) {
            final temp = message.data()! as Map<String, dynamic>;
            //final messageText = temp['text'];
            final senderName = temp['sender'];
            final currentUser = loggedInUser.email;
            final userName = UserTile(() {
              Navigator.pushNamed(context, ChatScreen.id);
            }, senderName, currentUser == senderName);
            userTiles.add(userName);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: userTiles,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
      ),
      drawer: MyDrawer(),
      body: GetUserIDs(),
    );
  }
}
