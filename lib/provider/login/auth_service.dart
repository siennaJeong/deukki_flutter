import 'package:deukki/data/model/user_vo.dart';
import 'dart:async';

abstract class AuthService {
  Future<UserVO> currentUser();
  Future<UserVO> signInWithKakao();
  Future<UserVO> signInWithGoogle();
  Future<UserVO> signInWithFacebook();
  Future<UserVO> signInWithApple();
  Future<void> signOut();
  Stream<UserVO> get onAuthStateChanged;
}