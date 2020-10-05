import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/user_vo.dart';

abstract class UserRepository {
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId);
  Future<Result<CommonResultVO>> signUp(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod);
  Future<Result<CommonResultVO>> login(String authType, String authId);
  Future<Result<CommonResultVO>> logout(String authJWT);
  Future<Result<CommonResultVO>> signOut(String authJWT);
}