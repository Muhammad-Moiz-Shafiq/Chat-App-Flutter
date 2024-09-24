import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String id = 'settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(),
    );
  }
}
