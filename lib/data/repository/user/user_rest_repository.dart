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

  @override
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId) async {
    final checkSignUpJson = await _httpClient.getRequest(HttpUrls.SIGN_UP_CHECK + "/$authType/$authId");
    if(checkSignUpJson.isValue) {
      return Result.value(CommonResultVO.fromJson(checkSignUpJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> signUp(UserVO userVO) async {
     final signUpJson = await _httpClient.postRequest(HttpUrls.SIGN_UP, userVO.toJson());
     if(signUpJson.isValue) {
       return Result.value(CommonResultVO.fromJson(signUpJson.asValue.value as Map<String, dynamic>));
     }else {
       return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
     }
  }

  @override
  Future<Result<CommonResultVO>> login(String authType, String authId) {

  }


}