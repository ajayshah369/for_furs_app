import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../providers/user_cart.dart';

import '../screens/services/service_detail.dart';

import './sub_widget/horizontal_list_items.dart';

class RecentlyViewedServices extends StatelessWidget {
  const RecentlyViewedServices({Key? key}) : super(key: key);

  void func1(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ServiceDetail(
          id,
        ),
      ),
    );
  }

  Future<void> func2(BuildContext context, String id) async {
    await Provider.of<UserCart>(context, listen: false)
        .addToServiceCart(context, id);
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalListItems('Recently Viewed services',
        Provider.of<User>(context).recentlyViewedServices, func1, func2);
  }
}
