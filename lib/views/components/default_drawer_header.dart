import 'package:flutter/material.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/services/locator.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/components/user_status_view.dart';

class DefaultDrawerHeader extends StatelessWidget {
  const DefaultDrawerHeader({
    Key? key,
    required this.authInfo,
  }) : super(key: key);

  final AuthInfo authInfo;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: ()=>_onAvatarTap(context),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryIconTheme.color,
                  radius: 35,
                  child: Text(authInfo.user.login[0]),
                ),
              ),
            ]
          ),
          Row(
            children: [
              UserStatusView(user: authInfo.user,showAvatar: false)
            ],
          )
        ],
      )
    );
  }

  void _onAvatarTap(BuildContext context) {
    Navigator.of(context).push(AppRoute.profile.route.build(authInfo));
  }
}