import 'package:flutter/material.dart';
import 'package:matcha/env.dart';

class DefaultAppBar extends AppBar{
  DefaultAppBar({super.key}):super(
    automaticallyImplyLeading: true,
    title: const Text(Env.appTitile)
  );
}