import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './sub_widget/grid_items.dart';
import '../providers/product.dart';
import '../screens/products/all_categories.dart';
import '../screens/products/category.dart';

class ShopByCategory extends StatelessWidget {
  const ShopByCategory(
      {Key? key,
      this.maxCrossAxisExtent = 160,
      this.childAspectRatio = 1 / 1.2})
      : super(key: key);
  final double? maxCrossAxisExtent;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridItems(
      title: 'Shop By Category',
      list: Provider.of<Product>(context).bestCategories,
      maxCrossAxisExtent: maxCrossAxisExtent as double,
      childAspectRatio: childAspectRatio as double,
      seeAll: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AllCategories()));
      },
      onTap: (e) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Category(e)));
      },
    );
  }
}
