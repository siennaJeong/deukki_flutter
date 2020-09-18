
import 'package:deukki/common/utils/enumeration.dart';

class HttpUrls {
  static const String SERVER_URL = "http://elb-deukki-dev-799756848.ap-northeast-2.elb.amazonaws.com";
  static const String SIGN_UP_CHECK = "$SERVER_URL/users/check-signup/";  //  get
  static const String GET_USER_INFO = "$SERVER_URL/users/me"; // get
  static const String SIGN_IN_FB = "$SERVER_URL/auth/facebook/token"; // post
  static const String SIGN_IN_GOOGLE = "$SERVER_URL/auth/google/token"; // post
  static const String SIGN_IN_APPLE = "$SERVER_URL/auth/apple/token"; //  post
  static const String SIGN_IN_KAKAO = "$SERVER_URL/auth/kakao/token"; //  post
  static const String SIGN_OUT = "$SERVER_URL/auth";  // delete
}

class HttpMethod extends Enum<String> {
  const HttpMethod(String value) : super(value);
  static const HttpMethod GET = const HttpMethod('GET');
  static const HttpMethod POST = const HttpMethod('POST');
  static const HttpMethod PUT = const HttpMethod('PUT');
  static const HttpMethod PATCH = const HttpMethod('PATCH');
  static const HttpMethod DELETE = const HttpMethod('DELETE');
}

