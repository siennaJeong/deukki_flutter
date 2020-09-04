import 'package:deukki/data/model/user_vo.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class AuthService {
  static const String AUTH_TYPE = "loginAuthType";
  static const String AUTH_TYPE_APPLE = "Apple";
  static const String AUTH_TYPE_FB = "Facebook";
  static const String AUTH_TYPE_Google = "Google";
  static const String AUTH_TYPE_KAKAO = "Kakao";

  Future<bool> signInDone(BuildContext context, var token, String sharedValue);
  Future<bool> signOut(BuildContext context, String sharedValue);
  Future<bool> userAuthState();
}