import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:kakao_flutter_sdk/all.dart';

class AuthServiceAdapter implements AuthService {
  @override
  Future<bool> signInDone(BuildContext context, var token, String sharedValue) {
    if(token != null) {
      RouteNavigator.goMain(context);
      SharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, sharedValue);
    }
  }

  @override
  Future<bool> signOut(BuildContext context, String sharedValue) async {
    switch (sharedValue) {
      case AuthService.AUTH_TYPE_KAKAO:
        var logout = await UserApi.instance.logout();
        await AccessTokenStore.instance.clear();
        print(logout.toJson());
        break;
      case AuthService.AUTH_TYPE_FB:
        break;
      case AuthService.AUTH_TYPE_Google:
        break;
      case AuthService.AUTH_TYPE_APPLE:
        break;
    }
    SharedHelper.setStringSharedPref(AuthService.AUTH_TYPE, null);
    RouteNavigator.goLogin(context);

    return true;
  }

  @override
  Future<bool> userAuthState() {

  }

}