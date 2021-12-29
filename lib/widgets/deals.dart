import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttericon/octicons_icons.dart';

class Deals extends StatefulWidget {
  const Deals({Key? key}) : super(key: key);

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  final List<Color> colors = const [Colors.red, Colors.green, Colors.blue];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              initialPage: currentIndex,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              onPageChanged: (index, _) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: colors.map((e) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: e,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          top: 170,
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: colors.length,
              itemBuilder: (context, index) => Icon(
                Octicons.primitive_dot,
                color: index == currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
