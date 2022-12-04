import 'package:flutter/material.dart';

abstract class IBaseRoute<A>{
  const IBaseRoute();
  Route build(RouteSettings settings, A? arguments);
}