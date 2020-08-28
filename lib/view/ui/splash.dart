import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/*
 * 1. 앱 버전 체크 -> 업데이트 다이얼로그
 * 2. 로그인 체크 -> 로그인 화면
 * 3. 카테고리 버전 체크
 * 4. 도움말 버전 체크
 */

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<SNSAuthService> (
          create: (_) => SNSAuthService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
        routes: routes,
      ),
    )
  );
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: RaisedButton(
            child: Text("click"),
            onPressed: () {
              Navigator.pushNamed(context, GetRoutesName().ROUTE_LOGIN);
            },
          ),
        ),
      )
    );
  }
}
