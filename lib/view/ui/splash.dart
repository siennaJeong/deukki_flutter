import 'dart:async';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:deukki/provider/login/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/login/login.dart';
import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/kakao_auth_service.dart';
import 'package:deukki/provider/login/sns_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * 1. 앱 버전 체크 -> 업데이트 다이얼로그
 * 2. 로그인 체크 -> 로그인 화면
 * 3. 카테고리 버전 체크
 * 4. 도움말 버전 체크
 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
  .then((_) {
    runApp(
        MultiProvider(
            providers: [
              Provider.value(value: SharedHelper()),
              Provider.value(value: DBHelper()),
              ProxyProvider2<SharedHelper, DBHelper, AuthServiceAdapter>(
                update: (BuildContext context, SharedHelper sharedHelper, DBHelper dbHelper, AuthServiceAdapter authServiceAdapter) =>
                    AuthServiceAdapter(sharedHelper: sharedHelper, dbHelper: dbHelper),
              ),
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

class Splash extends BaseWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServiceAdapter>(
      builder: (context, authServiceAdapter, child) {
        authServiceAdapter.userAuthState();
        if(authServiceAdapter.isSignIn) {
          return MainCategory();
        }else {
          return Login();
        }
      }
    );
  }
}
