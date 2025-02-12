import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/customWidgets.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    // controller.addStatusListener((status) {
    //   //print(status);
    //   if (status == AnimationStatus.completed)
    //     controller.reverse(from: 1.0);
    //   else if (status == AnimationStatus.dismissed) controller.forward();
    // });
    controller.addListener(() {
      setState(() {});
      //print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60,
                    ),
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.surface ==
                                Colors.white
                            ? Colors.black
                            : Colors.white),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Flash Chat',
                            speed: const Duration(milliseconds: 90)),
                      ],
                      onTap: () {
                        //print('jjjo');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48.0,
              ),
              CustomButtons(
                onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                  //Go to login screen.
                },
                color: Colors.lightBlueAccent,
                title: 'Log in',
              ),
              CustomButtons(
                color: Colors.blueAccent,
                title: 'Register',
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                  //Go to registration screen.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
