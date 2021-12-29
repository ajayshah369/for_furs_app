import 'package:flutter/material.dart';
import 'package:for_furs_app/widgets/shop_by_brand.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/user.dart';

import '../widgets/search.dart';
import '../widgets/notification.dart';
import '../widgets/cart.dart';
import '../widgets/deals.dart';
import '../widgets/shop_by_category.dart';
import '../widgets/shop_by_brand.dart';
import '../widgets/recently_viewed_products.dart';

class Essentials extends StatefulWidget {
  const Essentials({Key? key}) : super(key: key);

  @override
  State<Essentials> createState() => _EssentialsState();
}

class _EssentialsState extends State<Essentials> {
  @override
  void initState() {
    Provider.of<User>(context, listen: false)
        .getRecentlyViewedProducts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bh = 50;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Essentials',
            style: Theme.of(context).textTheme.headline2,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bh),
            child: Search(
              height: bh,
              onSubmit: (v) async {
                Provider.of<Product>(context, listen: false)
                    .setKeyword(context, v, n: true);
              },
            ),
          ),
          actions: const [NotificationWidget(), Cart()]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Deals(),
            // DiscontinuedItems(),
            const ShopByCategory(
              maxCrossAxisExtent: 200,
            ),
            const ShopByBrand(
              maxCrossAxisExtent: 200,
            ),
            if (Provider.of<User>(context).recentlyViewedProducts.isNotEmpty)
              const RecentlyViewedProducts()
            // RecomendedItems(),
          ],
        ),
      ),
    );
  }
}
