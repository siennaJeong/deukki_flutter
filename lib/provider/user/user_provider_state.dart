import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/provider/provider_model_result.dart';

class UserProviderState {
  final checkSignUp = ProviderModelResult<CommonResultVO>();
  final signUp = ProviderModelResult<CommonResultVO>();
  final signOut = ProviderModelResult<CommonResultVO>();
  final login = ProviderModelResult<CommonResultVO>();
  final logout = ProviderModelResult<CommonResultVO>();
  final recordLearning = ProviderModelResult<CommonResultVO>();
  final updateBookmark = ProviderModelResult<CommonResultVO>();
  final getBookmark = ProviderModelResult<List<BookmarkVO>>();
  final deleteBookmark = ProviderModelResult<CommonResultVO>();
  final getUserInfo = ProviderModelResult<UserVOForHttp>();
}