import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/user_cart.dart';

import '../screens/products/product_details.dart';

import './sub_widget/horizontal_list_items.dart';

class RecentlyViewedProducts extends StatelessWidget {
  const RecentlyViewedProducts({Key? key}) : super(key: key);

  void func1(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetail(
          id,
        ),
      ),
    );
  }

  Future<void> func2(BuildContext context, String id) async {
    await Provider.of<UserCart>(context, listen: false)
        .addToProductCart(context, id);
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalListItems('Recently Viewed Products',
        Provider.of<User>(context).recentlyViewedProducts, func1, func2);
  }
}
