import 'package:deukki/provider/login/auth_service.dart';
import 'package:kakao_flutter_sdk/all.dart';

class AuthServiceAdapter implements AuthService {
  @override
  Future<bool> signInDone() {

  }

  @override
  Future<bool> signOut() async {
    var logout = await UserApi.instance.logout();
    await AccessTokenStore.instance.clear();
    print(logout.toJson());
    return true;
  }

  @override
  Future<bool> userAuthState() {

  }

}