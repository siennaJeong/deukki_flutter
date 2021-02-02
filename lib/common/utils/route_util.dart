import 'package:deukki/provider/resource/mypage_provider.dart';
import 'package:deukki/provider/resource/record_provider.dart';
import 'package:deukki/provider/resource/stage_provider.dart';
import 'package:deukki/view/ui/category/category_small.dart';
import 'package:deukki/view/ui/category/stage/record.dart';
import 'package:deukki/view/ui/category/stage/stage_complete_dialog.dart';
import 'package:deukki/view/ui/category/stage/stage_quiz.dart';
import 'package:deukki/view/ui/mypage/coupon_registration.dart';
import 'package:deukki/view/ui/mypage/my_page.dart';
import 'package:deukki/view/ui/premium_pop_up.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/signin/privacy_terms.dart';
import 'package:deukki/view/ui/signin/sign_up_email.dart';
import 'package:deukki/view/ui/signin/sign_up_input.dart';
import 'package:deukki/view/ui/signin/sign_up_name.dart';
import 'package:deukki/view/ui/signin/sign_up_terms.dart';
import 'package:deukki/view/ui/category/main.dart';
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
  static const String ROUTE_CATEGORY_SMALL = "/categorySmall";
  static const String ROUTE_STAGE_QUIZ = "/stageQuiz";
  static const String ROUTE_STAGE_COMPLETE = "/stageComplete";
  static const String ROUTE_RECORD = "/record";
  static const String ROUTE_MYPAGE = "/myPage";
  static const String ROUTE_PRIVACY_TERMS = "/privacyTerms";
  static const String ROUTE_PRIVACY_INFO = "/privacyInfo";
  static const String ROUTE_COUPON_REGISTRATION = "/couponRegistration";
  static const String ROUTE_PREMIUM_POPUP = "/premiumPopup";
}

final routes = <String, WidgetBuilder> {
  GetRoutesName.ROUTE_SPLASH: (context) => Splash(),
  GetRoutesName.ROUTE_LOGIN: (context) => Login(),
  GetRoutesName.ROUTE_MAIN: (context) => MainCategory(),
  GetRoutesName.ROUTE_TERMS: (context) => SignUpTerms(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL: (context) => SignUpInputEmail(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_NAME: (context) => SignUpInputName(),
  GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH: (context) => SignUpInputBirth(),      //  ProviderWidget 에서 변경.
  GetRoutesName.ROUTE_WELCOME: (context) => Welcome(),
  GetRoutesName.ROUTE_CATEGORY_SMALL: (context) => CategorySmall(),
  GetRoutesName.ROUTE_STAGE_QUIZ: (context) => ChangeNotifierProvider<StageProvider>(create: (context) => StageProvider(), child: StageQuiz(),),
  GetRoutesName.ROUTE_STAGE_COMPLETE: (context) => StageCompleteDialog(),
  GetRoutesName.ROUTE_RECORD: (context) => ChangeNotifierProvider<RecordProvider>(create: (context) => RecordProvider(), child: Record(),),
  GetRoutesName.ROUTE_MYPAGE: (context) => ChangeNotifierProvider<MyPageProvider>(create: (context) => MyPageProvider(), child: MyPage(),),
  GetRoutesName.ROUTE_PRIVACY_TERMS: (context) => PrivacyTerms(),
  GetRoutesName.ROUTE_PRIVACY_INFO: (context) => PrivacyInfo(),
  GetRoutesName.ROUTE_COUPON_REGISTRATION: (context) => CouponRegistration(),
  GetRoutesName.ROUTE_PREMIUM_POPUP: (context) => PremiumPopup(),
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
      case GetRoutesName.ROUTE_CATEGORY_SMALL:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_CATEGORY_SMALL);
        break;
      case GetRoutesName.ROUTE_STAGE_QUIZ:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_STAGE_QUIZ);
        break;
      case GetRoutesName.ROUTE_STAGE_COMPLETE:
        Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_STAGE_COMPLETE);
        break;
      case GetRoutesName.ROUTE_RECORD:
        Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_RECORD);
        break;
      case GetRoutesName.ROUTE_MYPAGE:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_MYPAGE);
        break;
      case GetRoutesName.ROUTE_PRIVACY_TERMS:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_PRIVACY_TERMS);
        break;
      case GetRoutesName.ROUTE_PRIVACY_INFO:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_PRIVACY_INFO);
        break;
      case GetRoutesName.ROUTE_COUPON_REGISTRATION:
        Navigator.pushNamed(context, GetRoutesName.ROUTE_COUPON_REGISTRATION);
        break;
      case GetRoutesName.ROUTE_PREMIUM_POPUP:
        Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_PREMIUM_POPUP);
        break;
    }
  }

}


