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
    var url = Uri.parse(path);
    try {
      response = await get(url, headers: headers);
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

  Future<Result<dynamic>> reportRequest(String path, Map<String, String> headers) async {
    Response response;
    var url = Uri.parse(path);
    try {
      response = await get(url, headers: headers);
      if(response.body.isEmpty) {
        return Result.value(null);
      }else {
        return Result.value(jsonDecode(response.body));
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> postRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    var url = Uri.parse(path);
    try {
      response = await post(url, headers: headers, body: body);
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

  Future<Result<dynamic>> paymentRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    var url = Uri.parse(path);
    try {
      response = await post(url, headers: headers, body: body);
      if(response.body.isEmpty) {
        return Result.value(null);
      }else {
        return Result.value(jsonDecode(response.body));
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> recordRequest(String path, Map<String, String> headers, Map<String, String> body) async {
    Response response;
    var url = Uri.parse(Uri.encodeFull(path));
    try {
      response = await post(url, headers: headers, body: body);
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

  Future<Result<dynamic>> couponRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    var url = Uri.parse(path);
    try {
      response = await post(url, headers: headers, body: body);
      final statusCode = response.statusCode;
      if(response.body.isEmpty) {
        return Result.value(null);
      }else {
        return Result.value(statusCode);
      }
    }on SocketException {
      throw Result.error(ConnectionException());
    }
  }

  Future<Result<dynamic>> patchRequest(String path, Map<String, String> headers, Map<String, dynamic> body) async {
    Response response;
    var url = Uri.parse(path);
    try {
      response = await patch(url, headers: headers, body: body);
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
    var url = Uri.parse(path);
    try {
      response = await delete(url, headers: headers);
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