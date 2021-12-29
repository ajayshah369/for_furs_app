import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/service.dart';
import '../../widgets/search.dart';
// import '../../widgets/logo.dart';
import '../../widgets/notification.dart';
import '../../widgets/cart.dart';
import '../../widgets/service_item.dart';

class KeywordServices extends StatefulWidget {
  const KeywordServices({Key? key}) : super(key: key);

  @override
  _KeywordServicesState createState() => _KeywordServicesState();
}

class _KeywordServicesState extends State<KeywordServices> {
  void filter(BuildContext ctx) {
    Future<void> future = showModalBottomSheet<void>(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        context: ctx,
        builder: (ctx) {
          List<dynamic> priceRange = Provider.of<Service>(ctx).priceRange;
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
                        Provider.of<Service>(context, listen: false)
                            .setPriceRange([values.start, values.end], ctx);
                      },
                      labels:
                          RangeLabels('${priceRange[0]}', '${priceRange[1]}'),
                      divisions: 10,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ));
        });

    future.then((_) {
      Provider.of<Service>(context, listen: false).fetchServices(context);
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
    var s = Provider.of<Service>(context);
    int page = s.page;
    int lastPage = (s.totalServices / 10).ceil();
    int tf = s.priceRange[0] != 0.0 || s.priceRange[1] != 50000.0 ? 1 : 0;
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
                initialValue: s.keyword,
                height: bh,
                onSubmit: (v) async {
                  Provider.of<Service>(context, listen: false)
                      .setKeyword(v, context);
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
            child: ServiceItem(
              s.services,
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
                            await Provider.of<Service>(context, listen: false)
                                .setPage(context, page - 1, scrollToIndex);
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
                                    Provider.of<Service>(context, listen: false)
                                        .setPage(
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
                            Provider.of<Service>(context, listen: false)
                                .setPage(context, page + 1, scrollToIndex);
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
          if (Provider.of<Service>(context).loading)
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
