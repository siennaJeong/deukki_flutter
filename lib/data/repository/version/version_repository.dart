import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/version_vo.dart';

abstract class VersionRepository {
  Future<Result<CommonResultVO>> checkAllVersion();
  Future<Result<AppVersionVO>> checkAppVersion();
  Future<Result<CategoryVersionVO>> checkCategoryVersion();
  Future<Result<FaqVersionVO>> checkFaqVersion();
  Future<Result<CommonResultVO>> checkForceUpdate(String authJWT);
}