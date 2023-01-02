import 'package:flutter/material.dart';

abstract class IBaseRoute<A>{
  const IBaseRoute();
  Route build(A arguments,{RouteSettings settings});
}