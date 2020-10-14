import 'package:async/async.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';

abstract class CategoryRepository {
  Future<Result<List<dynamic>>> getCategoryLarge();
  Future<Result<List<dynamic>>> getCategoryMedium();
  Future<Result<List<dynamic>>> getCategorySmall();
  Future<Result<CommonResultVO>> getSentence();
}