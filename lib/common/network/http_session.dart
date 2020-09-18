import 'dart:convert';
import 'dart:io';

import 'package:deukki/common/network/http_request.dart';
import 'package:deukki/common/network/response_mappers.dart';
import 'package:http/http.dart';
import 'api_exception.dart';

abstract class HttpSessionProtocol<T> {
  Future<ResponseMappable> request({HttpRequestProtocol service, ResponseMappable responseType});
}

class HttpSessions implements HttpSessionProtocol {
  final Client _client;
  HttpSessions(this._client);

  @override
  Future<ResponseMappable> request({HttpRequestProtocol service, ResponseMappable responseType}) async {
    final request = HttpRequest(service);
    try {
      final response = await _client.send(request);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        final data = await response.stream.transform(utf8.decoder).join();
        return ResponseMappable(responseType, data);
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }
    } on SocketException {
      throw ConnectionException();
    }
  }
}


