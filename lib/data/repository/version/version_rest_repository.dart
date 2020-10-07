
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
import 'package:deukki/data/repository/version/version_repository.dart';

class VersionRestRepository implements VersionRepository {
  final HttpClient _httpClient = HttpClient();

  @override
  Future<Result<CommonResultVO>> checkAllVersion() async {
    final checkAllVersionJson = await _httpClient.getRequest(HttpUrls.CHECK_ALL_VERSION, HttpUrls.headers(""));
    if(checkAllVersionJson.isValue) {
      final temp = Result.value(CommonResultVO.fromJson(checkAllVersionJson.asValue.value as Map<String, dynamic>));
      

      return Result.value(CommonResultVO.fromJson(checkAllVersionJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<AppVersionVO>> checkAppVersion() async {
    final checkAppVersionJson = await _httpClient.getRequest(HttpUrls.CHECK_APP_VERSION, HttpUrls.headers(""));
    if(checkAppVersionJson.isValue) {
      return Result.value(AppVersionVO.fromJson(checkAppVersionJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CategoryVersionVO>> checkCategoryVersion() async {
    final checkCategoryVersionJson = await _httpClient.getRequest(HttpUrls.CHECK_CATEGORY_VERSION, HttpUrls.headers(""));
    if(checkCategoryVersionJson.isValue) {
      return Result.value(CategoryVersionVO.fromJson(checkCategoryVersionJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<FaqVersionVO>> checkFaqVersion() {

  }

  @override
  Future<Result<CommonResultVO>> checkForceUpdate(String authJWT) {

  }



}