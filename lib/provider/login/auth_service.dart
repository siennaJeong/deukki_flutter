import 'package:deukki/data/model/user_dao.dart';
import 'dart:async';

abstract class AuthService {
  Future<UserDAO> currentUser();
  Future<UserDAO> signInWithKakao();
  Future<UserDAO> signInWithGoogle();
  Future<UserDAO> signInWithFacebook();
  Future<UserDAO> signInWithApple();
  Future<void> signOut();
  Stream<UserDAO> get onAuthStateChanged;
}