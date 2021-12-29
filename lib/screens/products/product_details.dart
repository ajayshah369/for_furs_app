import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../providers/product.dart';
import '../../providers/user_cart.dart';

import '../../widgets/notification.dart';
import '../../widgets/cart.dart';
import '../../widgets/search.dart';
import '../../widgets/shimmer.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  double top = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<Product>(context, listen: false)
          .fetchProduct(context, widget.id);
    });

    scrollController.addListener(() {
      setState(() {
        top = (160 * scrollController.position.pixels) /
            scrollController.position.maxScrollExtent;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pr = Provider.of<Product>(context);
    var product = pr.product;
    List<String> images = pr.images;

    const double bh = 50;
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Search'),
        titleTextStyle: Theme.of(context).textTheme.headline2,
        // leading: const Logo(),
        actions: const [NotificationWidget(), Cart()],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bh),
            child: Column(children: [
              Search(
                height: bh,
                onSubmit: (v) async {
                  Provider.of<Product>(context, listen: false)
                      .setKeyword(context, v, n: true);
                },
              ),
            ])),
      ),
      body: product.isEmpty || product['_id'] != widget.id
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ShimmerWidget(
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ShimmerWidget(
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 400,
                              initialPage: currentIndex,
                              viewportFraction: 1,
                              onPageChanged: (index, _) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            items: images.map((e) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      e,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 24,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: CircleAvatar(
                                        radius: 3,
                                        backgroundColor: currentIndex == index
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 8,
                            child: SizedBox(
                              height: 64,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text('₹ ${product['price'].toString()}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: SizedBox(
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
                          )
                        ],
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            Provider.of<UserCart>(context, listen: false)
                                .addToProductCart(context, product['_id']);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.center,
                            color: Colors.red,
                            child: const Text('Add to Cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            Provider.of<UserCart>(context, listen: false)
                                .checkout(context, product: {
                              '_id': product['_id'],
                              'name': product['name'],
                              'image': product['image'],
                              'price': product['price'],
                            })
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.center,
                            color: Theme.of(context).colorScheme.secondary,
                            child: const Text('Order Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ]),
                      Container(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                          ),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  32 -
                                  140 -
                                  16,
                              child: Text(product['description'],
                                  maxLines: 8,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic)),
                            ),
                            Container(
                              height: 140,
                              width: 140,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(product['details'],
                            maxLines: 8,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic)),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: 20,
                    right: 10,
                    child: Container(
                      height: 200,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )),
                Positioned(
                    top: 20 + top,
                    right: 10,
                    child: Container(
                      height: 40,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )),
                if (Provider.of<UserCart>(context).modifyingCart)
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
              ],
            ),
    );
  }
}
