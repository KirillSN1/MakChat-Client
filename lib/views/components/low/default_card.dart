import 'package:flutter/material.dart';

class DefaultCard extends Card{
  const DefaultCard({
    super.key,
    super.borderOnForeground,
    super.child,
    super.clipBehavior,
    super.color,
    super.elevation,
    super.semanticContainer,
    super.shadowColor,
    super.surfaceTintColor,
    ShapeBorder? shape
  }):super(
    margin: const EdgeInsets.all(0),
    shape: shape ?? const Border(),
  );
}