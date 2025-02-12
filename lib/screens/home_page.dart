import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/auth/auth_services.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/drawer.dart';
import '../Components/userTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  final _firestore = FirebaseFirestore.instance;
  late final loggedInUser;
  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  void logout() {
    //Implement logout functionality
    _auth.signOut();
    Navigator.pop(context);
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool exitApp = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Exit App?"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    AuthService().signOut();
                    SystemNavigator.pop(); // Exit the app
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (exitApp == true) {
            SystemNavigator.pop(); // Exit the app
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
        drawer: MyDrawer(
          userName: _auth.getUserDisplayName(),
        ),
        body: Column(
          children: [
            Expanded(child: GetUserIDs()),
          ],
        ),
      ),
    );
  }
}
