import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/customWidgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPw extends StatefulWidget {
  static const String id = 'forgot_pw';
  const ForgotPw({super.key});

  @override
  State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ResetMenu(),
    );
  }
}

class ResetMenu extends StatefulWidget {
  @override
  State<ResetMenu> createState() => _ResetMenuState();
}

class _ResetMenuState extends State<ResetMenu> {
  late String email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Enter your email and we will send you a reset password link:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
              //Do something with the user input.
            },
            decoration: kTextFieldDecor.copyWith(hintText: 'Enter your email'),
          ),
          CustomButtons(
              color: Colors.lightBlueAccent,
              title: 'Reset Password',
              onPress: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              'A mail has been sent to your e-mail. Kindly check your mails.'),
                        );
                      });
                } on FirebaseAuthException catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(e.message.toString()),
                        );
                      });
                }
              })
        ],
      ),
    );
  }
}
