import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/login/auth_service_adapter.dart';
import 'package:deukki/data/service/login/kakao_auth_service.dart';
import 'package:deukki/data/service/login/sns_auth_service.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/login/auth_service.dart';

class Login extends BaseWidget {
  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final AuthServiceAdapter authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

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
                    AppImages.appLogoYellow,
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
                  onPressed: () => authServiceAdapter.signInWithKakao(),
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
                    SNSButton('images/google_g_logo.png', MainColors.grey_google, AuthServiceType.Google),
                    SNSButton('images/facebook_logo.png', MainColors.blue_facebook, AuthServiceType.Facebook),
                    SNSButton('images/apple_logo.png', Colors.black, AuthServiceType.Apple)
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

class SNSButton extends StatelessWidget {
  final String imgUrl;
  final Color color;
  final AuthServiceType authServiceType;

  SNSButton(this.imgUrl, this.color, this.authServiceType);

  @override
  Widget build(BuildContext context) {
    final AuthServiceAdapter authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

    return SizedBox(
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
            onPressed: () async => authServiceAdapter.signInWithFirebase(authServiceType)
        )
    );
  }
}



