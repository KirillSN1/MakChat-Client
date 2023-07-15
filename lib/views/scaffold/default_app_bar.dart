import 'package:flutter/material.dart';
import 'package:matcha/env.dart';

class DefaultAppBar extends AppBar{
  final String? info;
  DefaultAppBar({super.key, this.info = "" }):super(
    automaticallyImplyLeading: true,
    title: Row(children: [
      const Text(Env.appTitile),
      if(info != null) Text(" - $info"),
    ],)
  );
}