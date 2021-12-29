import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_cart.dart';

import '../screens/products/product_details.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.products, {Key? key}) : super(key: key);

  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {
    var userProducts = Provider.of<UserCart>(context);
    return Stack(children: [
      ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductDetail(product['_id'])));
              },
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.all(10),
                color: Colors.grey.shade300,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        product['image'],
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: 'Price: ₹ ',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                  children: [
                                TextSpan(
                                    text: product['price'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700))
                              ])),
                          const SizedBox(height: 8),
                          if (product.containsKey('rating'))
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (ctx, index) {
                                        double r = product['rating'].toDouble();
                                        return Icon(
                                          r > index
                                              ? r < index + 1
                                                  ? Icons.star_half
                                                  : Icons.star
                                              : Icons.star_border_sharp,
                                          color: Colors.red,
                                        );
                                      }),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${product['rating'].toDouble()}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          TextButton(
                            onPressed: () {
                              Provider.of<UserCart>(context, listen: false)
                                  .addToProductCart(context, product['_id']);
                            },
                            child: const Text(
                              'Add To Cart',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(200, 25)),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            side: BorderSide(
                                                color: Colors.red, width: 2)))),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      if (userProducts.modifyingCart)
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white54,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              )),
            ))
    ]);
  }
}
