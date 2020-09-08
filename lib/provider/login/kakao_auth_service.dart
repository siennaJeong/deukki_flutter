import 'dart:async';

import 'package:deukki/provider/login/auth_service.dart';
import 'package:deukki/provider/login/auth_service_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/user.dart';

const String KAKAO_APP_KEY = "33194ae01d0ccade0fffcd22f39f300a";
const String KAKAO_JS_KEY = "3765d00988752c05db3b9e83cf9ddb88";

class KakaoAuthService implements AuthService{
  var kakaoUserToken;
  var kakaoAuthCode;
  bool isKakaoInstalled;
  bool isLogin, isSignInDone = false;

  void isKakaoLogin() async {
    var token = await AccessTokenStore.instance.fromStore();
    if(token.accessToken == null) {
      isLogin = false;
    }else {
      isLogin = true;
    }
  }

  isInstalled() async {
    isKakaoInstalled = await isKakaoTalkInstalled();
  }

  signInWithKakao(BuildContext context) async {
    var token;
    try {
      if(isKakaoInstalled) {
        kakaoAuthCode = await AuthCodeClient.instance.requestWithTalk();
      }else {
        kakaoAuthCode = await AuthCodeClient.instance.request();
      }

      kakaoUserToken = await AuthApi.instance.issueAccessToken(kakaoAuthCode);
      token = await AccessTokenStore.instance.toStore(kakaoUserToken);
      signInDone(context, token, AuthService.AUTH_TYPE_KAKAO);

    } on KakaoAuthException catch (e) {
      print(e);
    } on KakaoClientException catch (e) {
      print(e);
    }
  }

  Future<bool> _getUserProfile(String authCode) async {

  }

  @override
  Future<void> signInDone(BuildContext context, var token, String sharedValue) {
    AuthServiceAdapter().signInDone(context, token, sharedValue);
  }

  @override
  Future<void> signOut(BuildContext context, String sharedValue) {
    AuthServiceAdapter().signOut(context, sharedValue);
  }

  @override
  Future<void> userAuthState() {

  }
}