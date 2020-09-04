import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:deukki/provider/login/auth_service_adapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SNSAuthService implements AuthService{
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserVO> currentUser() {

  }

  Future<UserVO> signInWithApple() {

  }

  Future<Null> signInWithFacebook(BuildContext context) async {
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        // TODO: Firebase -> Facebook 앱 시크릿키 입력
        print("sign in with facebook of firebase + " + userCredential.user.email);

        signInDone(context, result.accessToken.token, AuthService.AUTH_TYPE_FB);
        break;
      case FacebookAuthLoginResponse.cancelled:
        print("login cancelled");
        break;
      case FacebookAuthLoginResponse.error:

        break;
    }

  }

  Future<UserVO> signInWithGoogle() {

  }

  @override
  Future<bool> signInDone(BuildContext context, var token, String sharedValue) {
    AuthServiceAdapter().signInDone(context, token, sharedValue);
  }

  @override
  Future<bool> signOut(BuildContext context, String sharedValue) {

  }

  @override
  Future<bool> userAuthState() {

  }

}

