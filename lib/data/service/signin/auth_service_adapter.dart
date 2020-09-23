import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/data/service/signin/sns_auth_service.dart';
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
  String email;
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
  Future<String> signInWithSNS(AuthServiceType authServiceType) async {
    String authId = "";
    switch(authServiceType) {
      case AuthServiceType.Google:
        await _snsAuthService.signInWithGoogle().then((value) {
          authId = value;
          email = _snsAuthService.email;
        });
        return authId;
      case AuthServiceType.Facebook:
        await _snsAuthService.signInWithFacebook().then((value) {
          authId = value;
          email = _snsAuthService.email;
        });
        return authId;
      case AuthServiceType.Apple:

        break;
      case AuthServiceType.Kakao:
        await _kakaoAuthService.signInWithKakao();
        email = _kakaoAuthService.email;
        break;
    }

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