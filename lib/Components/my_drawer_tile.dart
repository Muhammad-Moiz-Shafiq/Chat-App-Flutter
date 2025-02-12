import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const MyDrawerTile(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      hoverColor: Colors.blueAccent,
      title: Text(
        title,
      ),
      leading: Icon(icon),
    );
  }
}
