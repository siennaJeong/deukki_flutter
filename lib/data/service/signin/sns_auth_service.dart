
import 'dart:math';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SNSAuthService {
  String _email;
  String _fbUid;
  String _name;

  String get email => _email;
  String get fbUid => _fbUid;
  String get name => _name;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> authExceptionHandler(OAuthCredential authCredential) async {
    try {
      return await firebaseAuth.signInWithCredential(authCredential);
    }on FirebaseAuthException catch(e) {
      if(e.code == 'account-exists-with-different-credential') {
        String existMail = e.email;
        AuthCredential pendingCredential = e.credential;
        List<String> userSignInMethods = await firebaseAuth.fetchSignInMethodsForEmail(existMail);

        if(userSignInMethods.first == 'facebook.com') {
          var accessToken = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
          FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.accessToken.token);
          UserCredential userCredential = await firebaseAuth.signInWithCredential(facebookAuthCredential);
          return userCredential.user.linkWithCredential(pendingCredential);
        }

        if(userSignInMethods.first == 'google.com') {
          GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
          GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
          GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          UserCredential userCredential = await firebaseAuth.signInWithCredential(googleAuthCredential);
          return userCredential.user.linkWithCredential(pendingCredential);
        }

        if(userSignInMethods.first == 'apple.com') {
          final rawNonce = generateNonce();
          final nonce = sha256ofString(rawNonce);

          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );

          final oauthCredential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );
          UserCredential userCredential = await firebaseAuth.signInWithCredential(oauthCredential);
          return userCredential.user.linkWithCredential(pendingCredential);
        }
      }
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if(googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      final UserCredential userCredential = await authExceptionHandler(googleCredential);
      if(userCredential.user.email.isNotEmpty) {
        _email = userCredential.user.email;
      }else {
        _email = "";
      }
      _name = userCredential.user.displayName;
      _fbUid = userCredential.user.uid;
      return googleUser.id;
    }else {
      return "cancel";
    }
  }

  Future<String> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
    final UserCredential userCredential = await authExceptionHandler(facebookAuthCredential);
    if(userCredential.user.email.isNotEmpty) {
      _email = userCredential.user.email;
    }else {
      _email = "";
    }
    _name = userCredential.user.displayName;
    _fbUid = userCredential.user.uid;
    return facebookAuthCredential.providerId;
  }

  Future<String> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final UserCredential userCredential = await authExceptionHandler(oauthCredential);
    if(userCredential.user.email.isNotEmpty) {
      _email = userCredential.user.email;
    }else {
      _email = "";
    }

    if(appleCredential.familyName != null) {
      _name = appleCredential.familyName + appleCredential.givenName;
      userCredential.user.updateProfile(displayName: appleCredential.familyName + appleCredential.givenName);
    }else {
      if(userCredential.user.displayName != null) {
        _name = userCredential.user.displayName;
      }else {
        _name = "회원";
      }
    }

    _fbUid = userCredential.user.uid;
    return oauthCredential.providerId;
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

