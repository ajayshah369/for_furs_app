// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../utilities/dio_instance.dart';
import '../utilities/helper_functions.dart';

import '../screens/account/manage_adress.dart';
import '../screens/cart/order_summary.dart';

class UserCart with ChangeNotifier {
  bool initCart = true;
  int cartQuantity = 0;
  double cartAmount = 0;
  bool modifyingCart = false;

  List<dynamic> productCartItems = [];
  List<dynamic> serviceCartItems = [];

  bool paying = false;

  Future<void> getCartValue() async {
    try {
      var response = await dio.get('/user/cartValue');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
    } on DioError catch (_) {}
    notifyListeners();
  }

  Future<void> addToProductCart(BuildContext ctx, String productId,
      {bool onCartScreen = false}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.get('/user/productCart/$productId');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = productCartItems
            .indexWhere((element) => element['product']['_id'] == productId);
        if (index != -1) {
          productCartItems[index]['quantity'] += 1;
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> removeFromProductCart(BuildContext ctx, String productId,
      {bool onCartScreen = true}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.delete('/user/productCart/$productId');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = productCartItems
            .indexWhere((element) => element['product']['_id'] == productId);
        if (index != -1) {
          productCartItems[index]['quantity'] -= 1;
          if (productCartItems[index]['quantity'] == 0) {
            productCartItems.removeAt(index);
          }
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> removeAllFromProductCart(BuildContext ctx, String productId,
      {bool onCartScreen = true}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.delete('/user/productCart/$productId/all');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = productCartItems
            .indexWhere((element) => element['product']['_id'] == productId);
        if (index != -1) {
          productCartItems.removeAt(index);
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> addToServiceCart(BuildContext ctx, String serviceId,
      {bool onCartScreen = false}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.get('/user/serviceCart/$serviceId');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = serviceCartItems
            .indexWhere((element) => element['service']['_id'] == serviceId);
        if (index != -1) {
          serviceCartItems[index]['quantity'] += 1;
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> removeFromServiceCart(BuildContext ctx, String serviceId,
      {bool onCartScreen = true}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.delete('/user/serviceCart/$serviceId');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = serviceCartItems
            .indexWhere((element) => element['service']['_id'] == serviceId);
        if (index != -1) {
          serviceCartItems[index]['quantity'] -= 1;
          if (serviceCartItems[index]['quantity'] == 0) {
            serviceCartItems.removeAt(index);
          }
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> removeAllFromServiceCart(BuildContext ctx, String serviceId,
      {bool onCartScreen = true}) async {
    modifyingCart = true;
    notifyListeners();
    try {
      var response = await dio.delete('/user/serviceCart/$serviceId/all');
      var res = jsonDecode(response.toString());
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
      if (onCartScreen) {
        int index = serviceCartItems
            .indexWhere((element) => element['service']['_id'] == serviceId);
        if (index != -1) {
          serviceCartItems.removeAt(index);
        }
      }
      modifyingCart = false;
    } on DioError catch (e) {
      modifyingCart = false;
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> getCart(BuildContext ctx) async {
    try {
      var response = await dio.get('/user/cart');
      var res = jsonDecode(response.toString());
      productCartItems = res['productCart'];
      serviceCartItems = res['serviceCart'];
      cartQuantity = res['cartQuantity'];
      cartAmount = res['cartAmount'].toDouble();
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> setDateTimeForService(
      BuildContext ctx, String serviceCartId, Object value) async {
    DateTime d = DateTime.parse(value.toString());

    int index = serviceCartItems
        .indexWhere((element) => element['_id'] == serviceCartId);

    serviceCartItems[index]['dateTime'] = d.millisecondsSinceEpoch;
    notifyListeners();
  }

  Map<String, dynamic> data = {
    'products': [],
    'services': [],
  };

  Future<void> checkout(BuildContext ctx,
      {bool cart = false,
      Map<dynamic, dynamic> product = const {},
      Map<dynamic, dynamic> service = const {}}) async {
    if (cart) {
      data['products'] = productCartItems
          .map((e) => {
                'product': e['product']['_id'],
                'name': e['product']['name'],
                'price': e['product']['price'],
                'quantity': e['quantity'],
                'image': e['product']['image'],
              })
          .toList();
      data['services'] = serviceCartItems
          .map((e) => {
                'service': e['service']['_id'],
                'name': e['service']['name'],
                'price': e['service']['price'],
                'quantity': e['quantity'],
                'dateTime': e['dateTime'],
                'image': e['service']['image'],
              })
          .toList();
    } else {
      if (product.isNotEmpty) {
        data['products'] = [
          {
            'product': product['_id'],
            'name': product['name'],
            'price': product['price'],
            'quantity': 1,
            'image': product['image'],
          }
        ];
      } else {
        data['products'] = [];
      }
      if (service.isNotEmpty) {
        data['services'] = [
          {
            'service': service['_id'],
            'name': service['name'],
            'price': service['price'],
            'quantity': 1,
            'dateTime': service['dateTime'],
            'image': service['image'],
          }
        ];
      } else {
        data['services'] = [];
      }
    }

    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => ManageAddress(
              selectAddress: true,
              cart: cart,
            )));
  }

  Future<void> selectAddress(BuildContext ctx, Map<String, dynamic> address,
      {bool cart = false}) async {
    data['address'] = address;

    Navigator.of(ctx).pushReplacement(MaterialPageRoute(
        builder: (context) => OrderSummary(
              cart: cart,
            )));
  }

  Future<void> makePayment(BuildContext ctx, {bool cart = false}) async {
    paying = true;
    notifyListeners();

    try {
      var response = await dio.post(
          '/user/getPaymentIntent/${cart == true ? 'true' : 'false'}',
          data: data);
      var paymentIntent = jsonDecode(response.toString())['paymentIntent'];

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        testEnv: true,
        merchantCountryCode: 'IN',
        merchantDisplayName: 'FORFURS PET CARE PRIVATE LIMITED',
        paymentIntentClientSecret: paymentIntent,
      ));

      await Stripe.instance.presentPaymentSheet();

      int count = 0;
      if (data['products'].isNotEmpty && cart == false) {
        count += 1;
      }
      Navigator.of(ctx).popUntil((_) => count++ >= 2);
    } on DioError catch (e) {
      onError(ctx, e);
    } catch (e) {
      print(e);
    }

    paying = false;
    notifyListeners();
  }
}
