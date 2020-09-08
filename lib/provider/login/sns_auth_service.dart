import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:deukki/provider/login/auth_service_adapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SNSAuthService implements AuthService{
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserVO> currentUser() {

  }

  Future<UserVO> signInWithApple() {

  }

  Future<void> signInWithFacebook(BuildContext context) async {
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
    print("sign in with google of firebase : access Token - " + googleAuth.accessToken + ", email - " + userCredential.user.email);
    signInDone(context, googleAuth.accessToken, AuthService.AUTH_TYPE_Google);
  }

  @override
  Future<void> signInDone(BuildContext context, var token, String sharedValue) async {
    AuthServiceAdapter().signInDone(context, token, sharedValue);
  }

  @override
  Future<void> signOut(BuildContext context, String sharedValue) async {

  }

  @override
  Future<void> userAuthState() async {

  }

}

