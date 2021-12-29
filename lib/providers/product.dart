import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../utilities/dio_instance.dart';
import '../utilities/helper_functions.dart';

import '../screens/products/keyword_products.dart';

class Product with ChangeNotifier {
  List<dynamic> bestCategories = [];
  List<dynamic> bestBrands = [];

  Future<void> fetchBestCategories(BuildContext ctx) async {
    try {
      var response = await dio.get('/categories?best=true&fields=name,image');
      bestCategories = jsonDecode(response.toString())['categories'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> fetchBestBrands(BuildContext ctx) async {
    try {
      var response = await dio.get('/brands?best=true&fields=name,image');
      bestBrands = jsonDecode(response.toString())['brands'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

// ! ////////////////////////////////////////////////////

  int totalCategories = 0;
  List<dynamic> allCategories = [];

  Future<void> fetchAllCategories(BuildContext ctx, int page) async {
    try {
      var response = await dio.get('/categories?page=$page');
      totalCategories = jsonDecode(response.toString())['total'];
      allCategories.addAll(jsonDecode(response.toString())['categories']);
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

// ! //////////////////////////////////////////////////////

  int totalBrands = 0;
  List<dynamic> allBrands = [];

  Future<void> fetchAllBrands(BuildContext ctx, int page) async {
    try {
      var response = await dio.get('/brands?page=$page');
      totalBrands = jsonDecode(response.toString())['total'];
      allBrands.addAll(jsonDecode(response.toString())['brands']);
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

// ! ///////////////////////////////////////////

// ? Search By Category
  String categoryId = '';
  List<dynamic> categoryBrands = [];
  List<dynamic> categoryProducts = [];
  bool categoryProductsLoading = false;
  int categoryPage = 1;
  int categoryProductsTotal = 0;
  Map<String, dynamic> categoryFilter = {
    'brand': [],
    'keywords': '',
    'priceRange': [0.0, 50000.0],
  };
  bool categoryFilterChanged = false;

  Future<void> fetchCategoryBrands(BuildContext ctx) async {
    try {
      var response =
          await dio.get('/brands?categories=$categoryId&fields=name&limit=100');
      categoryBrands = jsonDecode(response.toString())['brands'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> setcategoryBrands(String id) async {
    categoryFilter['brand'].contains(id)
        ? categoryFilter['brand'].remove(id)
        : categoryFilter['brand'].add(id);
    notifyListeners();
    categoryFilterChanged = true;
    categoryPage = 1;
  }

  Future<void> setcategoryKeywords(String keyword) async {
    categoryFilter['keywords'] = keyword.toLowerCase();
    categoryFilterChanged = true;
    categoryPage = 1;
  }

  Future<void> setCategoryPriceRange(RangeValues rangeValues) async {
    categoryFilter['priceRange'] = [rangeValues.start, rangeValues.end];
    notifyListeners();
    if (categoryFilter['priceRange'][0] != 0.0 ||
        categoryFilter['priceRange'][1] != 50000.0) {
      categoryFilterChanged = true;
      categoryPage = 1;
    }
  }

  Future<void> fetchCategoryProducts(BuildContext ctx, String id) async {
    if (categoryId == id && categoryFilterChanged == false) {
      return;
    } else if (categoryId == id && categoryFilterChanged == true) {
      categoryProductsLoading = true;
      notifyListeners();
      String url = '/products?categories=$categoryId';
      if (categoryFilter['keywords'].isNotEmpty) {
        url += '&keywords=${categoryFilter['keywords']}';
      }
      if (categoryFilter['brand'].isNotEmpty) {
        url += '&brand=${categoryFilter['brand'].join(',')}';
      }
      if (categoryFilter['priceRange'][0] != 0.0 ||
          categoryFilter['priceRange'][1] != 50000.0) {
        url +=
            '&priceRange=${categoryFilter['priceRange'][0]},${categoryFilter['priceRange'][1]}';
      }
      try {
        var response = await dio.get(url + '&page=$categoryPage');
        categoryProducts = jsonDecode(response.toString())['products'];
        categoryProductsTotal = jsonDecode(response.toString())['total'];
      } on DioError catch (e) {
        onError(ctx, e);
      }
      categoryProductsLoading = false;
      categoryFilterChanged = false;
      notifyListeners();
    } else {
      categoryId = id;
      categoryProducts = [];
      categoryBrands = [];
      categoryFilter = {
        'brand': [],
        'keywords': '',
        'priceRange': categoryFilter['priceRange']
      };
      try {
        var response = await dio.get('/products?categories=$categoryId');
        categoryProducts = jsonDecode(response.toString())['products'];
        categoryProductsTotal = jsonDecode(response.toString())['total'];
        categoryPage = 1;
      } on DioError catch (e) {
        onError(ctx, e);
      }
      notifyListeners();
    }
  }

  Future<void> setCategoryPage(BuildContext ctx, int page) async {
    if (page != categoryPage) {
      categoryPage = page;
      categoryFilterChanged = true;
      notifyListeners();
      fetchCategoryProducts(ctx, categoryId);
    }
  }

// ! ///////////////////////////////////////////

// ? Search By Brand
  String brandId = '';
  List<dynamic> brandCategories = [];
  List<dynamic> brandProducts = [];
  bool brandProductsLoading = false;
  int brandPage = 1;
  int brandProductsTotal = 0;
  Map<String, dynamic> brandFilter = {
    'categories': [],
    'keywords': '',
    'priceRange': [0.0, 50000.0],
  };
  bool brandFilterChanged = false;

  Future<void> fetchBrandCategories(BuildContext ctx) async {
    try {
      var response =
          await dio.get('/brands/$brandId?fields=categories&limit=100');
      brandCategories = jsonDecode(response.toString())['brand']['categories'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> setBrandCategories(String id) async {
    brandFilter['categories'].contains(id)
        ? brandFilter['categories'].remove(id)
        : brandFilter['categories'].add(id);
    notifyListeners();
    brandFilterChanged = true;
    brandPage = 1;
  }

  Future<void> setBrandKeywords(String keyword) async {
    brandFilter['keywords'] = keyword.toLowerCase();
    brandFilterChanged = true;
    brandPage = 1;
  }

  Future<void> setBrandPriceRange(RangeValues rangeValues) async {
    brandFilter['priceRange'] = [rangeValues.start, rangeValues.end];
    notifyListeners();
    if (brandFilter['priceRange'][0] != 0.0 ||
        brandFilter['priceRange'][1] != 50000.0) {
      brandFilterChanged = true;
      brandPage = 1;
    }
  }

  Future<void> fetchBrandProducts(BuildContext ctx, String id) async {
    if (brandId == id && brandFilterChanged == false) {
      return;
    } else if (brandId == id && brandFilterChanged == true) {
      brandProductsLoading = true;
      notifyListeners();
      String url = '/products?brand=$brandId';
      if (brandFilter['keywords'].isNotEmpty) {
        url += '&keywords=${brandFilter['keywords']}';
      }
      if (brandFilter['categories'].isNotEmpty) {
        url += '&categories=${brandFilter['categories'].join(',')}';
      }
      if (brandFilter['priceRange'][0] != 0.0 ||
          brandFilter['priceRange'][1] != 50000.0) {
        url +=
            '&priceRange=${brandFilter['priceRange'][0]},${brandFilter['priceRange'][1]}';
      }
      try {
        var response = await dio.get(url + '&page=$brandPage');
        brandProducts = jsonDecode(response.toString())['products'];
        brandProductsTotal = jsonDecode(response.toString())['total'];
      } on DioError catch (e) {
        onError(ctx, e);
      }
      brandProductsLoading = false;
      brandFilterChanged = false;
      notifyListeners();
    } else {
      brandId = id;
      brandProducts = [];
      brandCategories = [];
      brandFilter = {
        'categories': [],
        'keywords': '',
        'priceRange': brandFilter['priceRange']
      };
      try {
        var response = await dio.get('/products?brand=$brandId');
        brandProducts = jsonDecode(response.toString())['products'];
        brandProductsTotal = jsonDecode(response.toString())['total'];
        brandPage = 1;
      } on DioError catch (e) {
        onError(ctx, e);
      }
      notifyListeners();
    }
  }

  Future<void> setBrandPage(BuildContext ctx, int page) async {
    if (page != brandPage) {
      brandPage = page;
      brandFilterChanged = true;
      notifyListeners();
      fetchBrandProducts(ctx, brandId);
    }
  }

  // ! /////////////////////////////////////////////////

  // ? Search By Keyword
  List<dynamic> keywordProducts = [];
  List<dynamic> keywordCategories = [];
  List<dynamic> keywordBrands = [];
  Map<String, dynamic> keywordFilter = {
    'keyword': '',
    'categories': [],
    'brands': [],
    'priceRange': [0.0, 50000.0],
  };
  int keywordPage = 1;
  bool keywordPageChanged = false;
  bool keywordFilterChanged = false;
  bool keywordProductsLoading = false;
  int keywordProductsTotal = 0;

  Future<void> setKeyword(BuildContext ctx, String k, {bool n = false}) async {
    if (k.isNotEmpty && (k != keywordFilter['keyword'] || !n)) {
      keywordProducts = [];
      keywordCategories = [];
      keywordBrands = [];
      keywordFilter = {
        'keyword': k,
        'categories': [],
        'brands': [],
        'priceRange': [0.0, 50000.0],
      };
      keywordProductsLoading = false;
      keywordPage = 1;
      keywordProductsTotal = 0;

      notifyListeners();
      keywordFilterChanged = true;

      fetchKeywordProducts(ctx, n: n);
    } else if (n) {
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (ctx) => const KeywordProducts()));
    }
  }

  Future<void> setKeywordCategories(String id) async {
    keywordFilter['categories'].contains(id)
        ? keywordFilter['categories'].remove(id)
        : keywordFilter['categories'].add(id);
    notifyListeners();
    keywordFilterChanged = true;
  }

  Future<void> setKeywordBrands(String id) async {
    keywordFilter['brands'].contains(id)
        ? keywordFilter['brands'].remove(id)
        : keywordFilter['brands'].add(id);
    notifyListeners();
    keywordFilterChanged = true;
  }

  Future<void> setKeywordPriceRange(RangeValues rangeValues) async {
    keywordFilter['priceRange'] = [rangeValues.start, rangeValues.end];
    notifyListeners();
    keywordFilterChanged = true;
  }

  Future<void> setKeyWordPage(
      BuildContext ctx, int page, Function scrollTo) async {
    if (keywordPage != page) {
      keywordPage = page;
      keywordPageChanged = true;
      notifyListeners();

      fetchKeywordProducts(ctx);
      scrollTo(page);
    }
  }

  Future<void> fetchKeywordCategories(BuildContext ctx) async {
    try {
      var response = await dio
          .get('/categories?keywords=${keywordFilter['keyword']}&fields=name');
      keywordCategories = jsonDecode(response.toString())['categories'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> fetchKeywordBrands(BuildContext ctx) async {
    try {
      var response = await dio
          .get('/brands?keywords=${keywordFilter['keyword']}&fields=name');
      keywordBrands = jsonDecode(response.toString())['brands'];
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

  Future<void> fetchKeywordProducts(BuildContext ctx, {bool n = false}) async {
    if (!keywordFilterChanged && !keywordPageChanged) {
      return;
    }

    if (keywordFilterChanged) {
      keywordPage = 1;
    }

    keywordProductsLoading = true;
    notifyListeners();
    if (n) {
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (ctx) => const KeywordProducts()));
    }
    String url = '/products?keywords=${keywordFilter['keyword']}';
    if (keywordFilter['categories'].isNotEmpty) {
      url += '&categories=${keywordFilter['categories'].join(',')}';
    }
    if (keywordFilter['brands'].isNotEmpty) {
      url += '&brand=${keywordFilter['brands'].join(',')}';
    }
    if (keywordFilter['priceRange'][0] != 0.0 &&
        keywordFilter['priceRange'][1] != 50000.0) {
      url +=
          '&priceRange=${keywordFilter['priceRange'][0]},${keywordFilter['priceRange'][1]}';
    }

    url += '&page=$keywordPage';

    try {
      var response = await dio.get(url);
      var res = jsonDecode(response.toString());
      keywordProducts = res['products'];
      keywordProductsTotal = res['total'];
      keywordProductsLoading = false;
      keywordFilterChanged = false;
      keywordPageChanged = false;
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }

// ! ////////////////////////////////////////////////////////////////////

  Map<dynamic, dynamic> product = {};
  List<String> images = [];
  bool productLoading = true;

  Future<void> fetchProduct(BuildContext ctx, String id) async {
    if (product.isNotEmpty && product['_id'] == id) {
      productLoading = false;
      notifyListeners();
      return;
    }
    try {
      var response =
          await dio.get('/products/$id?select=description,details,images');
      product = jsonDecode(response.toString())['product'];
      images = List<String>.from(product['images']);
      productLoading = false;
    } on DioError catch (e) {
      onError(ctx, e);
    }
    notifyListeners();
  }
}
