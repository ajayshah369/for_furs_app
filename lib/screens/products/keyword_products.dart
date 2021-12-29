import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product.dart';
import '../../widgets/search.dart';
// import '../../widgets/logo.dart';
import '../../widgets/notification.dart';
import '../../widgets/cart.dart';
import '../../widgets/product_item.dart';

class KeywordProducts extends StatefulWidget {
  const KeywordProducts({Key? key}) : super(key: key);

  @override
  _KeywordProductsState createState() => _KeywordProductsState();
}

class _KeywordProductsState extends State<KeywordProducts> {
  void filter(BuildContext ctx) {
    if (Provider.of<Product>(ctx, listen: false).keywordCategories.isEmpty) {
      Provider.of<Product>(ctx, listen: false).fetchKeywordCategories(ctx);
    }
    if (Provider.of<Product>(ctx, listen: false).keywordBrands.isEmpty) {
      Provider.of<Product>(ctx, listen: false).fetchKeywordBrands(ctx);
    }
    Future<void> future = showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        context: ctx,
        builder: (ctx) {
          Map<String, dynamic> filter = Provider.of<Product>(ctx).keywordFilter;
          List<dynamic> priceRange = filter['priceRange'];
          List<dynamic> brands = filter['brands'];
          List<dynamic> categories = filter['categories'];
          List<dynamic> allBrands = Provider.of<Product>(ctx).keywordBrands;
          List<dynamic> allCategories =
              Provider.of<Product>(ctx).keywordCategories;

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
                            .setKeywordPriceRange(values);
                      },
                      labels:
                          RangeLabels('${priceRange[0]}', '${priceRange[1]}'),
                      divisions: 10,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select Brands',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    allBrands.isEmpty
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
                            itemCount: allBrands.length,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<Product>(context, listen: false)
                                      .setKeywordBrands(
                                          allBrands[index]['_id']);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        brands.contains(allBrands[index]['_id'])
                                            ? Colors.indigo.shade900
                                            : Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    allBrands[index]['name'],
                                    style: TextStyle(
                                        color: brands.contains(
                                                allBrands[index]['_id'])
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              );
                            },
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
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
                                      .setKeywordCategories(
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
      Provider.of<Product>(context, listen: false)
          .fetchKeywordProducts(context);
    });
  }

  final ScrollController scrollController = ScrollController();

  void scrollToIndex(int index) {
    scrollController.animateTo(
      index <= 3 ? 0 : index * 25,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var pp = Provider.of<Product>(context);
    int page = pp.keywordPage;
    int lastPage = (pp.keywordProductsTotal / 10).ceil();
    var keywordFilter = pp.keywordFilter;
    int tf = keywordFilter['priceRange'][0] != 0.0 ||
            keywordFilter['priceRange'][1] != 50000.0
        ? 1
        : 0;
    tf += keywordFilter['brands'].length as int;
    tf += keywordFilter['categories'].length as int;
    const double bh = 50;
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Search'),
        titleTextStyle: Theme.of(context).textTheme.headline2,
        // leading: const Logo(),
        actions: const [NotificationWidget(), Cart()],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(bh + 30),
            child: Column(children: [
              Search(
                initialValue: pp.keywordFilter['keyword'],
                height: bh,
                onSubmit: (v) async {
                  Provider.of<Product>(context, listen: false)
                      .setKeyword(context, v);
                },
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
            ])),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 40,
            left: 0,
            right: 0,
            child: ProductItem(
              pp.keywordProducts,
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
                        : () async {
                            await Provider.of<Product>(context, listen: false)
                                .setKeyWordPage(
                                    context, page - 1, scrollToIndex);
                          },
                    child: Card(
                      color: page == 1 ? Colors.grey.shade300 : Colors.white,
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
                        controller: scrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: lastPage,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: page == index + 1
                                ? null
                                : () {
                                    Provider.of<Product>(context, listen: false)
                                        .setKeyWordPage(
                                            context, index + 1, scrollToIndex);
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
                                .setKeyWordPage(
                                    context, page + 1, scrollToIndex);
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
          if (Provider.of<Product>(context).keywordProductsLoading)
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
      ),
    );
  }
}
