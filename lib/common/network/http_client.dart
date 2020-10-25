import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:http/http.dart';

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() { return _instance; }

  Future<Result<dynamic>> getRequest(String path, Map<String, String> headers) async {
    Response response;
    try {
      response = await get(path, headers: headers);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result.value(null);
        }else {
          return Result.value(jsonDecode(response.body));
        }
      }else if(statusCode >= 400 && statusCode < 500) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ServerErrorException());
      }else {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(UnknownException());
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> postRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await post(path, headers: headers, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result.value(null);
        }else {
          return Result.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ServerErrorException());
      }else {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(UnknownException());
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> patchRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await patch(path, headers: headers, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result.value(null);
        }else {
          return Result.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ServerErrorException());
      }else {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(UnknownException());
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> deleteRequest(String path, Map<String, String> headers) async {
    Response response;
    try {
      response = await delete(path, headers: headers);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result.value(null);
        }else {
          return Result.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(ServerErrorException());
      }else {
        print("error code : " + statusCode.toString());
        print("body : " + response.body.toString());
        throw Result.error(UnknownException());
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

}