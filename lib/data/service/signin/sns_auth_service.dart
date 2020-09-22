
import 'package:firebase_auth/firebase_auth.dart';
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
    return googleUser.id;
  }

  Future<String> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        return facebookAuthCredential.providerId;
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

