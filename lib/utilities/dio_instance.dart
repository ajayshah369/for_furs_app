import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

var options = BaseOptions(
  baseUrl: 'https://forfurs.aj7.tech/api/v1/',
  responseType: ResponseType.json,
);

var dio = Dio(options);

void setDioInterceptors() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  var persistCookieJar =
      PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
  dio.interceptors.add(CookieManager(persistCookieJar));
  persistCookieJar.loadForRequest(Uri.parse('https://forfurs.aj7.tech'));
}

// Emulator: http://10.0.2.2:8000
// Real device http://192.168.43.127:8000
// Real World https://forfurs.aj7.tech
