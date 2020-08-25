import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/ui/splash.dart';
import 'package:flutter/material.dart';

var routes = <String, WidgetBuilder> {
  "/splash": (BuildContext context) => Splash(),
  "/main": (BuildContext context) => MainCategory()
};

