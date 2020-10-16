import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/provider/resource/database_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/provider_widget.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/signin/sign_up_input.dart';
import 'package:deukki/view/ui/signin/sign_up_terms.dart';
import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/ui/splash.dart';
import 'package:deukki/view/ui/welcom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetRoutesName {
  static const String FINISH = "finish";
  static const String ROUTE_SPLASH = "/splash";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_MAIN = "/main";
  static const String ROUTE_TERMS = "/signUpTerms";
  static const String ROUTE_SIGNUP_INPUT_EMAIL = "/signUpInputEmail";
  static const String ROUTE_SIGNUP_INPUT_NAME = "/signUpInputName";
  static const String ROUTE_SIGNUP_INPUT_BIRTH = "/signUpInputBirth";
  static const String ROUTE_WELCOME = "/welcome";
}

var routes = <String, WidgetBuilder> {
  GetRoutesName.ROUTE_SPLASH: (BuildContext context) => Splash(),
  GetRoutesName.ROUTE_LOGIN: (BuildContext context) => Login(),
  GetRoutesName.ROUTE_MAIN: (BuildContext context) => MainCategory(),
  GetRoutesName.ROUTE_TERMS: (BuildContext context) => SignUpTerms(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL: (BuildContext context) => SignUpInputEmail(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_NAME: (BuildContext context) => SignUpInputName(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH: (BuildContext context) => ProviderWidget<UserProviderModel>(SignUpInputBirth(), (BuildContext context) => UserProviderModel.build()),
  GetRoutesName.ROUTE_WELCOME: (BuildContext context) => Welcome(),
};

class RouteNavigator {
  go(String routeName, BuildContext context) {
    switch(routeName) {
      case GetRoutesName.FINISH:
        Navigator.pop(context, true);
        break;
      case GetRoutesName.ROUTE_LOGIN:
        Navigator.pushNamedAndRemoveUntil(context, GetRoutesName.ROUTE_LOGIN, (Route<dynamic> route) => false);
        break;
      case GetRoutesName.ROUTE_TERMS:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_TERMS);
        break;
      case GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL);
        break;
      case GetRoutesName.ROUTE_SIGNUP_INPUT_NAME:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_SIGNUP_INPUT_NAME);
        break;
      case GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH);
        break;
      case GetRoutesName.ROUTE_WELCOME:
        //Navigator.popAndPushNamed(context, GetRoutesName.ROUTE_WELCOME);
        Navigator.pushNamedAndRemoveUntil(context, GetRoutesName.ROUTE_WELCOME, (Route<dynamic> route) => false);
        break;
      case GetRoutesName.ROUTE_MAIN:
        Navigator.pushNamedAndRemoveUntil(context, GetRoutesName.ROUTE_MAIN, (Route<dynamic> route) => false);
        break;
    }
  }

}


