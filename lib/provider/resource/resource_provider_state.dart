
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
import 'package:deukki/provider/provider_model_result.dart';

class ResourceProviderState {
  final checkAllVersion = ProviderModelResult<AppVersionVO>();
  final checkAppVersion = ProviderModelResult<AppVersionVO>();
  final checkCategoryVersion = ProviderModelResult<CategoryVersionVO>();
  final checkFaqVersion = ProviderModelResult<FaqVersionVO>();
  final checkForceUpdate = ProviderModelResult<CommonResultVO>();
  final getCategoryLarge = ProviderModelResult<List<CategoryLargeVO>>();
  final getCategoryMedium = ProviderModelResult<List<CategoryMediumVO>>();
  final getCategoryMediumStar = ProviderModelResult<List<MediumStarsVO>>();
  final getCategorySmall = ProviderModelResult<List<dynamic>>();
  final getSentence = ProviderModelResult<List<SentenceVO>>();
  final getSentenceStages = ProviderModelResult<List<StageVO>>();
  final getPronunciation = ProviderModelResult<CommonResultVO>();
  final saveAudioFile = ProviderModelResult<String>();
}