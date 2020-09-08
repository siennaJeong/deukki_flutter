import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/all.dart';

class AuthServiceAdapter implements AuthService {
  @override
  Future<void> signInDone(BuildContext context, var token, String sharedValue) async {
    if(token != null) {
      Navigator.pushNamed(context, GetRoutesName.ROUTE_TERMS);
      SharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, sharedValue);

      /*
      * TODO:
      *  - 로컬 DB 에 저장?..
      */
    }
  }

  @override
  Future<void> signOut(BuildContext context, String sharedValue) async {
    // *** 참고 : Firebase 탈퇴 - await FirebaseAuth.instance.currentUser.delete();

    switch (sharedValue) {
      case AuthService.AUTH_TYPE_KAKAO:
        var logout = await UserApi.instance.logout();
        await AccessTokenStore.instance.clear();
        print(logout.toJson());
        break;
      case AuthService.AUTH_TYPE_FB:
        await FirebaseAuth.instance.signOut();
        break;
      case AuthService.AUTH_TYPE_Google:
        break;
      case AuthService.AUTH_TYPE_APPLE:
        break;
    }
    SharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, null);
    Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_LOGIN);

    return true;
  }

  @override
  Future<void> userAuthState() {

  }

}