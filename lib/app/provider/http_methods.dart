import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as service;

class HttpMethodsDio {
  HttpMethodsDio._privateConstructor() {
    // Perform any necessary initialization here
    _dio = Dio()
    // ..options.baseUrl = 'https://your-api-base-url.com' // Set your base URL
      ..interceptors.add(LogInterceptor(
          responseBody: true,
          logPrint: (data) {
            if (kDebugMode) {
              log(">>>>>>>>>>>>>>>>>>>>>>>>api_response_log $data");
            }
          })); // Add logging (optional)
    if (kDebugMode) {
      print('MySingleton instance created');
    }
  }

  factory HttpMethodsDio() {
    return _instance;
  }

  static final HttpMethodsDio _instance = HttpMethodsDio._privateConstructor();
  late final Dio _dio;

  Map<String, dynamic> failedMap = {"status": "failed"};

  getMethod({required String api, required Function fun}) async {
    if (kDebugMode) {
      print("<<jks>>>>>API_CALL>>>>>>\n\n\n\n\n$api");
    }
    try {
      service.Response response = await _dio.get(api);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          fun(response.data);
        } catch (e) {
          if (kDebugMode) {
            print("Message is: $e");
          }
        }
      } else if (response.statusCode == 500) {
        if (kDebugMode) {
          print("jks>>${response.data}");
        }
        fun(response.data);
      } else {
        if (kDebugMode) {
          print("jks>>${response.data}");
        }
        fun(failedMap);
      }
    } on DioException catch (e) {
      //log("Connector Response Error>>" + jsonEncode(e.message));
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.cancel:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.badResponse:
          fun(e.response?.data ?? "");
          break;
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          fun(failedMap);
          break;
        case DioExceptionType.connectionError:
          fun(failedMap);
          break;
        default:
          fun(failedMap);
          break;
      }
    }
  }
}