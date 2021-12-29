import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({this.left = 0, this.right = 0, Key? key}) : super(key: key);

  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: left as double, right: right as double),
      alignment: Alignment.center,
      child: const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/for_furs.png'),
      ),
    );
  }
}
