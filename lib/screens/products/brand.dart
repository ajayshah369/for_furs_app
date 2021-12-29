import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/search.dart';
import '../../widgets/notification.dart';
import '../../widgets/cart.dart';

import '../../providers/product.dart';
import '../../widgets/product_item.dart';

class Brand extends StatefulWidget {
  const Brand(this.brand, {Key? key}) : super(key: key);

  final Map<String, dynamic> brand;

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  bool loading = true;

  String keyword = '';

  void setKeyword(String value) {
    keyword = value;
  }

  void filter(BuildContext ctx) {
    if (Provider.of<Product>(ctx, listen: false).brandCategories.isEmpty) {
      Provider.of<Product>(ctx, listen: false).fetchBrandCategories(ctx);
    }
    Future<void> future = showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        context: ctx,
        builder: (ctx) {
          Map<String, dynamic> brandFilter =
              Provider.of<Product>(ctx).brandFilter;
          List<dynamic> categories = brandFilter['categories'];
          List<dynamic> priceRange = brandFilter['priceRange'];
          List<dynamic> allCategories =
              Provider.of<Product>(ctx).brandCategories;

          return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Range',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    RangeSlider(
                      values: RangeValues(priceRange[0], priceRange[1]),
                      min: 0,
                      max: 50000,
                      onChanged: (values) {
                        Provider.of<Product>(context, listen: false)
                            .setBrandPriceRange(values);
                      },
                      labels:
                          RangeLabels('${priceRange[0]}', '${priceRange[1]}'),
                      divisions: 10,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select Categories',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    allCategories.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 120,
                                    childAspectRatio: 10 / 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: allCategories.length,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<Product>(context, listen: false)
                                      .setBrandCategories(
                                          allCategories[index]['_id']);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: categories.contains(
                                            allCategories[index]['_id'])
                                        ? Colors.indigo.shade900
                                        : Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    allCategories[index]['name'],
                                    style: TextStyle(
                                        color: categories.contains(
                                                allCategories[index]['_id'])
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              );
                            },
                          )
                  ],
                ),
              ));
        });

    future.then((_) {
      Provider.of<Product>(ctx, listen: false)
          .fetchBrandProducts(ctx, widget.brand['_id']);
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () async {
      await Provider.of<Product>(context, listen: false).fetchBrandProducts(
        context,
        widget.brand['_id'],
      );

      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double bh = 50;
    final brand = widget.brand;
    final total = Provider.of<Product>(context).brandProductsTotal;
    final page = Provider.of<Product>(context).brandPage;
    final lastPage = (total / 10).ceil();
    var brandFilter = Provider.of<Product>(context).brandFilter;
    int tf = brandFilter['priceRange'][0] != 0.0 ||
            brandFilter['priceRange'][1] != 50000.0
        ? 1
        : 0;
    tf += brandFilter['categories'].length as int;
    return Scaffold(
        appBar: AppBar(
          title: Text(brand['name']),
          titleTextStyle: Theme.of(context).textTheme.headline3,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bh + 30),
            child: Column(
              children: [
                Search(
                  hintText: 'Search in ${brand['name']}',
                  onSubmit: (keyword) async {
                    await Provider.of<Product>(context, listen: false)
                        .setBrandKeywords(
                      keyword,
                    );
                    Provider.of<Product>(context, listen: false)
                        .fetchBrandProducts(
                      context,
                      widget.brand['_id'],
                    );
                  },
                  height: bh,
                ),
                Container(
                    height: 30,
                    color: Colors.amber.shade50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => filter(
                            context,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              'Filter ${tf != 0 ? '(' + tf.toString() + ')' : ''}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          actions: const [
            NotificationWidget(),
            Cart(),
          ],
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: ProductItem(
                      Provider.of<Product>(context).brandProducts,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: page == 1
                                ? null
                                : () {
                                    Provider.of<Product>(context, listen: false)
                                        .setBrandPage(context, page - 1);
                                  },
                            child: Card(
                              color: page == 1
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              child: Icon(
                                Icons.chevron_left,
                                color: page == 1 ? Colors.black : Colors.red,
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: lastPage,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: page == index + 1
                                        ? null
                                        : () {
                                            Provider.of<Product>(context,
                                                    listen: false)
                                                .setBrandPage(
                                                    context, index + 1);
                                          },
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                          alignment: Alignment.center,
                                          color: page == index + 1
                                              ? Colors.grey.shade300
                                              : Colors.white,
                                          width: 25,
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                                color: page == index + 1
                                                    ? Colors.black
                                                    : Colors.red,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  );
                                }),
                          ),
                          InkWell(
                            onTap: page == lastPage || lastPage == 0
                                ? null
                                : () {
                                    Provider.of<Product>(context, listen: false)
                                        .setBrandPage(context, page + 1);
                                  },
                            child: Card(
                              color: page == lastPage || lastPage == 0
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              child: Icon(
                                Icons.chevron_right,
                                color: page == lastPage || lastPage == 0
                                    ? Colors.black
                                    : Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (Provider.of<Product>(context).brandProductsLoading)
                    Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.white70,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          ),
                        ))
                ],
              ));
  }
}
