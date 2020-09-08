import 'package:deukki/data/model/user_vo.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class AuthService{
  static const String AUTH_TYPE = "loginAuthType";
  static const String AUTH_TYPE_APPLE = "Apple";
  static const String AUTH_TYPE_FB = "Facebook";
  static const String AUTH_TYPE_Google = "Google";
  static const String AUTH_TYPE_KAKAO = "Kakao";

  Future<void> signInDone(BuildContext context, var token, String sharedValue);
  Future<void> signOut(BuildContext context, String sharedValue);
  Future<void> userAuthState();
}