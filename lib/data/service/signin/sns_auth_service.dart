
import 'dart:io';
import 'dart:math';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SNSAuthService {
  String _email;
  String _fbUid;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
    if(userCredential.user.email.isNotEmpty) {
      _email = userCredential.user.email;
    }else {
      _email = "";
    }
    _fbUid = userCredential.user.uid;
    return googleUser.id;
  }

  Future<String> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    if(userCredential.user.email.isNotEmpty) {
      _email = userCredential.user.email;
    }else {
      _email = "";
    }
    _fbUid = userCredential.user.uid;
    return facebookAuthCredential.providerId;
  }

  Future<String> signInWithApple() async {
    final oauthCred = await _createAppleOAuthCred();
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCred);
    if(userCredential.user.email.isNotEmpty) {
      _email = userCredential.user.email;
    }else {
      _email = "";
    }
    _fbUid = userCredential.user.uid;
    return oauthCred.providerId;
  }

  String _createNonce(int length) {
    final random = Random();
    final charCodes = List<int>.generate(length, (_) {
      int codeUnit;
      switch(random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });
    return String.fromCharCodes(charCodes);
  }

  Future<OAuthCredential> _createAppleOAuthCred() async {
    final nonce = _createNonce(32);
    final nativeAppleCred = Platform.isIOS
        ? await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: sha256.convert(utf8.encode(nonce)).toString(),
    )
        : await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        redirectUri: Uri.parse(Strings.firebase_apple_url),
        clientId: Strings.ios_bundle_name,
      ),
      nonce: sha256.convert(utf8.encode(nonce)).toString(),
    );

    return new OAuthCredential(
      providerId: "apple.com",
      signInMethod: "oauth",
      accessToken: nativeAppleCred.identityToken, // propagate Apple ID token to BOTH accessToken and idToken parameters
      idToken: nativeAppleCred.identityToken,
      rawNonce: nonce,
    );
  }

  String get email => _email;
  String get fbUid => _fbUid;
}

