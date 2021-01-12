import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/data/model/report_vo.dart';
import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/model/verify_token_vo.dart';
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
  final getProductList = ProviderModelResult<List<ProductionVO>>();
  final updateMarketingAgree = ProviderModelResult<CommonResultVO>();
  final getReports = ProviderModelResult<ReportVO>();
  final verifyToken = ProviderModelResult<VerifyTokenVO>();
}