import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utilities/dio_instance.dart';
import '../utilities/helper_functions.dart';

class UserOrders with ChangeNotifier {
  int productOrderPage = 1;
  int totalProductOrders = 0;
  List<dynamic> productOrders = [];
  bool productOrdersLoading = false;

  int serviceOrderPage = 1;
  int totalServiceOrders = 0;
  List<dynamic> serviceOrders = [];
  bool serviceOrdersLoading = false;

  Future<void> setProductOrdersPage(
      BuildContext ctx, int page, Function scrollTo) async {
    productOrdersLoading = true;
    productOrderPage = page;
    scrollTo(page);
    notifyListeners();
    getProductOrders(ctx);
  }

  Future<void> getProductOrders(BuildContext ctx) async {
    try {
      var response = await dio.get('user/productOrders?page=$productOrderPage');
      var res = jsonDecode(response.toString());
      totalProductOrders = res['total'];
      productOrders = res['orders'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    if (productOrdersLoading) {
      productOrdersLoading = false;
    }
    notifyListeners();
  }

  Future<void> setServiceOrdersPage(
      BuildContext ctx, int page, Function scrollTo) async {
    serviceOrdersLoading = true;
    serviceOrderPage = page;
    scrollTo(page);
    notifyListeners();
    getServiceOrders(ctx);
  }

  Future<void> getServiceOrders(BuildContext ctx) async {
    try {
      var response = await dio.get('user/serviceOrders?page=$serviceOrderPage');
      var res = jsonDecode(response.toString());
      totalServiceOrders = res['total'];
      serviceOrders = res['orders'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    if (serviceOrdersLoading) {
      serviceOrdersLoading = false;
    }
    notifyListeners();
  }
}
