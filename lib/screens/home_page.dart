import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/auth/auth_services.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/drawer.dart';
import '../Components/userTile.dart';
import 'new_chat.dart';

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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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

  StreamBuilder<QuerySnapshot> searchUsers(String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
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
          final senderEmail = temp['email'].toString();
          final name = temp['name'].toString();
          final currentUser = loggedInUser?.email;

          if (query.isEmpty ||
              name.toLowerCase().contains(query.toLowerCase()) ||
              senderEmail.toLowerCase().contains(query.toLowerCase())) {
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
              isMe: currentUser == senderEmail,
            );
            userTiles.add(userName);
          }
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: userTiles,
        );
      },
    );
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
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {});
                  },
                )
              : Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
        ),
        drawer: MyDrawer(
          userName: _auth.getUserDisplayName(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, NewChatAdder.id);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          tooltip: 'Click to tart a chat with other users',
        ),
        body: Column(
          children: [
            Expanded(
              child: _isSearching
                  ? searchUsers(_searchController.text)
                  : StreamBuilder<QuerySnapshot>(
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

                        Map<String, Map<String, dynamic>> latestMessages = {};
                        final messages = snapshot.data?.docs;

                        for (var message in messages!) {
                          final messageData =
                              message.data() as Map<String, dynamic>;
                          final sender = messageData['sender'];
                          final receiver = messageData['receiver'];
                          final currentUserEmail = loggedInUser?.email;

                          if (sender != currentUserEmail &&
                              receiver != currentUserEmail) {
                            continue;
                          }

                          final otherUser =
                              sender == currentUserEmail ? receiver : sender;

                          if (!latestMessages.containsKey(otherUser) ||
                              (messageData['timestamp'] != null &&
                                  (latestMessages[otherUser]!['timestamp'] ==
                                          null ||
                                      messageData['timestamp'].toDate().isAfter(
                                          latestMessages[otherUser]![
                                                  'timestamp']
                                              .toDate())))) {
                            latestMessages[otherUser] = messageData;
                          }
                        }

                        return FutureBuilder<List<UserTile>>(
                          future: _buildUserTiles(latestMessages),
                          builder: (context, userTilesSnapshot) {
                            if (!userTilesSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              children: userTilesSnapshot.data!,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<UserTile>> _buildUserTiles(
      Map<String, Map<String, dynamic>> latestMessages) async {
    List<UserTile> userTiles = [];

    for (var entry in latestMessages.entries) {
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: entry.key)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        final userName = userData['name'];
        final userEmail = userData['email'];

        // Get the last message details
        final lastMessageData = entry.value;
        final lastMessageText = lastMessageData['text'] as String?;
        final timestamp = lastMessageData['timestamp'] as Timestamp?;
        final DateTime? lastMessageTime = timestamp?.toDate();

        final userTile = UserTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatScreen(
                senderName: userName,
                senderEmail: userEmail,
              );
            }));
          },
          displayName: userName,
          isMe: loggedInUser?.email == userEmail,
          lastMessage: lastMessageText,
          lastMessageTime: lastMessageTime,
        );
        userTiles.add(userTile);
      }
    }

    return userTiles;
  }
}
