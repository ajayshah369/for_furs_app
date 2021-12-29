import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/search.dart';
import '../../widgets/notification.dart';
import '../../widgets/cart.dart';

import '../../providers/product.dart';
import '../../widgets/product_item.dart';

class Category extends StatefulWidget {
  const Category(this.category, {Key? key}) : super(key: key);

  final Map<String, dynamic> category;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool loading = true;

  String keyword = '';

  void setKeyword(String value) {
    keyword = value;
  }

  void filter(BuildContext ctx) {
    if (Provider.of<Product>(ctx, listen: false).categoryBrands.isEmpty) {
      Provider.of<Product>(ctx, listen: false).fetchCategoryBrands(ctx);
    }
    Future<void> future = showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        context: ctx,
        builder: (ctx) {
          Map<String, dynamic> categoryFilter =
              Provider.of<Product>(ctx).categoryFilter;
          List<dynamic> brands = categoryFilter['brand'];
          List<dynamic> priceRange = categoryFilter['priceRange'];
          List<dynamic> allBrands = Provider.of<Product>(ctx).categoryBrands;

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
                            .setCategoryPriceRange(values);
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
                                      .setcategoryBrands(
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
                          )
                  ],
                ),
              ));
        });

    future.then((_) {
      Provider.of<Product>(ctx, listen: false)
          .fetchCategoryProducts(ctx, widget.category['_id']);
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () async {
      await Provider.of<Product>(context, listen: false).fetchCategoryProducts(
        context,
        widget.category['_id'],
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
    final category = widget.category;
    final total = Provider.of<Product>(context).categoryProductsTotal;
    final page = Provider.of<Product>(context).categoryPage;
    final lastPage = (total / 10).ceil();

    var categoryFilter = Provider.of<Product>(context).categoryFilter;
    int tf = categoryFilter['priceRange'][0] != 0.0 ||
            categoryFilter['priceRange'][1] != 50000.0
        ? 1
        : 0;
    tf += categoryFilter['brand'].length as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(category['name']),
        titleTextStyle: Theme.of(context).textTheme.headline3,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(bh + 30),
          child: Column(
            children: [
              Search(
                hintText: 'Search in ${category['name']}',
                onSubmit: (keyword) async {
                  await Provider.of<Product>(context, listen: false)
                      .setcategoryKeywords(
                    keyword,
                  );
                  Provider.of<Product>(context, listen: false)
                      .fetchCategoryProducts(
                    context,
                    widget.category['_id'],
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
                    Provider.of<Product>(context).categoryProducts,
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
                                      .setCategoryPage(context, page - 1);
                                },
                          child: Card(
                            color:
                                page == 1 ? Colors.grey.shade300 : Colors.white,
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
                                              .setCategoryPage(
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
                                      .setCategoryPage(context, page + 1);
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
                if (Provider.of<Product>(context).categoryProductsLoading)
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
