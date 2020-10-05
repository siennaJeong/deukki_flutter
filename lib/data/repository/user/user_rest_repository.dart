import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/repository/user/user_repository.dart';

class UserRestRepository implements UserRepository {
  final HttpClient _httpClient = HttpClient();

  Map<String, dynamic> _headers(String authJWT) => <String, dynamic> {
    'Content-Type': 'application/json',
    'authorization': authJWT
  };

  Map<String, dynamic> _loginToJson(String authType, String authId) => <String, dynamic> {
    'socialMethod': authType,
    'socialId': authId
  };

  Map<String, dynamic> _signupToJson(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod) => <String, dynamic> {
    'socialMethod': authType,
    'socialId': authId,
    'email': userVO.email,
    'name': userVO.name,
    'birthDate': userVO.birthDate,
    'gender': userVO.gender,
    'agreeMarketing': agreeMarketing,
    'marketingMethod': marketingMethod
  };

  @override
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId) async {
    final checkSignUpJson = await _httpClient.getRequest(HttpUrls.SIGN_UP_CHECK + "/$authType/$authId", _headers(""));
    if(checkSignUpJson.isValue) {
      return Result.value(CommonResultVO.fromJson(checkSignUpJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> signUp(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod) async {
     final signUpJson = await _httpClient.postRequest(HttpUrls.SIGN_UP, _headers(""), _signupToJson(userVO, authType, authId, agreeMarketing, marketingMethod));
     if(signUpJson.isValue) {
       return Result.value(CommonResultVO.fromJson(signUpJson.asValue.value as Map<String, dynamic>));
     }else {
       return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
     }
  }

  @override
  Future<Result<CommonResultVO>> login(String authType, String authId) async {
    final loginJson = await _httpClient.postRequest(HttpUrls.LOGIN, _headers(""), _loginToJson(authType, authId));
    if(loginJson.isValue) {
      return Result.value(CommonResultVO.fromJson(loginJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> logout(String authJWT) async {
    final logoutJson = await _httpClient.deleteRequest(HttpUrls.LOGOUT, _headers(authJWT));
    if(logoutJson.isValue) {
      return Result.value(CommonResultVO.fromJson(logoutJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> signOut(String authJWT) async {
    final signOutJson = await _httpClient.deleteRequest(HttpUrls.SIGN_OUT, _headers(authJWT));
    if(signOutJson.isValue) {
      return Result.value(CommonResultVO.fromJson(signOutJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

}