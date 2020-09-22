import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:deukki/common/network/api_exception.dart';
import 'package:http/http.dart';

class HttpClient {
  HttpClient._privateConstructor();
  static final HttpClient _instance = HttpClient._privateConstructor();
  factory HttpClient() { return _instance; }

  Future<Result<dynamic>> getRequest(String path) async {
    Response response;
    try {
      response = await get(path);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result<dynamic>.value(null);
        }else {
          return Result<dynamic>.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw Result<dynamic>.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        throw Result<dynamic>.error(ServerErrorException());
      }else {
        throw Result<dynamic>.error(UnknownException());
      }
    }on SocketException {
      throw Result<dynamic>.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> postRequest(String path, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await post(path, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result<dynamic>.value(null);
        }else {
          return Result<dynamic>.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw Result<dynamic>.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        throw Result<dynamic>.error(ServerErrorException());
      }else {
        throw Result<dynamic>.error(UnknownException());
      }
    }on SocketException {
      throw Result<dynamic>.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> patchRequest(String path, Map<String, dynamic> body) async {
    Response response;
    try {
      response = await patch(path, body: body);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result<dynamic>.value(null);
        }else {
          return Result<dynamic>.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw Result<dynamic>.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        throw Result<dynamic>.error(ServerErrorException());
      }else {
        throw Result<dynamic>.error(UnknownException());
      }
    }on SocketException {
      throw Result<dynamic>.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> deleteRequest(String path) async {
    Response response;
    try {
      response = await delete(path);
      final statusCode = response.statusCode;
      if(statusCode >= 200 && statusCode < 299) {
        if(response.body.isEmpty) {
          return Result<dynamic>.value(null);
        }else {
          return Result<dynamic>.value(jsonDecode(response.body));
        }

      }else if(statusCode >= 400 && statusCode < 500) {
        throw Result<dynamic>.error(ClientErrorException());
      }else if(statusCode >= 500 && statusCode < 600) {
        throw Result<dynamic>.error(ServerErrorException());
      }else {
        throw Result<dynamic>.error(UnknownException());
      }
    }on SocketException {
      throw Result<dynamic>.error(ConnectionException());
    }
  }

}