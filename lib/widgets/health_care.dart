import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/service.dart';
import './sub_widget/grid_items.dart';
import '../screens/services/service_detail.dart';

class HealthCare extends StatelessWidget {
  const HealthCare(
      {Key? key,
      this.maxCrossAxisExtent = 160,
      this.childAspectRatio = 1 / 1.2})
      : super(key: key);

  final double? maxCrossAxisExtent;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridItems(
      title: 'Health Care',
      list: Provider.of<Service>(context).healthCare,
      maxCrossAxisExtent: maxCrossAxisExtent as double,
      childAspectRatio: childAspectRatio as double,
      seeAll: null,
      onTap: (e) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ServiceDetail(e['_id']),
          ),
        );
      },
      sh: const [1, 2, 3, 4, 5, 6],
    );
  }
}
