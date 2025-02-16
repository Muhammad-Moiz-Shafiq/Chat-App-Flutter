import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/new_chat.dart';
import 'package:flash_chat/services/notification/notification_services.dart';
import 'package:flash_chat/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/screens/forgot_pw.dart';
import 'package:flash_chat/screens/home_page.dart';
import 'package:flash_chat/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/chat_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  NotificationServices.instance.setNavigatorKey(navigatorKey);
  await NotificationServices.instance.initialize();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: FlashChat(),
    ),
  );
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If something goes wrong, show an error message instead of a blank screen
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong! Please restart the app."),
            );
          }

          if (snapshot.hasData) {
            return HomePage();
          }

          return WelcomeScreen();
        },
      ),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ForgotPw.id: (context) => ForgotPw(),
        HomePage.id: (context) => HomePage(),
        SettingsPage.id: (context) => SettingsPage(),
        NewChatAdder.id: (context) => NewChatAdder(),
      },
    );
  }
}
