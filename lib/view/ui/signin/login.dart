import 'dart:io';

import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:deukki/view/values/strings.dart';

class Login extends BaseWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserProviderModel signInProviderModel;
  AuthServiceAdapter authServiceAdapter;
  String authId;

  double deviceWidth, deviceHeight;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context);
    signInProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  void _checkSignUp(String authType, AuthServiceType authServiceType) async {
    if(!Platform.isIOS) {
      if(authServiceType == AuthServiceType.Apple) {
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(Strings.apple_sign_in_only_ios), duration: Duration(seconds: 2)));
        return;
      }
    }else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      if(authServiceType == AuthServiceType.Apple) {
        if(int.parse(iosDeviceInfo.systemVersion.substring(0, 2)) < 13) {
          scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(Strings.ios_low_version_apple_login)));
          return;
        }
      }
    }

    authServiceAdapter.signInWithSNS(authServiceType).then((value) {
      if(value.isNotEmpty && value != "cancel") {
        signInProviderModel.checkSignUp(authType, value, authServiceAdapter.fbUid).then((val) {
          final isSignUp = signInProviderModel.value.checkSignUp;
          if(!isSignUp.hasData) {
            print("isSignUp no data");
          }
          if(isSignUp.result.isValue) {
            if(isSignUp.result.asValue.value.result) {
              _login(authType, value, authServiceAdapter.fbUid);
            }else {
              RouteNavigator().go(GetRoutesName.ROUTE_TERMS, context);
            }
          }else if(isSignUp.result.isError) {
            print("isSignUp error : " + isSignUp.result.asError.error.toString());
          }
        });
      }
    });
  }

  void _login(String authType, String authId, String fbUid) {
    signInProviderModel.login(authType, authId, fbUid).then((value) {
      final loginResult = signInProviderModel.value.login;
      if(!loginResult.hasData) {
        print('login no date');
      }
      if(loginResult.result.isValue) {
        if(loginResult.result.asValue.value.message == HttpUrls.MESSAGE_SUCCESS) {
          authServiceAdapter.signInDone(loginResult.result.asValue.value.result, authType);
          RouteNavigator().go(GetRoutesName.ROUTE_MAIN, context);
        }
      }
    });
  }

  Widget _loginButtonWidget(String logoImg, String title, Color logoColor, Color textColor, String serviceType, AuthServiceType authServiceType) {
    return Container(
      width: deviceWidth * 0.5,
      height: deviceHeight > 700 ? 56 : deviceHeight * 0.13,
      margin: EdgeInsets.only(bottom: Platform.isIOS ? 8 : 30),
      child: RaisedButton(
        padding: EdgeInsets.only(left: 20, top: 13, right: 20, bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Image.asset(
                logoImg,
                width: 24,
              ),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: "TmoneyRound",
                    fontSize: deviceHeight > 700 ? 24 : 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ),
          ],
        ),
        color: logoColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(70.0))
        ),
        onPressed: () => _checkSignUp(serviceType, authServiceType),
      ),
    );
  }

  Widget _androidWidget() {
    return Column(
      children: <Widget>[
        _loginButtonWidget(AppImages.kakaoLogo, Strings.login_for_kakao, MainColors.yellow_kakao, Colors.black, AuthService.AUTH_TYPE_KAKAO, AuthServiceType.Kakao),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              width: 16.0,
              height: 1.0,
              color: MainColors.grey_text,
            ),
            Text(
                Strings.login_sns_other_type,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: MainColors.grey_text)
            ),
            Container(
              margin: EdgeInsets.only(left: 8),
              width: 16.0,
              height: 1.0,
              color: MainColors.grey_text,
            )
          ],
        ),
        Container(
          //width: 200,
          margin: EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _snsButton(context, AppImages.googleLogo, MainColors.grey_google, AuthServiceType.Google, AuthService.AUTH_TYPE_Google),
              //_snsButton(context, AppImages.facebookLogo, MainColors.blue_facebook, AuthServiceType.Facebook, AuthService.AUTH_TYPE_FB),
              SizedBox(width: 10),
              _snsButton(context, AppImages.appleLogo, Colors.black, AuthServiceType.Apple, AuthService.AUTH_TYPE_APPLE)
            ],
          ),
        )
      ],
    );
  }

  Widget _snsButton(BuildContext context, String imgUrl, Color color, AuthServiceType authServiceType, String authTypeString) => SizedBox(
      width: 48,
      child: RaisedButton(
          child: Image.asset(
            imgUrl,
            width: 21,
            height: 25,
          ),
          elevation: 0,
          color: color,
          shape: CircleBorder(),
          padding: EdgeInsets.all(11.0),
          onPressed: () => { _checkSignUp(authTypeString, authServiceType) }
      )
  );

  Widget _iosWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _loginButtonWidget(AppImages.kakaoLogo, Strings.login_for_kakao, MainColors.yellow_kakao, Colors.black, AuthService.AUTH_TYPE_KAKAO, AuthServiceType.Kakao),
        _loginButtonWidget(AppImages.googleLogo, Strings.login_for_google, MainColors.grey_google, Colors.black, AuthService.AUTH_TYPE_Google, AuthServiceType.Google),
        //_loginButtonWidget(AppImages.facebookLogo, Strings.login_for_facebook, MainColors.blue_facebook, Colors.white, AuthService.AUTH_TYPE_FB, AuthServiceType.Facebook),
        _loginButtonWidget(AppImages.appleLogo, Strings.login_for_apple, Colors.black, Colors.white, AuthService.AUTH_TYPE_APPLE, AuthServiceType.Apple),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = KAKAO_APP_KEY;
    KakaoContext.javascriptClientId = KAKAO_JS_KEY;

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                  margin: EdgeInsets.only(top: 50),
                  width: deviceWidth * 0.2,
                  child: Image.asset(
                    AppImages.appLogoMint,
                  )
              ),
              SizedBox(height: Platform.isIOS ? deviceHeight * 0.11 : deviceHeight * 0.16),
              Platform.isIOS ? _iosWidget() : _androidWidget(),
            ],
          ),
        ),
      ),
    );
  }
}


