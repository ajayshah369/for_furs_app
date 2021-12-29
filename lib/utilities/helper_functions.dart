import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:dio/dio.dart';

void showSnackbar(BuildContext ctx, String message) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
}

void on401(Map<String, dynamic> e, BuildContext ctx) {
  if (e['statusCode'] == 401) {
    ScaffoldMessenger.of(ctx)
        .showSnackBar(SnackBar(content: Text(e['message'] as String)));
    Future.delayed(const Duration(seconds: 1), () {
      Phoenix.rebirth(ctx);
    });
  }
}

void onError(BuildContext ctx, DioError e) {
  Map<String, dynamic> error = jsonDecode(e.response.toString());

  on401(error, ctx);
  showSnackbar(ctx, error['message']);
}
