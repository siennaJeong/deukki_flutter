import 'package:deukki/data/model/user_vo.dart';
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
  Future<UserVO> currentUser() {

  }

  @override
  Stream<UserVO> get onAuthStateChanged => throw UnimplementedError();

  @override
  Future<UserVO> signInWithApple() {

  }

  @override
  Future<UserVO> signInWithFacebook() async {

  }

  @override
  Future<UserVO> signInWithGoogle() {

  }

  @override
  Future<UserVO> signInWithKakao() async {
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

      // TODO: 기기에 카카오톡 설치된 상태에서 계정 연결 안되어 있으면 Not Supported Error 발생! -> 에러처리 어케 할건지..
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

