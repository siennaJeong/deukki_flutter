
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/service/login/auth_service.dart';
import 'package:deukki/data/service/login/auth_service_adapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SNSAuthService {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> firebaseAuthState() async {

  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);

    /* 서버에서 가입되어 있는지 확인후 -> 가입 되어 있어서 로그인이면 "goLogin" String 전달 / 가입 안되어 있으면 Sns에서 제공해주는 이메일 전달. */
    //HttpRequest().snsLogin('google/token', googleUser.id);

    return userCredential.user.email;
  }

  Future<String> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        print("sign in with facebook of firebase + " + result.accessToken.userId);

        //HttpRequest().snsLogin('facebook/', facebookAuthCredential.accessToken);
        return userCredential.user.email;
      case FacebookAuthLoginResponse.cancelled:
        print("login cancelled");
        break;
      case FacebookAuthLoginResponse.error:
        break;
    }
  }

  Future<String> signInWithApple() async {

  }
}

