import 'dart:async';

import 'package:deukki/common/storage/shared_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/kakao_auth_service.dart';
import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
 * 1. 앱 버전 체크 -> 업데이트 다이얼로그
 * 2. 로그인 체크 -> 로그인 화면
 * 3. 카테고리 버전 체크
 * 4. 도움말 버전 체크
 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
  .then((_) {
    runApp(
        MultiProvider(
            providers: [
              Provider<SNSAuthService> (
                create: (_) => SNSAuthService(),
              ),
              Provider<KakaoAuthService> (
                create: (_) => KakaoAuthService(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: routes,
              home: Splash(),
            )
        )
    );
  });

}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    SharedHelper.initShared();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final KakaoAuthService kakaoAuthService = Provider.of<KakaoAuthService>(context, listen: false);
    kakaoAuthService.isKakaoLogin();
    Timer(Duration(seconds: 2), () => kakaoAuthService.isLogin ? RouteNavigator.goMain(context) : RouteNavigator.goLogin(context));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: MainColors().yellow_100,
        body: Center(
          child: SafeArea(
              child: Image.asset(
                "images/app_logo_white.png",
                width: 243.6,
              )
          ),
        )
    );
  }
}
