import 'package:flash_chat/auth/auth_services.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/customWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Components/my_snackbar.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'reg';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email, password, displayName;
  final _auth = FirebaseAuth.instance;
  final usernameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool showSpinner = false;

  void register() async {
    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Password'),
          content: const Text('Password should be at least 6 characters long'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        displayName.isNotEmpty &&
        (email.endsWith('@gmail.com') ||
            email.endsWith('@yahoo.com') ||
            email.endsWith('@hotmail.com') ||
            email.endsWith('@outlook.com'))) {
      try {
        setState(() {
          showSpinner = true;
          usernameController.clear();
          passwordController.clear();
          emailController.clear();
        });
        await AuthService()
            .registerWithEmailAndPassword(email, password, displayName);
        setState(() {
          showSpinner = false;
        });
        Navigator.pushNamed(context, HomePage.id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const MySnackBar() as SnackBar,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const MySnackBar() as SnackBar,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: usernameController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  displayName = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecor.copyWith(hintText: 'Enter your Name'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: emailController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecor.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecor.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomButtons(
                color: Colors.blueAccent,
                title: 'Register',
                onPress: register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
