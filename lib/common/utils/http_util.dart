
class HttpUrls {
  static const String SERVER_URL = "http://elb-deukki-dev-799756848.ap-northeast-2.elb.amazonaws.com";
  static const String SIGN_UP = "$SERVER_URL/users";  //  post
  static const String SIGN_UP_CHECK = "$SERVER_URL/users/check-signup";  //  get
  static const String GET_USER_INFO = "$SERVER_URL/users/me"; // get
  static const String SIGN_OUT = "$SERVER_URL/auth";  // delete
}
