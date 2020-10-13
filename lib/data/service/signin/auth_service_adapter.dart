import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
import 'package:deukki/data/service/signin/auth_service.dart';
import 'package:deukki/data/service/signin/kakao_auth_service.dart';
import 'package:deukki/data/service/signin/sns_auth_service.dart';
import 'package:deukki/provider/version/version_provider_model.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';

enum AuthServiceType { Kakao, Google, Facebook, Apple }

class AuthServiceAdapter extends ChangeNotifier implements AuthService {
  SNSAuthService _snsAuthService;
  KakaoAuthService _kakaoAuthService;

  SharedHelper _sharedHelper;
  DBHelper _dbHelper;

  bool marketingAgree = false;
  UserVO _userVO;
  String socialId, socialMethod, marketingMethod, authJWT = "";

  AuthServiceAdapter({@required SharedHelper sharedHelper}) : _sharedHelper = sharedHelper;

  void _init() async {
    _dbHelper = DBHelper();
    _snsAuthService = SNSAuthService();
    _kakaoAuthService = KakaoAuthService();
    _userVO = await _dbHelper.getUser();
  }

  @override
  Future<void> userAuthState() async {
    _init();
    authJWT = _sharedHelper.getStringSharedPref(AuthService.AUTH_TOKEN, "");
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

  signInDone(String authJWT) async {
    _sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
  }

  signUpDone(String authJWT) async {
    _sharedHelper.setStringSharedPref(AuthService.AUTH_TOKEN, authJWT);
    _dbHelper.insertUser(userVO);
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