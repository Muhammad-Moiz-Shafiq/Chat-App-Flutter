import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  UserTile(this.onTap, this.idName, this.isMe);

  Function()? onTap;
  String idName;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Icon(Icons.person),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
