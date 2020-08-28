import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = KAKAO_APP_KEY;
    KakaoContext.javascriptClientId = KAKAO_JS_KEY;

    final SNSAuthService authService = Provider.of<SNSAuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Icon(
                    Icons.account_box,
                    size: 50.0,
                  ),
                  Text(
                    "바름드끼",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  )
                ],
              ),
              RaisedButton(
                child: Text("Kakao Login"),
                onPressed: () => authService.signInWithKakao(),
              )
            ],
          ),
        ),
      ),
    );
  }
}