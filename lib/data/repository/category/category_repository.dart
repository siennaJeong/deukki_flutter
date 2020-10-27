import 'dart:io';

import 'package:async/async.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';

abstract class CategoryRepository {
  Future<Result<List<dynamic>>> getCategoryLarge();
  Future<Result<List<dynamic>>> getCategoryMedium(String largeId);
  Future<Result<List<dynamic>>> getCategoryMediumStar(String authJWT, String largeId);
  Future<Result<List<CategoryMediumVO>>> getCategorySmall(String mediumId);
  Future<Result<List<SentenceVO>>> getSentence(String authJWT, String smallId);
  Future<Result<List<StageVO>>> getSentenceStages(String authJWT, String sentenceId);
  Future<Result<CommonResultVO>> getPronunciation(String authJWT, String sentenceId, int stageIdx, bool needRight, String voice);
  Future<Result<String>> saveAudioFile(String dir, String url, String fileName);
  Future<Result<CommonResultVO>> recordUploadLink(String authJWT, File file, int stage, int round, String sentenceId);
  Future<Result<CommonResultVO>> updateRecordResult(String authJWT, int idx);
}