import 'dart:io';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpTerms extends BaseWidget {
  @override
  _SignUpTermsState createState() => _SignUpTermsState();
}

class _SignUpTermsState extends State<SignUpTerms> {
  static const String PAGE_SIGNUP_TERMS = "Agree";
  bool marketingAgree = false;
  AuthServiceAdapter authServiceAdapter;
  UserProviderModel userProviderModel;

  double deviceWidth, deviceHeight;

  @override
  void initState() {
    AnalyticsService().sendAnalyticsEvent("${AnalyticsService.VISIT}$PAGE_SIGNUP_TERMS", null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: true);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  void _isEmailExist() {
    AnalyticsService().sendAnalyticsEvent("AG Ok", <String, dynamic> {'agree': '$marketingAgree'});
    setState(() {
      authServiceAdapter.marketingAgree = marketingAgree;
      authServiceAdapter.marketingMethod = "email";
      if(authServiceAdapter.userVO != null) {
        if(!Platform.isIOS) {
          if(authServiceAdapter.userVO.gender.isEmpty || authServiceAdapter.userVO.birthDate.isEmpty) {
            RouteNavigator().go(GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH, context);
          }else {
            _signUpDone();
          }
        }else {
          _signUpDone();
        }
      }
    });
  }

  void _signUpDone() {
    userProviderModel.signUp(
        authServiceAdapter.userVO,
        authServiceAdapter.socialMethod,
        authServiceAdapter.socialId,
        authServiceAdapter.fbUid,
        authServiceAdapter.marketingAgree,
        authServiceAdapter.marketingMethod,
        authServiceAdapter.phone
    ).then((value) {
      final signUpResult = userProviderModel.value.signUp;
      if(!signUpResult.hasData) {
        print("sign up failed");
      }
      if(signUpResult.result.asValue.value.status == 200) {
        RouteNavigator().go(GetRoutesName.ROUTE_WELCOME, context);
        authServiceAdapter.signUpDone(signUpResult.result.asValue.value.result);
      }else if(signUpResult.result.asValue.value.status > 200 || signUpResult.result.isError) {
        print("sign up error : " + signUpResult.result.asError.error.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.login_server_error)));
      }
    });
  }

  void _onBackPressed() {
    AnalyticsService().sendAnalyticsEvent("AG Cancel", null);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MainColors.yellow_100,
      body: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.only(left: 44, top: 19, right: 44, bottom: 19),
          child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 28, bottom: 40),
                        child: Text(
                          Strings.sign_up_terms_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "TmoneyRound",
                              fontSize: 32,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            textInkWell(Strings.sign_up_terms_terms),
                            termsText(Strings.sign_up_terms_essential + Strings.sign_up_terms_dot, MainColors.grey_100, null),
                            textInkWell(Strings.sign_up_terms_info),
                            termsText(Strings.sign_up_terms_essential, MainColors.grey_100, null)
                          ],
                        ),
                      ),
                      termsText(Strings.sign_up_terms_script, MainColors.grey_100, null),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              activeColor: MainColors.purple_100,
                              value: marketingAgree,
                              onChanged: (bool value) {
                                AnalyticsService().sendAnalyticsEvent("AG Checkbox", null);
                                setState(() {
                                  marketingAgree = value;
                                });
                              },
                            ),
                            termsText(Strings.sign_up_terms_marketing, MainColors.grey_100, null)
                          ],
                        ),
                      ),
                      Container(
                        width: deviceWidth * 0.68,
                        height: 48,
                        margin: EdgeInsets.only(top: 40, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: CommonRaisedButton(
                                buttonText: Strings.common_btn_cancel,
                                buttonColor: Colors.white,
                                textColor: MainColors.purple_100,
                                borderColor: MainColors.purple_100,
                                fontSize: 16,
                                voidCallback: _onBackPressed
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: CommonRaisedButton(
                                buttonText: Strings.common_btn_ok,
                                buttonColor: MainColors.purple_100,
                                textColor: Colors.white,
                                borderColor: MainColors.purple_100,
                                fontSize: 16,
                                voidCallback: _isEmailExist,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        )
      )
    );
  }


  Widget textInkWell(String str) {
    return InkWell(
      child: termsText(str, MainColors.purple_100, TextDecoration.underline),
      onTap: () {
        switch(str) {
          case Strings.sign_up_terms_terms:         //  이용약관
            AnalyticsService().sendAnalyticsEvent("AG Terms", null);
            RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_TERMS, context);
            break;
          case Strings.sign_up_terms_info:          //  개인정보처리
            AnalyticsService().sendAnalyticsEvent("AG Privacy", null);
            RouteNavigator().go(GetRoutesName.ROUTE_PRIVACY_INFO, context);
            break;
        }
      },
    );
  }

  Widget termsText(String str, Color color, TextDecoration textDecoration) {
    return Text(
      str,
      style: TextStyle(
        decoration: textDecoration,
        color: color,
        fontSize: 16
      ),
    );
  }

}
