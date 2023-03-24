import 'package:flutter/material.dart';
import 'package:matcha/env.dart';

class DefaultAppBar extends AppBar{
  final bool loading;
  DefaultAppBar({super.key, this.loading = false }):super(
    automaticallyImplyLeading: true,
    title: Row(children: [
      const Text(Env.appTitile),
      if(loading) const CircularProgressIndicator()
    ],)
  );
}