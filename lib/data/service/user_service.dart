
import 'package:deukki/common/network/http_request.dart';
import 'package:deukki/common/network/request_mappers.dart';
import 'package:deukki/common/utils/http_util.dart';
import 'package:deukki/data/service/user_request.dart';

class CheckSignUpService extends HttpRequestProtocol {
  final String getParameter;
  CheckSignUpService(this.getParameter);

  @override
  HttpMethod get method => HttpMethod.GET;

  @override
  String get serverUrl => HttpUrls.SERVER_URL;

  @override
  String get path => getParameter;

  @override
  Map<String, dynamic> get parameters => null;

}

