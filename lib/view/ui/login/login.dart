import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:deukki/view/values/strings.dart';

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    Icon(
                      Icons.account_box,
                      size: 50.0,
                    ),
                    Text(
                      Strings.service_name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                    )
                  ],
                ),
              ),
              Container(
                width: 400,
                height: 50,
                margin: EdgeInsets.only(top: 50.0, bottom: 30.0),
                child: RaisedButton(
                  child: Text("Kakao Login"),
                  color: Colors.amber,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(70.0))
                  ),
                  onPressed: () => authService.signInWithKakao(),
                ),
              ),
              Text(
                  Strings.login_sns_other_type,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.grey)
              ),
              Container(
                width: 250,
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    SizedBox(
                      width: 60,
                      child: RaisedButton(
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        elevation: 0,
                        color: Colors.black12,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(13.0),
                        onPressed: () => authService.signInWithGoogle(),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: RaisedButton(
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        elevation: 0,
                        color: Colors.blueAccent,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(13.0),
                        onPressed: () => authService.signInWithFacebook(),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: RaisedButton(
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        elevation: 0,
                        color: Colors.black,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(13.0),
                        onPressed: () => authService.signInWithFacebook(),
                      ),
                    )
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



