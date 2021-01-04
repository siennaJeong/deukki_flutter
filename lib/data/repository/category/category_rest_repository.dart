
import 'dart:io';

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
import 'package:http/http.dart';

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
  Future<Result<List<dynamic>>> getCategoryMedium(String largeId) async {
    final categoryMediumListJson = await _httpClient.getRequest(HttpUrls.CATEGORY_MEDIUM, HttpUrls.headers(""));
    if(categoryMediumListJson.isValue) {
      return Result.value(categoryMediumListJson.asValue.value['result']);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<List<dynamic>>> getCategoryMediumStar(String authJWT, String largeId) async {
    final starListJson = await _httpClient.getRequest(HttpUrls.CATEGORY_MEDIUM_SCORE + "?largeId=$largeId", HttpUrls.headers(authJWT));
    if(starListJson.isValue) {
      return Result.value(starListJson.asValue.value['result']);
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
  Future<Result<List<StageVO>>> getSentenceStages(String authJWT, String sentenceId) async {
    final stageListJson = await _httpClient.getRequest(HttpUrls.SENTENCE + "/$sentenceId" + HttpUrls.SENTENCE_STAGE, HttpUrls.headers(authJWT));
    if(stageListJson.isValue) {
      return Result.value((stageListJson.asValue.value['result'] as List)
          .map((json) => StageVO.fromJson(json as Map<String, dynamic>))
          .toList());
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> getPronunciation(String authJWT, String sentenceId, int stageIdx, bool needRight, String voice) async {
    final pronunciationJson = await _httpClient.getRequest(HttpUrls.STAGE_PRONUNCIATION + "/$sentenceId/$stageIdx" + "?needRight=${needRight.toString()}&voice=$voice", HttpUrls.headers(authJWT));
    if(pronunciationJson.isValue) {
      return Result.value(CommonResultVO.fromJson(pronunciationJson.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<String>> saveAudioFile(String dir, String url, String fileName) async {
    File file = new File('$dir/$fileName');
    var request = await get(url);
    var bytes = request.bodyBytes;
    await file.writeAsBytes(bytes);
    if(file.path.isNotEmpty) {
      return Result.value(file.path);
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  @override
  Future<Result<CommonResultVO>> recordUploadLink(String authJWT, File file, int stage, int round, String sentenceId) async {
    final recordUploadLink = await _httpClient.postRequest(HttpUrls.RECORD_UPLOAD, HttpUrls.postHeaders(authJWT), _uploadToJson(stage.toString(), round.toString(), sentenceId));
    if(recordUploadLink.isValue) {
      final result = recordUploadLink.asValue.value['result'];
      final idx = result['idx'];
      final uploadUrl = result['uploadUrl'];
      _upload(authJWT, idx, uploadUrl, file);
      return Result.value(CommonResultVO.fromJson(recordUploadLink.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  Future<void> _upload(String authJWT, int idx, String url, File file) async {
    var response = await put(url, headers: HttpUrls.uploadHeader(), body: await file.readAsBytes());
    print("upload done : " + response.statusCode.toString());
    if(response.statusCode == 200) {
      updateRecordResult(authJWT, idx);
    }
  }

  @override
  Future<Result<CommonResultVO>> updateRecordResult(String authJWT, int idx) async {
    final updateRecordResult = await _httpClient.patchRequest("${HttpUrls.RECORD_UPLOAD}/$idx?isUpload=true", HttpUrls.headers(authJWT), null);
    if(updateRecordResult.isValue) {
      return Result.value(CommonResultVO.fromJson(updateRecordResult.asValue.value as Map<String, dynamic>));
    }else {
      return Result.error(ExceptionMapper.toErrorMessage(EmptyResultException()));
    }
  }

  Map<String, dynamic> _uploadToJson(String stage, String round, String sentenceId) => <String, dynamic> {
    'stage': stage,
    'round': round,
    'sentenceId': sentenceId,
  };
}