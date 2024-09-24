import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;

  void logout() {
    //Implement logout functionality
    _auth.signOut();
    Navigator.pop(context);
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
    );
  }
}
