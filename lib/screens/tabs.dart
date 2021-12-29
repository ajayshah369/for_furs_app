import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/curved_navigation_bar/curved_navigation_bar.dart';

import './services.dart';
import './essentials.dart';
import './home_screen.dart';
import './chat.dart';
import './account/account.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final double iconSize = 25;
  final List<Widget> screens = [
    const Services(),
    const Essentials(),
    const Home(),
    const Chat(),
    const Account()
  ];

  int page = 2;
  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    const Color whiteColor = Colors.white;
    return Scaffold(
      body: screens[page],
      bottomNavigationBar: CurvedNavigationBar(
        color: primaryColor,
        backgroundColor: Colors.white10,
        buttonBackgroundColor: primaryColor,
        buttonBorderColor: primaryColor,
        height: 55,
        index: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        items: [
          SvgPicture.asset(
            'assets/services.svg',
            width: iconSize,
            height: iconSize,
            color: page == 0 ? secondaryColor : whiteColor,
          ),
          SvgPicture.asset(
            'assets/essentials.svg',
            width: iconSize,
            height: iconSize,
            color: page == 1 ? secondaryColor : whiteColor,
          ),
          SvgPicture.asset(
            'assets/home.svg',
            width: iconSize,
            height: iconSize,
            color: page == 2 ? secondaryColor : whiteColor,
          ),
          Icon(
            Icons.chat_outlined,
            size: iconSize,
            color: page == 3 ? secondaryColor : whiteColor,
          ),
          SvgPicture.asset(
            'assets/account.svg',
            width: iconSize,
            height: iconSize,
            color: page == 4 ? secondaryColor : whiteColor,
          ),
        ],
      ),
    );
  }
}
