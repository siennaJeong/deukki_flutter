
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/learning_vo.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/model/report_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/model/verify_token_vo.dart';
import 'package:deukki/data/repository/user/user_repository.dart';

class UserRestRepository implements UserRepository {
  final HttpClient _httpClient = HttpClient();

  Map<String, String> _loginToJson(String authType, String authId, String fbUid) => <String, String> {
    'socialMethod': authType,
    'socialId': authId,
    'fbUid': fbUid,
  };

  Map<String, dynamic> _signupToJson(UserVO userVO, String authType, String authId, String fbUid, String agreeMarketing, String marketingMethod, String phone) => <String, dynamic> {
    'socialMethod': authType,
    'socialId': authId,
    'fbUid': fbUid,
    'email': userVO.email,
    'name': userVO.name,
    'birthDate': userVO.birthDate,
    'gender': userVO.gender,
    'agreeMarketing': agreeMarketing,
    'marketingMethod': marketingMethod,
    'phone': phone
  };

  Map<String, dynamic> _marketingToJson(String marketingMethod, String agreement, String phone) => <String, dynamic> {
    'marketingMethod': marketingMethod,
    'phone': phone,
    'agree': agreement,
  };

  Map<String, dynamic> _deviceInfoToJson(String platform, String deviceId, String deviceModel, String manufacturer, String osVersion, int appVersion, String fcmToken) => <String, dynamic> {
    'platform': platform,
    'deviceId': deviceId,
    'deviceModel': deviceModel,
    'mnft': manufacturer,
    'osVersion': osVersion,
    'appVersion': appVersion,
    'fcmToken': fcmToken
  };

