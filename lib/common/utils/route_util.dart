import 'package:deukki/view/ui/login/login.dart';
import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/ui/splash.dart';
import 'package:flutter/material.dart';

class GetRoutesName {
  String ROUTE_SPLASH = "/splash";
  String ROUTE_LOGIN = "/login";
  String ROUTE_MAIN = "/main";
}

var routes = <String, WidgetBuilder> {
  GetRoutesName().ROUTE_SPLASH: (BuildContext context) => Splash(),
  GetRoutesName().ROUTE_LOGIN: (BuildContext context) => Login(),
  GetRoutesName().ROUTE_MAIN: (BuildContext context) => MainCategory()
};

