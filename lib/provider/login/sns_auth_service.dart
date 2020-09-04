import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/provider/login/auth_service.dart';

class SNSAuthService implements AuthService{
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserVO> currentUser() {

  }

  Future<UserVO> signInWithApple() {

  }

  Future<UserVO> signInWithFacebook() async {
    //final LoginResult facebookLoginResult = await FacebookAuth.instance.login();
    //final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);

  }

  Future<UserVO> signInWithGoogle() {

  }

  @override
  Future<bool> signInDone() {

  }

  @override
  Future<bool> signOut() {

  }

  @override
  Future<bool> userAuthState() {

  }

}

