import 'package:deukki/view/ui/login/login.dart';
import 'package:deukki/view/ui/login/sign_up_input.dart';
import 'package:deukki/view/ui/login/sign_up_terms.dart';
import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/ui/splash.dart';
import 'package:flutter/material.dart';

class GetRoutesName {
  static const String ROUTE_SPLASH = "/splash";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_MAIN = "/main";
  static const String ROUTE_TERMS = "/signUpTerms";
  static const String ROUTE_SIGNUP_INPUT_EMAIL = "/signUpInputEmail";
  static const String ROUTE_SIGNUP_INPUT_NAME = "/signUpInputName";
}

var routes = <String, WidgetBuilder> {
  GetRoutesName.ROUTE_SPLASH: (BuildContext context) => Splash(),
  GetRoutesName.ROUTE_LOGIN: (BuildContext context) => Login(),
  GetRoutesName.ROUTE_MAIN: (BuildContext context) => MainCategory(),
  GetRoutesName.ROUTE_TERMS: (BuildContext context) => SignUpTerms(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL: (BuildContext context) => SignUpInputEmail(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_NAME: (BuildContext context) => SignUpInputName()
};

class RouteNavigator {
  BuildContext _context;
  RouteNavigator(this._context);

  navigatePushReplaceName(String routeName) {
    Navigator.pushReplacementNamed(_context, routeName);
  }

  navigatePushName(String routeName) {
    Navigator.pushNamed(_context, routeName);
  }

  /*goLogin() {
    Navigator.pushReplacementNamed(_context, GetRoutesName.ROUTE_LOGIN);
  }

  goMain() {
    Navigator.pushReplacementNamed(_context, GetRoutesName.ROUTE_MAIN);
  }

  goSignUpTerms() {
    Navigator.pushNamed(_context, GetRoutesName.ROUTE_TERMS);
  }

  goSignUpInputEmail() {
    Navigator.pushNamed(_context, GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL);
  }

  goSignUpInputName() {
    Navigator.pushNamed(_context, GetRoutesName.ROUTE_SIGNUP_INPUT_NAME);
  }*/
}

