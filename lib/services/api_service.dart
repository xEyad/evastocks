import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nosooh/components/loading_indicator.dart';
import 'package:nosooh/screens/auth/login_2.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:nosooh/services/token_manager.dart';
import 'package:nosooh/utils/functions.dart';

class APIService with ChangeNotifier, TokenManager {
  final String webBaseUrl = 'https://evastocks.com/api/';
  //final String webBaseUrl = 'https://api.noshca.com/api/';
  final Dio _dio = Dio();

  Future<Response> postRequest({
    required String url,
    required Map? body,
    bool hasToken = true,
    bool invalidTokenRedirection = true,
  }) async {
    Map<String, String> generalHeaders = {
      'language':
          AppLocalizations.of(NavigationService.context!)!.localeName == 'en'
              ? '2'
              : '1',
      'deviceType': '2',
      'deviceToken': 'sunnanToken',
      'x-app-version': '1.1',
    };

    if (hasToken) {
      final token = await getJWTToken();
      print(token);

      generalHeaders.addAll({'Authorization': 'Bearer $token'});
    }

    Options options = Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: generalHeaders);

    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.transparent,
        barrierDismissible: false);

    final callResult =
        await _dio.post(url, data: body, options: options).then((value)async {
      Navigator.of(NavigationService.context!).pop();
      if (invalidTokenRedirection) {
        await checkTokenValidity(value);
      }
      return value;
    }).catchError((error) {
      if (error is TimeoutException) {
        print('Time Out Exception');
      } else if (error is SocketException) {
        print('Socket Exception');
      } else {
        print('Error');
        print(error);
      }
    });

    return callResult;
  }

  Future<Response> postRequestFormData({
    required String url,
    required Map<String, dynamic> body,
    bool hasToken = true,
    bool invalidTokenRedirection = true,
  }) async {
    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.transparent,
        barrierDismissible: false);

    Map<String, String> generalHeaders = {
      'language':
          AppLocalizations.of(NavigationService.context!)!.localeName == 'en'
              ? '2'
              : '1',
      'deviceType': '2',
      'deviceToken': 'sunnanToken',
      'x-app-version': '1.1'
    };
    if (hasToken) {
      final token = await getJWTToken();
      if (kDebugMode) {
        print(token);
      }
      generalHeaders.addAll({'Authorization': 'Bearer $token'});
    }

    Options options = Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: generalHeaders);

    print(generalHeaders);

    final callResult = await _dio
        .post(url, data: FormData.fromMap(body), options: options)
        .then((value) async{
      Navigator.of(NavigationService.context!).pop();
      print(value.data);
      if (invalidTokenRedirection) {
        await checkTokenValidity(value);
      }
      return value;
    }).catchError((error) {
      if (error is TimeoutException) {
        print('Time Out Exception');
      } else if (error is SocketException) {
        print('Socket Exception');
      } else {
        print('Error');
        print(error);
      }
    });

    return callResult;
  }

  Future<Response> getRequest({
    required String url,
    Map<String, String>? queryParameters,
    bool hasToken = true,
  }) async {
    Map<String, String> generalHeaders = {
      'language':
          AppLocalizations.of(NavigationService.context!)!.localeName == 'en'
              ? '2'
              : '1',
      'deviceType': '2',
      'deviceToken': 'sunnanToken',
      'x-app-version': '1.1'
    };
    if (hasToken) {
      final token = await getJWTToken();
      if (kDebugMode) {
        print(token);
      }
      generalHeaders.addAll({'Authorization': 'Bearer $token'});
    }


    Options options = Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: generalHeaders);

    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.transparent,
        barrierDismissible: false);

    final callResult = await _dio
        .get(url, options: options, queryParameters: queryParameters)
        .then((value)async {
      Navigator.of(NavigationService.context!).pop();
      print(value.data);
      await checkTokenValidity(value);

      return value;
    }).catchError((error) {
      if (error is TimeoutException) {
        print('Time Out Exception');
      } else if (error is SocketException) {
        print('Socket Exception');
      } else {
        throw error;
      }
    });

    return callResult;
  }

  Future<Response> deleteRequest(
      {required String url, Map<String, String>? queryParameters}) async {
    final token = await getJWTToken();

    Options options = Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {'Authorization': 'Bearer $token'});
    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.transparent,
        barrierDismissible: false);

    final callResult = await _dio
        .delete(url, options: options, queryParameters: queryParameters)
        .then((value) {
      Navigator.of(NavigationService.context!).pop();
      return value;
    }).catchError((error) {
      if (error is TimeoutException) {
        print('Time Out Exception');
      } else if (error is SocketException) {
        print('Socket Exception');
      } else {
        print('Error');
      }
    });

    return callResult;
  }

  Future<Response> putRequest({
    required String url,
    required Map? body,
  }) async {
    final token = await getJWTToken();
    Options options = Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {'Authorization': 'Bearer $token'});
    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.transparent,
        barrierDismissible: false);

    final callResult =
        await _dio.put(url, data: body, options: options).then((value)async {
      Navigator.of(NavigationService.context!).pop();
      await checkTokenValidity(value);
      return value;
    }).catchError((error) {
      if (error is TimeoutException) {
        print('Time Out Exception');
      } else if (error is SocketException) {
        print('Socket Exception');
      } else {
        print('Error');
        print(error);
      }
    });

    return callResult;
  }

  checkTokenValidity(dynamic value) async{
    if (value.data['code'] == '1010') {
      await logout();
      Navigator.of(NavigationService.context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Login2(),
          ),
          (route) => false);
      showMessage(
          ctx: NavigationService.context!,
          message: 'قم بتسجيل الدخول مرة أخرى',
          title: 'انتهت مدة الجلسة');
    }
  }
}
