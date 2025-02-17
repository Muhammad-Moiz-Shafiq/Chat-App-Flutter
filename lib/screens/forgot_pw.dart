import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/customWidgets.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth/auth_services.dart';

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
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: const ResetMenu(),
    );
  }
}

class ResetMenu extends StatefulWidget {
  const ResetMenu({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your email and we will send you a reset password link:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface == Colors.white
                  ? Colors.black
                  : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              //Do something with the user input.
              setState(() {
                email = value;
              });
            },
            decoration: kTextFieldDecor.copyWith(hintText: 'Enter your email'),
          ),
          CustomButtons(
              color: Colors.lightBlueAccent,
              title: 'Reset Password',
              onPress: () async {
                try {
                  await AuthService().sendPasswordResetEmail(email: email);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Reset Password'),
                          content: const Text(
                              'A mail has been sent to your e-mail. Kindly check your mails.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    email = '';
                                  });
                                },
                                child: const Text('OK'))
                          ],
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
