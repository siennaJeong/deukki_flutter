import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/data/service/signin/sns_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';

enum AuthServiceType { Kakao, Google, Facebook, Apple }

class AuthServiceAdapter extends ChangeNotifier implements AuthService {
  SNSAuthService _snsAuthService;
  KakaoAuthService _kakaoAuthService;

  SharedHelper _sharedHelper;
  DBHelper _dbHelper;

  bool isSignIn, marketingAgree = false;
  UserVO _userVO;
  String socialId, socialMethod, marketingMethod;

  AuthServiceAdapter({@required SharedHelper sharedHelper, @required DBHelper dbHelper}) : _sharedHelper = sharedHelper, _dbHelper = dbHelper;

  void _init() async {
    _snsAuthService = SNSAuthService();
    _kakaoAuthService = KakaoAuthService();
    _userVO = await _dbHelper.getUser();
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
    switch(authServiceType) {
      case AuthServiceType.Google:
        await _snsAuthService.signInWithGoogle().then((value) {
          socialId = value;
          userVO.email = _snsAuthService.email;
        });
        return socialId;
        break;
      case AuthServiceType.Facebook:
        await _snsAuthService.signInWithFacebook().then((value) {
          socialId = value;
          userVO.email = _snsAuthService.email;
        });
        return socialId;
        break;
      case AuthServiceType.Apple:

        break;
      case AuthServiceType.Kakao:
        await _kakaoAuthService.signInWithKakao().then((value) {
          socialId = value;
          userVO.email = _kakaoAuthService.email;
        });
        return socialId;
        break;
    }
    notifyListeners();
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

  signInDone() async {
   // _sharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, sharedValue);
    /* TODO : 서버 로그인, JWT 토큰 업데이트 */
  }

  signUpDoe() async {
    /* TODO : 회원가입, 로컬 디비 저장 */
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

}