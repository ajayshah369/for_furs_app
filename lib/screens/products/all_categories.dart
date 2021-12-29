import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product.dart';
import './category.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  int page = 1;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    if (Provider.of<Product>(context, listen: false).allCategories.isEmpty) {
      Provider.of<Product>(context, listen: false)
          .fetchAllCategories(context, page);
    }

    controller.addListener(() {
      if (Provider.of<Product>(context, listen: false).allCategories.length <
              Provider.of<Product>(context, listen: false).totalCategories &&
          (controller.position.pixels == controller.position.maxScrollExtent)) {
        page++;
        Provider.of<Product>(context, listen: false)
            .fetchAllCategories(context, page);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = Provider.of<Product>(context).allCategories;
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Categories'),
          titleTextStyle: Theme.of(context).textTheme.headline2,
        ),
        body: allCategories.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Category(allCategories[index])));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0,
                        ),
                      )),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Row(children: [
                                SizedBox(
                                  width: 75,
                                  height: 75,
                                  child: Image.network(
                                      allCategories[index]['image']),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allCategories[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        allCategories[index]['description'],
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 32,
                            )
                          ]),
                    ),
                  );
                },
                itemCount: allCategories.length,
              ));
  }
}
