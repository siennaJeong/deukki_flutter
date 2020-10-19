
import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:deukki/common/network/exception_mapper.dart';
import 'package:deukki/common/network/http_client.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
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
          .map((json) => CategoryMediumVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<SentenceVO>>> getSentence(String authJWT, String mediumId) async {
    final sentenceListJson = await _httpClient.getRequest(HttpUrls.SENTENCE + "?mediumId=$mediumId", HttpUrls.headers(authJWT));
    if(sentenceListJson.isValue) {
      return Result.value((sentenceListJson.asValue.value['result'] as List)
          .map((json) => SentenceVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<StageVO>>> getSentenceStage(String authJWT, String sentenceId) async {
    final stageListJson = await _httpClient.getRequest(HttpUrls.SENTENCE + "/$sentenceId" + HttpUrls.SENTENCE_STAGE, HttpUrls.headers(authJWT));
    if(stageListJson.isValue) {
      return Result.value((stageListJson.asValue.value['result'] as List)
          .map((json) => StageVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

}