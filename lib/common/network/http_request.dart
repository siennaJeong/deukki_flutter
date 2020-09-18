import 'dart:convert';
import 'package:deukki/common/utils/http_util.dart';
import 'package:http/http.dart';

abstract class HttpRequestProtocol {
  String get serverUrl;
  String get path;
  HttpMethod get method;
  Map<String, dynamic> get parameters;
}

class HttpRequest extends Request{
  final HttpRequestProtocol service;
  HttpRequest(this.service) :super(service.method.value, Uri.parse('${service.serverUrl}${service.path}'));

  @override
  String get body => json.encode(this.service.parameters);
}
