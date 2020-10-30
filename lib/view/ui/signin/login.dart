import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:deukki/view/values/strings.dart';

class Login extends BaseWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserProviderModel signInProviderModel;
  AuthServiceAdapter authServiceAdapter;
  String authId;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context);
    signInProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  void _checkSignUp(String authType, AuthServiceType authServiceType) {
    authServiceAdapter.signInWithSNS(authServiceType).then((value) {
      signInProviderModel.checkSignUp(authType, value).then((val) {
        final isSignUp = signInProviderModel.value.checkSignUp;
        if(!isSignUp.hasData) {
          print("isSignUp no data");
        }
        if(isSignUp.result.isValue) {
          if(isSignUp.result.asValue.value.result) {
            _login(authType, value);
          }else {
            RouteNavigator().go(GetRoutesName.ROUTE_TERMS, context);
          }
        }else if(isSignUp.result.isError) {
          print("isSignUp error : " + isSignUp.result.asError.error.toString());
        }
      });
    });
  }

  void _login(String authType, String authId) {
    signInProviderModel.login(authType, authId).then((value) {
      final loginResult = signInProviderModel.value.login;
      if(!loginResult.hasData) {
        print('login no date');
      }
      if(loginResult.result.isValue) {
        if(loginResult.result.asValue.value.message == HttpUrls.MESSAGE_SUCCESS) {
          authServiceAdapter.signInDone(loginResult.result.asValue.value.result);
          RouteNavigator().go(GetRoutesName.ROUTE_MAIN, context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = KAKAO_APP_KEY;
    KakaoContext.javascriptClientId = KAKAO_JS_KEY;

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
                    AppImages.appLogoMint,
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
                          AppImages.kakaoLogo,
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
                  color: MainColors.yellow_kakao,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(70.0))
                  ),
                  onPressed: () => _checkSignUp(AuthService.AUTH_TYPE_KAKAO, AuthServiceType.Kakao),
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
                width: 200,
                margin: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _snsButton(context, AppImages.googleLogo, MainColors.grey_google, AuthServiceType.Google, AuthService.AUTH_TYPE_Google),
                    _snsButton(context, AppImages.facebookLogo, MainColors.blue_facebook, AuthServiceType.Facebook, AuthService.AUTH_TYPE_FB),
                    _snsButton(context, AppImages.appleLogo, Colors.black, AuthServiceType.Apple, AuthService.AUTH_TYPE_APPLE)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

}


