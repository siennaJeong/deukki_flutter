import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/data/service/signin/sns_auth_service.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';

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
  String _authJWT, _kakaoNoti, _skipTutorial;
  String socialId, socialMethod, marketingMethod, phone, fbUid;

  bool _isSigning = false;

  UserVO get userVO => _userVO;
  String get authJWT => _authJWT;
  String get kakaoNoti => _kakaoNoti;
  String get skipTutorial => _skipTutorial;
  getIsSigning() => _isSigning;

  set authJWT(String value) {
    _authJWT = value;
    notifyListeners();
  }

  set kakaoNoti(String value) {
    this._kakaoNoti = value;
  }

  set skipTutorial(String value) {
    this._skipTutorial = value;
  }

  setIsSigning(bool isSigning) {
    this._isSigning = isSigning;
    notifyListeners();
  }

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
      kakaoNoti = await sharedHelper.getStringSharedPref(AuthService.KAKAO_NOTIFICATION, "") as String;
      skipTutorial = await sharedHelper.getStringSharedPref(AuthService.SKIP_TUTORIAL, "") as String;
      notifyListeners();
    }
  }

  @override
  // ignore: missing_return
  Future<String> signInWithSNS(AuthServiceType authServiceType) async {
    switch(authServiceType) {
      case AuthServiceType.Google:
        await _snsAuthService.signInWithGoogle().then((value) {
          socialMethod = AuthService.AUTH_TYPE_Google;
          socialId = value;
          phone = "";
          fbUid = _snsAuthService.fbUid;
          userVO.name = _snsAuthService.name;
          userVO.email = _snsAuthService.email;
          userVO.gender = _snsAuthService.gender;
          userVO.birthDate = _snsAuthService.birthDate;
        });
        changeKakaoNoti(false);
        return socialId;
        break;
<<<<<<< HEAD
      /*case AuthServiceType.Facebook:
        await _snsAuthService.signInWithFacebook().then((value) {
=======
      case AuthServiceType.Facebook:
        /*await _snsAuthService.signInWithFacebook().then((value) {
>>>>>>> 95cb9369f2542b04bdd4bbbc95d47b4b1b40d866
          socialMethod = AuthService.AUTH_TYPE_FB;
          socialId = value;
          phone = "";
          fbUid = _snsAuthService.fbUid;
          userVO.name = _snsAuthService.name;
          userVO.email = _snsAuthService.email;
        });*/
        changeKakaoNoti(false);
        return socialId;
        break;*/
      case AuthServiceType.Apple:
        await _snsAuthService.signInWithApple().then((value) {
          socialMethod = AuthService.AUTH_TYPE_APPLE;
          socialId = value;
          phone = "";
          fbUid = _snsAuthService.fbUid;
          userVO.name = _snsAuthService.name;
          userVO.email = _snsAuthService.email;
        });
        changeKakaoNoti(false);
        return socialId;
        break;
      case AuthServiceType.Kakao:
        await _kakaoAuthService.signInWithKakao().then((value) {
          socialMethod = AuthService.AUTH_TYPE_KAKAO;
          socialId = value;
          fbUid = "kakaoFbUid";
          phone = _kakaoAuthService.phone;
          userVO.name = _kakaoAuthService.name;
          userVO.email = _kakaoAuthService.email;
          userVO.gender = _kakaoAuthService.gender;
          userVO.birthDate = _kakaoAuthService.birthDate;
          changeKakaoNoti(true);
        });
        return socialId;
        break;
    }
    notifyListeners();
  }

  @override
  Future<void> logout() async {
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
        await FirebaseAuth.instance.signOut();
        break;
    }
    sharedHelper.removeAllShared();
    return true;
  }

  void signInDone(String authJWT, String authType) async {     //  로그인
    sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
    sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, authType);
    _authJWT = authJWT;
  }

  void signUpDone(String authJWT) async {        //  회원가입
    sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
    _authJWT = authJWT;
    dbHelper.insertUser(userVO);
  }

  void changeKakaoNoti(bool isBool) async {
    sharedHelper.setStringSharedPref(AuthService.KAKAO_NOTIFICATION, isBool ? "true" : "false");
  }

  void setSkipTutorial(String tutorial) async {
    sharedHelper.setStringSharedPref(AuthService.SKIP_TUTORIAL, tutorial);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.currentUser.delete();
    sharedHelper.removeAllShared();
  }

  @override
  void dispose() {

  }

}