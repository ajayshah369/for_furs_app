import 'package:flutter/material.dart';

import './sub_sub_widget/see_all.dart';
import './sub_sub_widget/horizontal_list_item.dart';

class HorizontalListItems extends StatelessWidget {
  const HorizontalListItems(this.title, this.list, this.func1, this.func2,
      {Key? key})
      : super(key: key);

  final String title;
  final List<dynamic> list;
  final Function func1;
  final Function func2;

  @override
  Widget build(BuildContext context) {
    const double height = 260;
    const double width = height * 0.6;
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        children: [
          SeeAll(title, null),
          Container(
            height: height,
            margin: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return HorizontalListItem(
                    width, list[index], index, func1, func2);
              },
            ),
          ),
        ],
      ),
    );
  }
}
