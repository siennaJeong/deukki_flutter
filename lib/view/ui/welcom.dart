
import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static const String PAGE_WELCOME = "welcome";

  @override
  void initState() {
    AnalyticsService().sendAnalyticsEvent(true, false, PAGE_WELCOME, "", "", "");
    super.initState();
  }

  void getRoute() {
    AnalyticsService().sendAnalyticsEvent(false, false, PAGE_WELCOME, "confirm", "", "");
    setState(() {
      RouteNavigator().go(GetRoutesName.ROUTE_MAIN, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 45, bottom: 38),
                width: 245,
                child: Image.asset(
                  AppImages.appLogoMint
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  Strings.welcome_title,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 35),
                child: Text(
                  Strings.welcome_script,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 530,
                child: CommonRaisedButton(
                  buttonText: Strings.common_btn_ok,
                  buttonColor: MainColors.purple_100,
                  textColor: Colors.white,
                  borderColor: MainColors.purple_100,
                  fontSize: 24,
                  voidCallback: getRoute
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
