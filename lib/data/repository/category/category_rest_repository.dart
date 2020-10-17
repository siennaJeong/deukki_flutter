
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/repository/category/category_repository.dart';

class CategoryRestRepository implements CategoryRepository {
  final HttpClient _httpClient = HttpClient();

  @override
  Future<Result<List<dynamic>>> getCategoryLarge() async {
    final categoryLargeListJson = await _httpClient.getRequest(HttpUrls.CATEGORY_LARGE, HttpUrls.headers(""));
    if(categoryLargeListJson.isValue) {
      return Result.value(categoryLargeListJson.asValue.value['result']);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<dynamic>>> getCategoryMedium() async {
    final categoryMediumListJson = await _httpClient.getRequest(HttpUrls.CATEGORY_MEDIUM, HttpUrls.headers(""));
    if(categoryMediumListJson.isValue) {
      return Result.value(categoryMediumListJson.asValue.value['result']);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<CategoryMediumVO>>> getCategorySmall(String mediumId) async {
    final categorySmallListJson = await _httpClient.getRequest(HttpUrls.CATEGORY_SMALL + "?mediumId=$mediumId", HttpUrls.headers(""));
    if(categorySmallListJson.isValue) {
      return Result.value((categorySmallListJson.asValue.value['result'] as List)
          .map((smallJson) => CategoryMediumVO.fromJson(smallJson as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> getSentence() async {

  }

}