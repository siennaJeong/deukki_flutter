import 'package:async/async.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';

abstract class CategoryRepository {
  Future<Result<List<dynamic>>> getCategoryLarge();
  Future<Result<List<dynamic>>> getCategoryMedium();
  Future<Result<List<CategoryMediumVO>>> getCategorySmall(String mediumId);
  Future<Result<List<SentenceVO>>> getSentence(String authJWT, String smallId);
  Future<Result<List<StageVO>>> getSentenceStage(String authJWT, String sentenceId);
}