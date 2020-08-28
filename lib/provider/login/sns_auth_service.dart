import 'package:deukki/data/model/user_dao.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/link.dart';

const String AUTH_TYPE_APPLE = "Apple";
const String AUTH_TYPE_FB = "Facebook";
const String AUTH_TYPE_Google = "Google";
const String AUTH_TYPE_KAKAO = "Kakao";

const String KAKAO_APP_KEY = "33194ae01d0ccade0fffcd22f39f300a";
const String KAKAO_JS_KEY = "3765d00988752c05db3b9e83cf9ddb88";

class SNSAuthService implements AuthService {

  @override
  Future<UserDAO> currentUser() {

  }

  @override
  Stream<UserDAO> get onAuthStateChanged => throw UnimplementedError();

  @override
  Future<UserDAO> signInWithApple() {

  }

  @override
  Future<UserDAO> signInWithFacebook() {

  }

  @override
  Future<UserDAO> signInWithGoogle() {

  }

  @override
  Future<UserDAO> signInWithKakao() async {
    bool isKakaoInstalled = await isKakaoTalkInstalled();
    var kakaoAuthCode;
    var kakaoUserToken;
    try {
      if(isKakaoInstalled) {

        kakaoAuthCode = await AuthCodeClient.instance.requestWithTalk();
      }else {
        kakaoAuthCode = await AuthCodeClient.instance.request();
      }
      kakaoUserToken = await AuthApi.instance.issueAccessToken(kakaoAuthCode);
      AccessTokenStore.instance.toStore(kakaoUserToken);
    } on KakaoAuthException catch (e) {
      print("kakao Auth exception");
    } on KakaoClientException catch (e) {
      print(e);
    }
    print(kakaoUserToken);

    return kakaoUserToken;
  }

  @override
  Future<void> signOut() {

  }



}

