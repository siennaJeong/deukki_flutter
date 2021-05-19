import 'dart:async';

import 'package:deukki/data/service/signin/auth_service_adapter.dart';

abstract class AuthService{
  static const String AUTH_TYPE = "loginAuthType";
  static const String AUTH_TOKEN = "AuthToken";

  static const String AUTH_TYPE_APPLE = "apple";
  static const String AUTH_TYPE_FB = "facebook";
  static const String AUTH_TYPE_Google = "google";
  static const String AUTH_TYPE_KAKAO = "kakao";

  static const String KAKAO_NOTIFICATION = "kakaoNotice";

  static const String SKIP_TUTORIAL = "skipTutorial";

  Future<String> signInWithSNS(AuthServiceType authServiceType);
  Future<void> logout();
  Future<void> userAuthState();
  Future<void> signOut();
  void dispose();
}