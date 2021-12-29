import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../utilities/dio_instance.dart';
import '../utilities/helper_functions.dart';

class User with ChangeNotifier {
  bool logoutLoading = false;
  String id = '';
  Map<String, dynamic> me = {};

  bool initAddress = true;
  bool addOrupdateAddressLoading = false;
  List<dynamic> addresses = [];

  bool updateImageLoading = false;

  Future<void> isLoggedIn(String id) async {
    id = id;
  }

  Future<void> logout(BuildContext ctx) async {
    logoutLoading = true;
    notifyListeners();
    try {
      await dio.get('user/logout');
      showSnackbar(ctx, 'Logged out successfully');
      Future.delayed(const Duration(seconds: 1), () {
        Phoenix.rebirth(ctx);
      });
    } on DioError catch (e) {
      logoutLoading = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getMe(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/getMe');
      me = jsonDecode(response.toString())['user'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getAddresses(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/address');
      addresses = jsonDecode(response.toString())['addresses'];
      if (initAddress) {
        initAddress = false;
      }
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> addNewAddress(
      BuildContext ctx, Map<String, String> address) async {
    addOrupdateAddressLoading = true;
    notifyListeners();
    try {
      var response = await dio.patch('/user/address', data: address);
      addresses = jsonDecode(response.toString())['addresses'];
      addOrupdateAddressLoading = false;
      Navigator.of(ctx).pop();
    } on DioError catch (e) {
      addOrupdateAddressLoading = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> deleteAddress(BuildContext ctx, int index) async {
    final String id = addresses[index]['_id'];
    final address = addresses[index];
    addresses.removeAt(index);
    notifyListeners();
    try {
      await dio.delete('/user/address/$id');
    } on DioError catch (e) {
      addresses.insert(index, address);
      onError(ctx, e);
      notifyListeners();
    }
  }

  Future<void> updateAddress(
      BuildContext ctx, String id, Map<String, String> address) async {
    addOrupdateAddressLoading = true;
    try {
      var response = await dio.patch('/user/address/$id', data: address);
      addresses = jsonDecode(response.toString())['addresses'];
      showSnackbar(ctx, 'Address updated successfully');
      addOrupdateAddressLoading = false;
      Navigator.of(ctx).pop();
    } on DioError catch (e) {
      addOrupdateAddressLoading = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> removeImage(BuildContext ctx) async {
    updateImageLoading = true;
    notifyListeners();
    try {
      await dio.patch('/user/removeImage');
      me.remove('image');
      updateImageLoading = false;
    } on DioError catch (e) {
      updateImageLoading = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> updateImage(BuildContext ctx, String imagePath) async {
    updateImageLoading = true;
    notifyListeners();
    final List<String> img = imagePath.split('.');

    try {
      var response = await dio.patch('/user/updateMe',
          data: FormData.fromMap({
            'image': await MultipartFile.fromFile(
              imagePath,
              filename: 'profile.${img[img.length - 1]}',
              contentType: MediaType('image', img[img.length - 1]),
            )
          }));
      me['image'] = jsonDecode(response.toString())['user']['image'] +
          '?${DateTime.now().toString()}';
      updateImageLoading = false;
    } on DioError catch (e) {
      updateImageLoading = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> updateName(BuildContext ctx, String name) async {
    final String n = me.containsKey('name') ? me['name'] : '';
    me['name'] = name;
    notifyListeners();
    try {
      await dio.patch('/user/updateMe', data: {'name': name});
    } on DioError catch (e) {
      if (n.isEmpty) {
        me.remove('name');
      } else {
        me['name'] = n;
      }
      onError(ctx, e);
    }
    notifyListeners();
  }

  bool addOrupdatePetLoading = false;
  List<dynamic> pets = [];
  bool initPet = true;

  Future<void> getPets(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/pets');
      pets = jsonDecode(response.toString())['pets'];
      if (initPet) {
        initPet = false;
      }
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> addNewPet(BuildContext ctx, Map<String, String> data) async {
    addOrupdatePetLoading = true;
    notifyListeners();
    try {
      var response = await dio.patch('/user/pets', data: data);
      pets = jsonDecode(response.toString())['pets'];
      Navigator.of(ctx).pop();
    } on DioError catch (e) {
      addOrupdatePetLoading = false;
      onError(ctx, e);
    }
    addOrupdatePetLoading = false;
    notifyListeners();
  }

  Future<void> updatePet(
      BuildContext ctx, String id, Map<String, String> data) async {
    addOrupdatePetLoading = true;
    notifyListeners();
    try {
      var response = await dio.patch('/user/pets/$id', data: data);
      pets = jsonDecode(response.toString())['pets'];
    } on DioError catch (e) {
      addOrupdatePetLoading = false;
      onError(ctx, e);
    }
    addOrupdatePetLoading = false;
    notifyListeners();
    Navigator.of(ctx).pop();
  }

  Future<void> removePet(BuildContext ctx, int index) async {
    final String id = pets[index]['_id'];
    final pet = pets[index];
    pets.removeAt(index);
    notifyListeners();
    try {
      await dio.delete('/user/pets/$id');
    } on DioError catch (e) {
      pets.insert(index, pet);
      onError(ctx, e);
      notifyListeners();
    }
  }

  List<dynamic> recentlyViewedProducts = [];
  List<dynamic> recentlyViewedServices = [];

  Future<void> getRecentlyViewedProducts(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/recentlyViewedProducts');
      recentlyViewedProducts =
          jsonDecode(response.toString())['recentlyViewedProducts'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getRecentlyViewedServices(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/recentlyViewedServices');
      recentlyViewedServices =
          jsonDecode(response.toString())['recentlyViewedServices'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }
}
