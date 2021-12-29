import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/logo.dart';
import '../widgets/notification.dart';
import '../widgets/cart.dart';
import '../widgets/search.dart';
import '../widgets/deals.dart';
import '../widgets/shop_by_category.dart';
import '../widgets/shop_by_brand.dart';
import '../widgets/pet_care.dart';
import '../widgets/health_care.dart';

import '../providers/service.dart';
import '../providers/product.dart';
import '../providers/user_cart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    if (Provider.of<Service>(context, listen: false).petCare.isEmpty) {
      Provider.of<Service>(context, listen: false).getPetCare(context);
    }
    if (Provider.of<Service>(context, listen: false).healthCare.isEmpty) {
      Provider.of<Service>(context, listen: false).getHealthCare(context);
    }

    if (Provider.of<Product>(context, listen: false).bestCategories.isEmpty) {
      Provider.of<Product>(context, listen: false).fetchBestCategories(context);
    }
    if (Provider.of<Product>(context, listen: false).bestBrands.isEmpty) {
      Provider.of<Product>(context, listen: false).fetchBestBrands(context);
    }

    if (Provider.of<UserCart>(context, listen: false).initCart) {
      Provider.of<UserCart>(context, listen: false).getCartValue();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bh = 50;
    return Scaffold(
      appBar: AppBar(
        leading: const Logo(),
        title: Text('For Furs', style: Theme.of(context).textTheme.headline1),
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
        actions: const [
          NotificationWidget(),
          Cart(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<Product>(context, listen: false)
              .fetchBestCategories(context);
          Provider.of<Product>(context, listen: false).fetchBestBrands(context);
        },
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Deals(),
              PetCare(),
              HealthCare(),
              ShopByCategory(),
              ShopByBrand()
            ],
          ),
        ),
      ),
    );
  }
}
