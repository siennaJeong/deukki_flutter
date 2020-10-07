
class HttpUrls {
  static const String SERVER_URL = "http://dev-api.deukki.com";

  static const String CHECK_ALL_VERSION = "$SERVER_URL/versions";
  static const String CHECK_APP_VERSION = "$SERVER_URL/versions/app";
  static const String CHECK_CATEGORY_VERSION = "$SERVER_URL/versions/categories";
  static const String CHECK_FAQ_VERSION = "$SERVER_URL/versions/faq";
  static const String CHECK_FORCE_UPDATE = "$SERVER_URL/versions/update";

  static const String SIGN_UP_CHECK = "$SERVER_URL/users/check-signup";
  static const String GET_USER_INFO = "$SERVER_URL/users/me";
  static const String SIGN_UP = "$SERVER_URL/users";
  static const String SIGN_OUT = "$SERVER_URL/users/me";
  static const String LOGIN = "$SERVER_URL/auth/login";
  static const String LOGOUT = "$SERVER_URL/auth";

  static Map<String, String> headers(String authJWT) => <String, String> {
    'content-Type': 'application/json',
    'authorization': authJWT
  };
}
