import 'package:async/async.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/learning_vo.dart';
import 'package:deukki/data/model/user_vo.dart';

abstract class UserRepository {
  Future<Result<CommonResultVO>> checkUserSignUp(String authType, String authId);
  Future<Result<CommonResultVO>> signUp(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod);
  Future<Result<CommonResultVO>> signOut(String authJWT);
  Future<Result<CommonResultVO>> login(String authType, String authId);
  Future<Result<CommonResultVO>> logout(String authJWT);
  Future<Result<CommonResultVO>> updateBookmark(String authJWT, String sentenceId, int stageIdx);
  Future<Result<List<BookmarkVO>>> getBookmark(String authJWT);
  Future<Result<CommonResultVO>> deleteBookmark(String authJWT, int bookmarkIdx);
  Future<Result<CommonResultVO>> recordLearning(String authJWT, String sentenceId, LearningVO learningVO);
}