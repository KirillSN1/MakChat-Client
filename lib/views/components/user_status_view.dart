import 'package:flutter/material.dart';
import 'package:matcha/models/user/user.dart';

class UserStatusView extends StatelessWidget {
  final User user;
  final bool showAvatar;
  const UserStatusView({super.key, required this.user, this.showAvatar = true});

  @override
  Widget build(BuildContext context) {
    final thame = Theme.of(context);
    return Row(
      children: [
        if(showAvatar)
        CircleAvatar(
          backgroundColor: thame.primaryIconTheme.color,
          radius: 25,
          child: Text(user.login[0]),
        ),
        Padding(
          padding: EdgeInsets.only(left:showAvatar?10:0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.login, style: thame.textTheme.bodyLarge),
              Text("В сети", style: thame.textTheme.bodySmall)
            ],
          ),
        )
      ],
    );
  }
}