import 'dart:async';

import 'package:deukki/data/service/login/auth_service_adapter.dart';

abstract class AuthService{
  static const String AUTH_TYPE = "loginAuthType";

  static const String AUTH_TYPE_APPLE = "Apple";
  static const String AUTH_TYPE_FB = "Facebook";
  static const String AUTH_TYPE_Google = "Google";
  static const String AUTH_TYPE_KAKAO = "Kakao";

  Future<void> signInWithKakao();
  Future<void> signInWithFirebase(AuthServiceType authServiceType);
  Future<void> signOut();
  Future<void> userAuthState();
  void dispose();
}