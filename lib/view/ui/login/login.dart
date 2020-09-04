import 'package:deukki/provider/login/kakao_auth_service.dart';
import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/provider/login/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = KAKAO_APP_KEY;
    KakaoContext.javascriptClientId = KAKAO_JS_KEY;

    if(SharedHelper.getStringSharedPref(AuthService.AUTH_TYPE, "").isNotEmpty) {
      print(SharedHelper.getStringSharedPref(AuthService.AUTH_TYPE, ""));
    }

    final SNSAuthService authService = Provider.of<SNSAuthService>(context);
    KakaoAuthService kakaoAuthService = Provider.of<KakaoAuthService>(context, listen: false);
    kakaoAuthService.isInstalled();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 160,
                  child: Image.asset(
                    "images/app_logo_yellow.png",
                  )
              ),
              Container(
                width: 406,
                height: 48,
                margin: EdgeInsets.only(top: 55.0, bottom: 30.0),
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 20, top: 13, right: 20, bottom: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Image.asset(
                          "images/kakao_logo.png",
                          width: 24,
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            Strings.login_for_kakao,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "TmoneyRound",
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          )
                      ),
                    ],
                  ),
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(70.0))
                  ),
                  onPressed: () => kakaoAuthService.signInWithKakao(context),
                ),  //  카카오톡 로그인
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    width: 16.0,
                    height: 1.0,
                    color: MainColors().grey_text,
                  ),
                  Text(
                      Strings.login_sns_other_type,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: MainColors().grey_text)
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    width: 16.0,
                    height: 1.0,
                    color: MainColors().grey_text,
                  )
                ],
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    SizedBox(
                      width: 48,
                      child: RaisedButton(
                        child: Image.asset(
                          'images/google_g_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        elevation: 0,
                        color: MainColors().grey_google,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(11.0),
                        onPressed: () => authService.signInWithGoogle(),
                      ),
                    ),  //  구글 로그인
                    SizedBox(
                        width: 48,
                        child: RaisedButton(
                          child: Center(
                            child: Image.asset(
                              'images/facebook_logo.png',
                              width: 25,
                              height: 24,
                              fit: BoxFit.fill,
                            ),
                          ),
                          elevation: 0,
                          color: MainColors().blue_facebook,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(11.0),
                          onPressed: () => SNSAuthService().signInWithFacebook(context),
                        )
                    ),  //  페이스북 로그인
                    SizedBox(
                      width: 48,
                      child: RaisedButton(
                        child: Image.asset(
                          'images/apple_logo.png',
                          width: 21,
                          height: 25,
                        ),
                        elevation: 0,
                        color: Colors.black,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(11.0),
                        onPressed: () => authService.signInWithApple(),
                      ),
                    ) //  애플 로그인
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/*class Login extends BaseWidget {
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = KAKAO_APP_KEY;
    //KakaoContext.javascriptClientId = KAKAO_JS_KEY;

    final SNSAuthService authService = Provider.of<SNSAuthService>(context);
    KakaoAuthService kakaoAuthService = Provider.of<KakaoAuthService>(context);
    kakaoAuthService.isTalkInstalled();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 160,
                child: Image.asset(
                  "images/app_logo_yellow.png",
                )
              ),
              Container(
                width: 406,
                height: 48,
                margin: EdgeInsets.only(top: 55.0, bottom: 30.0),
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 20, top: 13, right: 20, bottom: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Image.asset(
                          "images/kakao_logo.png",
                          width: 24,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          Strings.login_for_kakao,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "TmoneyRound",
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),
                        )
                      ),
                    ],
                  ),
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(70.0))
                  ),
                  onPressed: () => kakaoAuthService.signInWithKakao() != null ? RouteNavigator.goMain(context) : null,
                ),  //  카카오톡 로그인
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    width: 16.0,
                    height: 1.0,
                    color: MainColors().grey_text,
                  ),
                  Text(
                      Strings.login_sns_other_type,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: MainColors().grey_text)
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    width: 16.0,
                    height: 1.0,
                    color: MainColors().grey_text,
                  )
                ],
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    SizedBox(
                      width: 48,
                      child: RaisedButton(
                        child: Image.asset(
                          'images/google_g_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        elevation: 0,
                        color: MainColors().grey_google,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(11.0),
                        onPressed: () => authService.signInWithGoogle(),
                      ),
                    ),  //  구글 로그인
                    SizedBox(
                      width: 48,
                      child: RaisedButton(
                        child: Center(
                          child: Image.asset(
                            'images/facebook_logo.png',
                            width: 25,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                        ),
                        elevation: 0,
                        color: MainColors().blue_facebook,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(11.0),
                        onPressed: () => authService.signInWithFacebook(),
                      )
                    ),  //  페이스북 로그인
                    SizedBox(
                      width: 48,
                      child: RaisedButton(
                        child: Image.asset(
                          'images/apple_logo.png',
                          width: 21,
                          height: 25,
                        ),
                        elevation: 0,
                        color: Colors.black,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(11.0),
                        onPressed: () => authService.signInWithFacebook(),
                      ),
                    ) //  애플 로그인
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    // TODO: implement buildCupertinoWidget
    throw UnimplementedError();
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    throw UnimplementedError();
  }
}*/



