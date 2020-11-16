
import 'package:flutter/foundation.dart';

class HttpUrls {
  static const String MESSAGE_SUCCESS = "Success";
  static const String SERVER_URL = kDebugMode ? "https://dev-api.deukki.com" : "https://api.deukki.com";

  static const String CHECK_ALL_VERSION = "$SERVER_URL/versions";
  static const String CHECK_APP_VERSION = "$SERVER_URL/versions/app";
  static const String CHECK_CATEGORY_VERSION = "$SERVER_URL/versions/categories";
  static const String CHECK_FAQ_VERSION = "$SERVER_URL/versions/faq";
  static const String CHECK_FORCE_UPDATE = "$SERVER_URL/versions/update";

  static const String INIT_DATA = "$SERVER_URL/init-data";

  static const String SIGN_UP_CHECK = "$SERVER_URL/users/check-signup";
  static const String GET_USER_INFO = "$SERVER_URL/users/me";
  static const String SIGN_UP = "$SERVER_URL/users";
  static const String SIGN_OUT = "$SERVER_URL/users/me";
  static const String LOGIN = "$SERVER_URL/auth/login";
  static const String LOGOUT = "$SERVER_URL/auth";

  static const String CATEGORY = "$SERVER_URL/categories";
  static const String CATEGORY_LARGE = "$CATEGORY/large";
  static const String CATEGORY_MEDIUM = "$CATEGORY/medium";
  static const String CATEGORY_MEDIUM_SCORE = "$CATEGORY_MEDIUM/stars";
  static const String CATEGORY_SMALL = "$CATEGORY/small";

  static const String SENTENCE = "$SERVER_URL/sentences";
  static const String SENTENCE_STAGE = "/stages";
  static const String LEARNING_RECORD = "$SERVER_URL/learning";

  static const String STAGE_PRONUNCIATION = "$SERVER_URL/pronunciations";
  static const String RECORD_UPLOAD = "$STAGE_PRONUNCIATION/speaking";

  static const String BOOKMARKS = "$SERVER_URL/bookmarks";

  static const String GET_PRODUCT = "$SERVER_URL/productions";

  static Map<String, String> headers(String authJWT) => <String, String> {
    'content-type': 'application/json',
    'authorization': 'Bearer ' + authJWT
  };

  static Map<String, String> postHeaders(String authJWT) => <String, String> {
    'Content-Type': 'application/x-www-form-urlencoded',
    'authorization': 'Bearer ' + authJWT
  };

  static Map<String, String> uploadHeader() => <String, String> {
    'Content-Type': 'audio/aac'
  };
}
