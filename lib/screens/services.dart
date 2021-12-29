import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/service.dart';
import '../providers/user.dart';

import '../widgets/search.dart';
import '../widgets/notification.dart';
import '../widgets/cart.dart';
import '../widgets/deals.dart';
import '../widgets/pet_care.dart';
import '../widgets/health_care.dart';
import '../widgets/recently_viewed_services.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  void initState() {
    Provider.of<User>(context, listen: false)
        .getRecentlyViewedServices(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bh = 50;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Services',
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(bh),
          child: Search(
            hintText: 'Search for services',
            height: bh,
            onSubmit: (v) async {
              Provider.of<Service>(context, listen: false)
                  .setKeyword(v, context, n: true);
            },
          ),
        ),
        actions: const [NotificationWidget(), Cart()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Deals(),
            const PetCare(
              maxCrossAxisExtent: 200,
            ),
            const HealthCare(
              maxCrossAxisExtent: 200,
            ),
            if (Provider.of<User>(context).recentlyViewedServices.isNotEmpty)
              const RecentlyViewedServices(),
          ],
        ),
      ),
    );
  }
}
