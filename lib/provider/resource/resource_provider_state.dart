
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/version_vo.dart';
import 'package:deukki/provider/provider_model_result.dart';

class ResourceProviderState {
  final checkAllVersion = ProviderModelResult<CommonResultVO>();
  final checkAppVersion = ProviderModelResult<AppVersionVO>();
  final checkCategoryVersion = ProviderModelResult<CategoryVersionVO>();
  final checkFaqVersion = ProviderModelResult<FaqVersionVO>();
  final checkForceUpdate = ProviderModelResult<CommonResultVO>();
  final getCategoryLarge = ProviderModelResult<List<CategoryLargeVO>>();
  final getCategoryMedium = ProviderModelResult<List<CategoryMediumVO>>();
}