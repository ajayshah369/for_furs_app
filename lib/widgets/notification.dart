import 'package:flutter/material.dart';

import './sub_widget/badge.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Badge(
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 16),
            child: Icon(
              Icons.notifications_none,
              size: 28,
            ),
          ),
          0,
          12,
          14,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).primaryColor,
          16,
          14,
          false),
    );
  }
}
