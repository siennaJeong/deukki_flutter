import 'dart:async';

import 'package:deukki/data/service/signin/auth_service_adapter.dart';

abstract class AuthService{
  static const String AUTH_TYPE = "loginAuthType";

  static const String AUTH_TYPE_APPLE = "apple";
  static const String AUTH_TYPE_FB = "facebook";
  static const String AUTH_TYPE_Google = "google";
  static const String AUTH_TYPE_KAKAO = "kakao";

  Future<String> signInWithSNS(AuthServiceType authServiceType);
  Future<void> signOut();
  Future<void> userAuthState();
  void dispose();
}