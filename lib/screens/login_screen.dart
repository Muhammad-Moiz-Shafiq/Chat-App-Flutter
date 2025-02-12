import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/auth/auth_services.dart';
import 'package:flash_chat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/customWidgets.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Components/my_snackbar.dart';
import 'forgot_pw.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  final _auth = FirebaseAuth.instance;
  final usernameController = TextEditingController(),
      passwordController = TextEditingController();
  bool showSpinner = false;

  void login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        showSpinner = true;
        usernameController.clear();
        passwordController.clear();
      });
      try {
        await AuthService().signInWithEmailAndPassword(email, password);
        Navigator.pushNamed(context, HomePage.id);
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          createMySnackBar(context),
        );
        setState(() {
          showSpinner = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        createMySnackBar(context),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: usernameController,
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
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForgotPw.id);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomButtons(
                onPress: login,
                color: Colors.lightBlueAccent,
                title: 'Log in',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
