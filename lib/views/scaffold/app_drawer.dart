import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(height: MediaQuery.of(context).viewPadding.top),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("KirillSN",style: TextStyle(color: Colors.white)),
                  Text("+7 (949) 433-65-46",style: TextStyle(color: Colors.white))
                ],
              ),
            ],
          )
        ],
      )
    );
  }

}