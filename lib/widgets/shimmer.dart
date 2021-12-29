import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget(this._widget, {Key? key}) : super(key: key);

  final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        period: const Duration(milliseconds: 1000),
        child: _widget,
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100);
  }
}
