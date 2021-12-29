import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/user_cart.dart';

class ProductCartItem extends StatelessWidget {
  const ProductCartItem(this.item, {Key? key}) : super(key: key);

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                item['product']['image'],
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['product']['name'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text('₹ ${item['product']['price'].toString()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
              ],
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade400,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<UserCart>(context, listen: false)
                              .removeFromProductCart(
                                  context, item['product']['_id'],
                                  onCartScreen: true);
                        },
                        child: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                      ),
                      Text(item['quantity'].toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic)),
                      InkWell(
                        onTap: () {
                          Provider.of<UserCart>(context, listen: false)
                              .addToProductCart(context, item['product']['_id'],
                                  onCartScreen: true);
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Provider.of<UserCart>(context, listen: false)
                        .removeAllFromProductCart(
                            context, item['product']['_id']);
                  },
                  child: SvgPicture.asset(
                    'assets/delete.svg',
                    height: 20,
                    color: Colors.red,
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
