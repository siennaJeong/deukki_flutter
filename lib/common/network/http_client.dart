import 'dart:convert';
import 'dart:io';

import 'package:deukki/common/network/api_exception.dart';
import 'package:http/http.dart';

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() { return _instance; }

  Future<dynamic> getRequest(String path) async {
    Response response;
    try {
      response = await get(path);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return List<dynamic>();
        }else {
          return jsonDecode(response.body);
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      }else if(statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      }else {
        throw UnknownException();
      }
    }on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> postRequest(String path, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await post(path, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return List<dynamic>();
        }else {
          return jsonDecode(response.body);
        }
      }else if(statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      }else if(statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      }else {
        throw UnknownException();
      }
    }on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> patchRequest(String path, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await patch(path, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return List<dynamic>();
        }else {
          return jsonDecode(response.body);
        }
      }else if(statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      }else if(statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      }else {
        throw UnknownException();
      }
    }on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> deleteRequest(String path) async {
    Response response;
    try {
      response = await delete(path);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return List<dynamic>();
        }else {
          return jsonDecode(response.body);
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      }else if(statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      }else {
        throw UnknownException();
      }
    }on SocketException {
      throw ConnectionException();
    }
  }

}