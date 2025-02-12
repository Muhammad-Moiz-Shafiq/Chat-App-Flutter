import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.onTap,
    this.idName,
    required this.displayName,
    required this.isMe,
    this.lastMessage,
    this.lastMessageTime,
  });

  final Function()? onTap;
  final String? idName;
  final bool isMe;
  final String displayName;
  final String? lastMessage;
  final DateTime? lastMessageTime;

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
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (lastMessage != null) ...[
                              SizedBox(height: 4),
                              Text(
                                lastMessage!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (idName != null) ...[
                              SizedBox(height: 2),
                              Text(
                                idName!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (lastMessageTime != null) ...[
                        SizedBox(width: 8),
                        Text(
                          _formatTime(lastMessageTime!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.year == now.year) {
      return '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}';
    }
    return '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}';
  }
}
