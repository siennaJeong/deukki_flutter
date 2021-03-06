import 'dart:async';

import 'package:deukki/data/service/login/auth_service.dart';
import 'package:deukki/data/service/login/auth_service_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/user.dart';

const String KAKAO_APP_KEY = "33194ae01d0ccade0fffcd22f39f300a";
const String KAKAO_JS_KEY = "3765d00988752c05db3b9e83cf9ddb88";

class KakaoAuthService {
  var kakaoUserToken;
  var kakaoAuthCode;
  bool isKakaoInstalled;

  isInstalled() async {
    isKakaoInstalled = await isKakaoTalkInstalled();
  }

  Future<String> signInWithKakao() async {
    var token;
    try {
      if(isKakaoInstalled) {
        kakaoAuthCode = await AuthCodeClient.instance.requestWithTalk();
      }else {
        kakaoAuthCode = await AuthCodeClient.instance.request();
      }
      kakaoUserToken = await AuthApi.instance.issueAccessToken(kakaoAuthCode);
      token = await AccessTokenStore.instance.toStore(kakaoUserToken);


    } on KakaoAuthException catch (e) {
      print(e);
    } on KakaoClientException catch (e) {
      print(e);
    }
  }

}