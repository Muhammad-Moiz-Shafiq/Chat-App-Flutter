import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  late String senderName;
  late String senderEmail;
  ChatScreen({super.key, required this.senderName, required this.senderEmail});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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

  //
  // void getMessagesStream() async {
  //   try {
  //     await for (var messages in _firestore.collection('messages').snapshots())
  //       for (var message in messages.docs) {
  //         print(message.data());
  //       }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.senderName),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
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
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages!) {
                    final temp = message.data()! as Map<String, dynamic>;
                    if (temp['sender'] == loggedInUser.email &&
                            temp['receiver'] == widget.senderEmail ||
                        temp['sender'] == widget.senderEmail &&
                            temp['receiver'] == loggedInUser.email) {
                      final messageText = temp['text'];
                      final senderName = temp['sender'];
                      final currentUser = loggedInUser.email;
                      final textWidget = MessageBubble(
                        messageText,
                        widget.senderName,
                        currentUser == senderName,
                      );
                      messageWidgets.add(textWidget);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      children: messageWidgets,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //print(FieldValue.serverTimestamp().);
                      //storing data to fireStore database
                      try {
                        _firestore.collection('messages').add({
                          'text': message,
                          'sender': loggedInUser.email,
                          'receiver': widget.senderEmail,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      } catch (e) {
                        print(e);
                      }
                      //Implemented send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
    this.messageText,
    this.senderName,
    this.isMe,
  );
  final String messageText;
  final String senderName;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? 'You' : senderName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 14,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe
                ? Colors.lightBlueAccent
                : Theme.of(context).colorScheme.inversePrimary,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                messageText,
                style: isMe
                    ? TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface)
                    : TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
