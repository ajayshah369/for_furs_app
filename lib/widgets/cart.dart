import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_cart.dart';

import './sub_widget/badge.dart';
import '../screens/cart/cart_screen.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const CartScreen()));
      },
      child: Badge(
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: FittedBox(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Provider.of<UserCart>(context).cartQuantity,
          2,
          4,
          Theme.of(context).primaryColor,
          Colors.white,
          20,
          14,
          true),
    );
  }
}
