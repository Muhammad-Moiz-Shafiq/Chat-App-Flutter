import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_services.dart';
import '../screens/settings.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  final String userName;
  const MyDrawer({super.key, required this.userName});
  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 30, top: 90),
            child: Icon(
              Icons.flash_on,
              color: Colors.orange,
              size: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 6),
            child: ListTile(
              title: Center(
                child: Text(
                  'Welcome, ${userName}',
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Divider(
              indent: 40,
              endIndent: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: MyDrawerTile(
                title: 'H O M E',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: ListTile(
              hoverColor: Colors.blueAccent,
              leading: Icon(Icons.settings),
              title: Text('S E T T I N G S'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, SettingsPage.id);
              },
            ),
          ),
          const Spacer(),
          Divider(
            indent: 40,
            endIndent: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18, bottom: 20, top: 12),
            child: MyDrawerTile(
              title: 'L O G O U T',
              icon: Icons.logout,
              onTap: () {
                logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
