import 'package:flutter/material.dart';

import '../screens/settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.flash_on,
              color: Colors.orange,
              size: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: ListTile(
              hoverColor: Colors.blueAccent,
              leading: Icon(Icons.home),
              title: Text('H O M E'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
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
        ],
      ),
    );
  }
}
