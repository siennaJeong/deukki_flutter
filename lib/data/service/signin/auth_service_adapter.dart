import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/data/service/signin/sns_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

enum AuthServiceType { Kakao, Google, Facebook, Apple }

class LoginMethod {
  static const int facebook = 3401;
  static const int google = 3402;
  static const int apple = 3403;
  static const int kakao = 3404;
  static const int unknown = 3400;
}

class AuthServiceAdapter extends ChangeNotifier implements AuthService{
  final SharedHelper sharedHelper;
  final DBHelper dbHelper;
  SNSAuthService _snsAuthService;
  KakaoAuthService _kakaoAuthService;

  bool marketingAgree = false;
  UserVO _userVO;
  String _authJWT;
  String socialId, socialMethod, marketingMethod;

  AuthServiceAdapter(this._authJWT, {this.sharedHelper, this.dbHelper}) {
    if(sharedHelper != null) {
      userAuthState();
    }
  }

  void _init() async {
    _snsAuthService = SNSAuthService();
    _kakaoAuthService = KakaoAuthService();
    _userVO = await dbHelper.getUser();
  }

  @override
  Future<void> userAuthState() async {
    _init();
    if(sharedHelper.sharedPreference != null) {
      authJWT = await sharedHelper.getStringSharedPref(AuthService.AUTH_TOKEN, "") as String;
      notifyListeners();
    }
  }

  @override
  Future<String> signInWithSNS(AuthServiceType authServiceType) async {
    switch(authServiceType) {
      case AuthServiceType.Google:
        await _snsAuthService.signInWithGoogle().then((value) {
          socialMethod = AuthService.AUTH_TYPE_Google;
          socialId = value;
          userVO.email = _snsAuthService.email;
        });
        return socialId;
        break;
      case AuthServiceType.Facebook:
        await _snsAuthService.signInWithFacebook().then((value) {
          socialMethod = AuthService.AUTH_TYPE_FB;
          socialId = value;
          userVO.email = _snsAuthService.email;
        });
        return socialId;
        break;
      case AuthServiceType.Apple:

        break;
      case AuthServiceType.Kakao:
        await _kakaoAuthService.signInWithKakao().then((value) {
          socialMethod = AuthService.AUTH_TYPE_KAKAO;
          socialId = value;
          userVO.email = _kakaoAuthService.email;
        });
        return socialId;
        break;
    }
    notifyListeners();
  }

  @override
  Future<void> logout() async {
    // *** 참고 : Firebase 탈퇴 - await FirebaseAuth.instance.currentUser.delete();

    switch (await sharedHelper.getStringSharedPref(AuthService.AUTH_TYPE, "") as String) {
      case AuthService.AUTH_TYPE_KAKAO:
        var logout = await UserApi.instance.logout();
        await AccessTokenStore.instance.clear();
        print(logout.toJson());
        break;
      case AuthService.AUTH_TYPE_FB:
        await FirebaseAuth.instance.signOut();
        break;
      case AuthService.AUTH_TYPE_Google:
        await FirebaseAuth.instance.signOut();
        break;
      case AuthService.AUTH_TYPE_APPLE:
        break;
    }
    sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, null);
    sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, null);
    return true;
  }

  signInDone(String authJWT, String authType) async {
    sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
    sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, authType);
    _authJWT = authJWT;
  }

  signUpDone(String authJWT) async {
    sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
    _authJWT = authJWT;
    dbHelper.insertUser(userVO);
  }

  UserVO get userVO => _userVO;

  bool canUseEmail(String value) {
    return Validator().emailValidation(value);
  }

  bool canUseName(String value) {
    return Validator().nameValidation(value);
  }

  bool canUseYear(int value) {
    return Validator().yearValidation(value);
  }

  bool canUseMonth(int value) {
    return Validator().monthValidation(value);
  }

  @override
  void dispose() {

  }

  String get authJWT => _authJWT;

  set authJWT(String value) {
    _authJWT = value;
    notifyListeners();
  }

}