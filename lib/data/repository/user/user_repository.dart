import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/user_vo.dart';

abstract class UserRepository {
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId);
  Future<Result<CommonResultVO>> signUp(UserVO userVO);
  Future<Result<CommonResultVO>> login(String authType, String authId);
}