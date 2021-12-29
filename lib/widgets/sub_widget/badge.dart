import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge(this.child, this.value, this.top, this.right, this.bgColor,
      this.fgColor, this.width, this.fontSize, this.bold,
      {Key? key})
      : super(key: key);

  final Widget child;
  final int value;
  final double top;
  final double right;
  final Color bgColor;
  final Color fgColor;
  final double width;
  final double fontSize;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            top: top,
            right: right,
            child: value == 0
                ? const SizedBox()
                : Container(
                    width: width,
                    height: width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width / 2),
                        color: bgColor),
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                          fontSize: fontSize,
                          color: fgColor,
                          fontFamily: 'Roboto',
                          fontWeight: bold ? FontWeight.w600 : FontWeight.w400),
                    ),
                  ))
      ],
    );
  }
}
