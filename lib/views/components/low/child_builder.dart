import 'package:flutter/material.dart';

class ChildBuilder extends StatelessWidget {
  final Widget child;

  const ChildBuilder({
    super.key,
    required this.builder,
    required this.child,
  });
  final Widget Function(BuildContext context, Widget child) builder;

  @override
  Widget build(BuildContext context) => builder(context,child);
}