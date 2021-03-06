import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/login/auth_service.dart';
import 'package:deukki/data/service/login/kakao_auth_service.dart';
import 'package:deukki/data/service/login/sns_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';

enum AuthServiceType { Kakao, Google, Facebook, Apple }

class AuthServiceAdapter implements AuthService {
  SNSAuthService _snsAuthService;
  KakaoAuthService _kakaoAuthService;
  SharedHelper _sharedHelper;
  DBHelper _dbHelper;
  bool isSignIn = false;
  var userVO;

  AuthServiceAdapter({@required SharedHelper sharedHelper, @required DBHelper dbHelper}) : _sharedHelper = sharedHelper, _dbHelper = dbHelper;

  void _init() async {
    _snsAuthService = SNSAuthService();
    _kakaoAuthService = KakaoAuthService();
    userVO = await _dbHelper.getUser();
  }

  @override
  Future<void> userAuthState() async {
    _init();
    if(_sharedHelper.getStringSharedPref(AuthService.AUTH_TYPE, "").isEmpty) {
      isSignIn = false;
    }else {
      isSignIn = true;
    }
  }

  @override
  Future<void> signInWithFirebase(AuthServiceType authServiceType) async {
    switch(authServiceType) {
      case AuthServiceType.Google:
        getEmail(() { _snsAuthService.signInWithGoogle(); });
        break;
      case AuthServiceType.Facebook:
        getEmail(() { _snsAuthService.signInWithFacebook(); });
        break;
      case AuthServiceType.Apple:

        break;
    }
  }

  @override
  Future<void> signInWithKakao() async {
    getEmail(() { _kakaoAuthService.signInWithKakao(); });
  }


  @override
  Future<void> signOut() async {
    // *** 참고 : Firebase 탈퇴 - await FirebaseAuth.instance.currentUser.delete();

    /*switch (sharedValue) {
      case AuthService.AUTH_TYPE_KAKAO:
        var logout = await UserApi.instance.logout();
        await AccessTokenStore.instance.clear();
        print(logout.toJson());
        break;
      case AuthService.AUTH_TYPE_FB:
        await FirebaseAuth.instance.signOut();
        break;
      case AuthService.AUTH_TYPE_Google:
        break;
      case AuthService.AUTH_TYPE_APPLE:
        break;
    }*/
    //_sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, null);
    //Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_LOGIN);

    _sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, null);

    return true;
  }

  getEmail(Function action) async {
    String userEmail = await action();
    if(userEmail.isEmpty) {   //  가입 안되어 있음, 이메일도 제공 안해줌 -> 이메일 입력 화면으로

    }else if(userEmail == "goLogin"){ //  가입 되어 있고 로그인 일때 -> 메인 화면으로

    }else {   //  가입 안되어 있고, 이메일도 제공 안해줌 -> 이름 입력 화면으로

    }
  }

  signInDone(String token, String sharedValue) async {
    if(token != null) {
      //Navigator.pushNamed(context, GetRoutesName.ROUTE_TERMS);
      _sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, sharedValue);

      /*
      * TODO:
      *  - 로컬 DB 에 저장?..
      */
    }
  }

  @override
  void dispose() {

  }
}