import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product.dart';
import './brand.dart';

class AllBrands extends StatefulWidget {
  const AllBrands({Key? key}) : super(key: key);

  @override
  _AllBrandsState createState() => _AllBrandsState();
}

class _AllBrandsState extends State<AllBrands> {
  int page = 1;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    if (Provider.of<Product>(context, listen: false).allBrands.isEmpty) {
      Provider.of<Product>(context, listen: false)
          .fetchAllBrands(context, page);
    }

    controller.addListener(() {
      if (Provider.of<Product>(context, listen: false).allBrands.length <
              Provider.of<Product>(context, listen: false).totalBrands &&
          (controller.position.pixels == controller.position.maxScrollExtent)) {
        page++;
        Provider.of<Product>(context, listen: false)
            .fetchAllBrands(context, page);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allBrands = Provider.of<Product>(context).allBrands;
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Brands'),
          titleTextStyle: Theme.of(context).textTheme.headline2,
        ),
        body: allBrands.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Brand(allBrands[index])));
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
                                  child:
                                      Image.network(allBrands[index]['image']),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allBrands[index]['name'],
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
                                        allBrands[index]['description'],
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
                itemCount: allBrands.length,
              ));
  }
}
