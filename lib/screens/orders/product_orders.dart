import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_orders.dart';
import '../../widgets/product_ordered_item.dart';

class ProductOrders extends StatefulWidget {
  const ProductOrders({Key? key}) : super(key: key);

  @override
  _ProductOrdersState createState() => _ProductOrdersState();
}

class _ProductOrdersState extends State<ProductOrders> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      if (Provider.of<UserOrders>(context, listen: false)
          .productOrders
          .isEmpty) {
        await Provider.of<UserOrders>(context, listen: false)
            .getProductOrders(context);
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
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
    var pr = Provider.of<UserOrders>(context);
    int page = pr.productOrderPage;
    int lastPage = (pr.totalProductOrders / 10).ceil();
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 40,
            child: loading || pr.productOrdersLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: Provider.of<UserOrders>(context)
                          .productOrders
                          .map((e) => ProductOrderedItem(e))
                          .toList(),
                    ),
                  )),
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
                          await Provider.of<UserOrders>(context, listen: false)
                              .setProductOrdersPage(
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
                                  Provider.of<UserOrders>(context,
                                          listen: false)
                                      .setProductOrdersPage(
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
                          Provider.of<UserOrders>(context, listen: false)
                              .setProductOrdersPage(
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
      ],
    );
  }
}
