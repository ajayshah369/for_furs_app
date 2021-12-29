import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../utilities/dio_instance.dart';
import '../utilities/helper_functions.dart';

import '../screens/services/keyword_services.dart';

class Service with ChangeNotifier {
  List<dynamic> petCare = [];
  List<dynamic> healthCare = [];

  Map<String, dynamic> service = {};
  List<String> images = [];
  bool serviceLoading = true;

  Future<void> getPetCare(BuildContext ctx) async {
    try {
      var response = await dio.get('/services?keywords=pet care&limit=6');
      var res = jsonDecode(response.toString());
      petCare = res['services'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getHealthCare(BuildContext ctx) async {
    try {
      var response = await dio.get('/services?keywords=health care&limit=6');
      var res = jsonDecode(response.toString());
      healthCare = res['services'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getService(BuildContext ctx, String id) async {
    if (service.isNotEmpty && service['_id'] == id) {
      serviceLoading = false;
      notifyListeners();
      return;
    }
    try {
      var response =
          await dio.get('/services/$id?select=images,description,details');
      service = jsonDecode(response.toString())['service'];
      images = List<String>.from(service['images']);
      serviceLoading = false;
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

// ! /////////////////////////////////////////////

// ? /////////////////////////////////////////////
  String keyword = '';
  List<double> priceRange = [0.0, 50000.0];
  int page = 1;
  bool filterChanged = false;
  bool loading = true;
  List<dynamic> services = [];
  int totalServices = 0;

  Future<void> setKeyword(String value, BuildContext ctx,
      {bool n = false}) async {
    if (value.isNotEmpty) {
      keyword = value;
      page = 1;
      priceRange = [0.0, 50000.0];
      filterChanged = true;
      notifyListeners();
      fetchServices(ctx, n: n);
    }
  }

  Future<void> setPriceRange(List<double> value, BuildContext ctx) async {
    if (value[0] == priceRange[0] && value[1] == priceRange[1]) {
      return;
    }
    priceRange = value;
    page = 1;
    filterChanged = true;
    notifyListeners();
  }

  Future<void> setPage(BuildContext ctx, int value, Function scroll) async {
    if (value == page) {
      return;
    }
    page = value;
    filterChanged = true;
    notifyListeners();
    scroll(page);
    fetchServices(ctx);
  }

  Future<void> fetchServices(BuildContext ctx, {bool n = false}) async {
    if (n) {
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (ctx) => const KeywordServices()));
    }

    if (!filterChanged) {
      loading = false;
      notifyListeners();
      return;
    }
    loading = true;
    notifyListeners();

    String url = '/services?keywords=$keyword';
    if (priceRange[0] != 0.0 && priceRange[1] != 50000.0) {
      url += '&priceRange=${priceRange[0]},${priceRange[1]}';
    }
    url += '&page=$page';

    try {
      var response = await dio.get(url);
      var res = jsonDecode(response.toString());
      services = res['services'];
      totalServices = res['total'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    loading = false;
    filterChanged = false;
    notifyListeners();
  }
}
