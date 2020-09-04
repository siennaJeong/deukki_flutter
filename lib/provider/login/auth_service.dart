import 'package:deukki/data/model/user_vo.dart';
import 'dart:async';

abstract class AuthService {
  static const String AUTH_TYPE = "loginAuthType";
  static const String AUTH_TYPE_APPLE = "Apple";
  static const String AUTH_TYPE_FB = "Facebook";
  static const String AUTH_TYPE_Google = "Google";
  static const String AUTH_TYPE_KAKAO = "Kakao";

  Future<bool> signInDone();
  Future<bool> signOut();
  Future<bool> userAuthState();
}