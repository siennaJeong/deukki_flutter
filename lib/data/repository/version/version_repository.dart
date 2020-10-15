import 'package:async/async.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/version_vo.dart';

abstract class VersionRepository {
  static const String VERSION = 'version';
  static const String APP_VERSION = 'appVersion';
  static const String CATEGORY_VERSION ='categoryVersion';
  static const String CATEGORY_LARGE_VERSION = 'largeVersion';
  static const String CATEGORY_MEDIUM_VERSION = 'mediumVersion';
  static const String CATEGORY_SMALL_VERSION = 'smallVersion';
  static const String FAQ_VERSION = 'faqVersion';
  static const String FORCE_UPDATE = 'requireInstall';

  Future<Result<CommonResultVO>> initData();
  Future<Result<CommonResultVO>> checkAllVersion();
  Future<Result<AppVersionVO>> checkAppVersion();
  Future<Result<CategoryVersionVO>> checkCategoryVersion();
  Future<Result<FaqVersionVO>> checkFaqVersion();
  Future<Result<CommonResultVO>> checkForceUpdate(int appVersion, String authJWT);
}