  @override
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId, String fbUid) async {
    final checkSignUpJson = await _httpClient.getRequest("${HttpUrls.SIGN_UP_CHECK}/$authType?socialId=$authId&fbUid=$fbUid", HttpUrls.headers(""));
    if(checkSignUpJson.isValue) {
      return Result.value(CommonResultVO.fromJson(checkSignUpJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> signUp(UserVO userVO, String authType, String authId, String fbUid, bool agreeMarketing, String marketingMethod, String phone) async {
     final signUpJson = await _httpClient.postRequest(HttpUrls.SIGN_UP, HttpUrls.postHeaders(""), _signupToJson(userVO, authType, authId, fbUid, agreeMarketing.toString(), marketingMethod, phone));
     if(signUpJson.isValue) {
       return Result.value(CommonResultVO.fromJson(signUpJson.asValue.value as Map<String, dynamic>));
     }else {
       return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
     }
  }

  @override
  Future<Result<CommonResultVO>> signOut(String authJWT) async {
    final signOutJson = await _httpClient.deleteRequest(HttpUrls.SIGN_OUT, HttpUrls.headers(authJWT));
    if(signOutJson.isValue) {
      return Result.value(CommonResultVO.fromJson(signOutJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> login(String authType, String authId, String fbUid) async {
    final loginJson = await _httpClient.postRequest(HttpUrls.LOGIN, HttpUrls.postHeaders(""), _loginToJson(authType, authId, fbUid));
    if(loginJson.isValue) {
      return Result.value(CommonResultVO.fromJson(loginJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> logout(String authJWT) async {
    final logoutJson = await _httpClient.deleteRequest(HttpUrls.LOGOUT, HttpUrls.headers(authJWT));
    if(logoutJson.isValue) {
      final status = logoutJson.asValue.value['status'];
      if(status == 200) {
        return Result.value(CommonResultVO.fromJson(logoutJson.asValue.value as Map<String, dynamic>));
      }else {
        return Result.error(ExceptionMapper.toErrorMessage(ServerErrorException()));
      }
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> updateBookmark(String authJWT, String sentenceId, int stageIdx) async {
    final updateBookmark = await _httpClient.postRequest("${HttpUrls.BOOKMARKS}/$sentenceId/$stageIdx", HttpUrls.headers(authJWT), null);
    if(updateBookmark.isValue) {
      return Result.value(CommonResultVO.fromJson(updateBookmark.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<BookmarkVO>>> getBookmark(String authJWT) async {
    final bookmarkListJson = await _httpClient.getRequest(HttpUrls.BOOKMARKS, HttpUrls.headers(authJWT));
    if(bookmarkListJson.isValue) {
      return Result.value((bookmarkListJson.asValue.value['result'] as List)
          .map((json) => BookmarkVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> deleteBookmark(String authJWT, int bookmarkIdx) async {
    final deleteBookmark = await _httpClient.deleteRequest("${HttpUrls.BOOKMARKS}/$bookmarkIdx", HttpUrls.headers(authJWT));
    if(deleteBookmark.isValue) {
      return Result.value(CommonResultVO.fromJson(deleteBookmark.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> recordLearning(String authJWT, String sentenceId, LearningVO learningVO) async {
    final recordLearning = await _httpClient.recordRequest("${HttpUrls.LEARNING_RECORD}/$sentenceId", HttpUrls.postHeaders(authJWT), learningVO.bodyJson());
    if(recordLearning.isValue) {
      return Result.value(CommonResultVO.fromJson(recordLearning.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<UserVOForHttp>> getUserInfo(String authJWT) async {
    final getUserInfo = await _httpClient.getRequest(HttpUrls.GET_USER_INFO, HttpUrls.headers(authJWT));
    if(getUserInfo.isValue) {
      final value = getUserInfo.asValue.value['result'];
      return Result.value(UserVOForHttp.fromJson(value.first as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<ProductionVO>>> getProductList(String authJWT) async {
    final getProductList = await _httpClient.getRequest("${HttpUrls.GET_PRODUCT}?iap=${true}", HttpUrls.headers(authJWT));
    if(getProductList.isValue) {
      return Result.value((getProductList.asValue.value['result'] as List)
          .map((json) => ProductionVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> marketingAgreement(String authJWT, String marketingMethod, bool agreement, String phone) async {
    final marketingAgreement = await _httpClient.patchRequest(HttpUrls.MARKETING_AGREEMENT, HttpUrls.postHeaders(authJWT), _marketingToJson(marketingMethod, agreement.toString(), phone));
    if(marketingAgreement.isValue) {
      return Result.value(CommonResultVO.fromJson(marketingAgreement.asValue.value));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<ReportVO>> getReports(String authJWT) async {
    final getReports = await _httpClient.reportRequest(HttpUrls.GET_REPORTS, HttpUrls.headers(authJWT));
    if(getReports.isValue) {
      final status = getReports.asValue.value['status'];
      if(status == 200) {
        return Result.value(ReportVO.fromJson(getReports.asValue.value['result'] as Map<String, dynamic>));
      }else if(status == 404) {
        return Result.value(ReportVO(0, 0, 0, ""));
      }else {
        return Result.error(ExceptionMapper.toErrorMessage(ServerErrorException()));
      }
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<VerifyTokenVO>> verifyToken(String authJWT) async {
    final verifyToken = await _httpClient.getRequest(HttpUrls.VERIFY_TOKEN, HttpUrls.headers(authJWT));
    if(verifyToken.isValue) {
      final status = verifyToken.asValue.value['status'];
      if(status == 200) {
        final result = verifyToken.asValue.value['result'];
        return Result.value(VerifyTokenVO.fromJson(result as Map<String, dynamic>));
      }else {
        return Result.value(null);
      }
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> saveDeviceInfo(String authJWT, String platform, String deviceId, String deviceModel, String manufacturer, String osVersion, int appVersion, String fcmToken) async {
    final saveDeviceInfo = await _httpClient.postRequest(HttpUrls.SAVE_DEVICE_INFO, HttpUrls.postHeaders(authJWT), _deviceInfoToJson(platform, deviceId, deviceModel, manufacturer, osVersion, appVersion, fcmToken));
    if(saveDeviceInfo.isValue) {
      final status = saveDeviceInfo.asValue.value['status'];
      if(status == 200) {
        return Result.value(CommonResultVO.fromJson(saveDeviceInfo.asValue.value));
      }else {
        return Result.error(ExceptionMapper.toErrorMessage(ServerErrorException()));
      }
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }



}