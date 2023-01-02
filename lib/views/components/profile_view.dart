import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:matcha/router/app_router.dart';
import 'package:matcha/routes/app_route_enum.dart';
import 'package:matcha/services/auth/auth.dart';
import 'package:matcha/services/repositories/auth/auth_info.dart';
import 'package:matcha/views/components/user_status_view.dart';
import 'package:matcha/views/scaffold/default_app_bar.dart';

class ProfileView extends StatelessWidget {
  final AuthInfo authInfo;
  const ProfileView({super.key, required this.authInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: DefaultAppBar(),
      body: Column(
        children: [
          _ProfileRawDecoration(child:  UserStatusView(user: authInfo.user)),
          _ProfileRawDecoration(
            child: Row(children: [
              const Icon(Icons.logout_rounded),
              InkWell(
                onTap: ()=>_onLogoutTap(context),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Выход")
                ),
              )
            ])
          ),
        ]
      ),
    );
  }

  void _onLogoutTap(BuildContext context) {
    Auth.signOut();
    Navigator.popUntil(context, (route) => true);
    Navigator.push(context, AppRoute.login.route.build(null));
  }
}

class _ProfileRawDecoration extends StatelessWidget {
  final Widget? child;
  const _ProfileRawDecoration({ Key? key, this.child }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.canvasColor))
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child
      ),
    );
  }
}