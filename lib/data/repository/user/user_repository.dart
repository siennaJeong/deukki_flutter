import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';

abstract class UserRepository {
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId);
}