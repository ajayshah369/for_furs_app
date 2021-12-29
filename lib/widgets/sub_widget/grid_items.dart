import 'package:flutter/material.dart';

import './sub_sub_widget/see_all.dart';
import '../shimmer.dart';

class GridItems extends StatelessWidget {
  const GridItems(
      {required this.title,
      required this.list,
      required this.maxCrossAxisExtent,
      required this.childAspectRatio,
      required this.seeAll,
      required this.onTap,
      this.sh = const [1, 2, 3, 4, 5, 6],
      Key? key})
      : super(key: key);

  final String title;
  final List<dynamic> list;
  final double maxCrossAxisExtent;
  final double childAspectRatio;
  final dynamic seeAll;
  final Function onTap;
  final List<int> sh;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        children: [
          SeeAll(title, seeAll),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxCrossAxisExtent,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16),
            children: list.isNotEmpty
                ? list
                    .map((e) => InkWell(
                          onTap: () => onTap(e),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LayoutBuilder(builder: (ctx, constraints) {
                                return Container(
                                  height: constraints.maxWidth,
                                  width: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Image.network(
                                    e['image'],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  e['name'],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList()
                : sh
                    .map((e) => ShimmerWidget(Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )))
                    .toList(),
          )
        ],
      ),
    );
  }
}
