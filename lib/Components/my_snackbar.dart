import 'package:flutter/material.dart';

import '../screens/welcome_screen.dart';

class MySnackBar extends StatelessWidget {
  const MySnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      content: const Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Invalid credentials. Kindly Try Again',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Go Back',
        textColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, WelcomeScreen.id);
        },
      ),
    );
  }
}
