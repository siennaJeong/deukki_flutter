import 'dart:async';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/user.dart';

const String KAKAO_APP_KEY = "33194ae01d0ccade0fffcd22f39f300a";
const String KAKAO_JS_KEY = "3765d00988752c05db3b9e83cf9ddb88";

class KakaoAuthService {
  var kakaoUserToken;
  var kakaoAuthCode;
  bool isKakaoInstalled;
  String _email, _phone, _name, _birthDate, _gender = "";

  KakaoAuthService() { _isInstalled(); }

  _isInstalled() async {
    isKakaoInstalled = await isKakaoTalkInstalled();
  }

  Future<String> signInWithKakao() async {
    var token;
    if(isKakaoInstalled) {
      kakaoAuthCode = await AuthCodeClient.instance.requestWithTalk();
    }else {
      kakaoAuthCode = await AuthCodeClient.instance.request();
    }
    kakaoUserToken = await AuthApi.instance.issueAccessToken(kakaoAuthCode);
    token = await AccessTokenStore.instance.toStore(kakaoUserToken);
    try {
      final User user = await UserApi.instance.me();
      if(user.kakaoAccount.email != null) {
        _email = user.kakaoAccount.email;
        _phone = "0${user.kakaoAccount.phoneNumber.substring(4)}";
        _name = user.kakaoAccount.profile.nickname;
        return user.id.toString();
      }else {
        _email = "";
        return null;
      }
      _name = user.kakaoAccount.profile.nickname;
      _phone = "0${user.kakaoAccount.phoneNumber.substring(4)}";
      Gender gender = user.kakaoAccount.gender;
      print("kakao gender : $gender, birth : ${user.kakaoAccount.birthday}-${user.kakaoAccount.birthyear}");

      return user.id.toString();
    } on KakaoAuthException catch (e) {
      print("Kakao Auth Exception : $e");
    } on KakaoClientException catch (e) {
      print("Kakao Client Exception : $e");
    } on KakaoApiException catch (e) {
      print("Kakao Api Exception : $e");
      if(e.code == ApiErrorCause.INVALID_TOKEN) {
        return "invalid token";
      }
    } on PlatformException catch (e) {
      print("Kakao Platform Exception : $e");
      return "cancel";
    }
  }

  String get email => _email;
  String get phone => _phone;
  String get name => _name;
  String get birthDate => _birthDate;
  String get gender => _gender;
}