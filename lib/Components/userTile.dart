import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.onTap,
      required this.idName,
      required this.displayName,
      required this.isMe});

  final Function()? onTap;
  final String idName;
  final bool isMe;
  final String displayName;
  @override
  Widget build(BuildContext context) {
    return isMe
        ? Container()
        : Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 22,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          Text(
                            idName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      if (isMe)
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                endIndent: 25,
                indent: 25,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          );
  }
}
