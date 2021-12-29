import 'package:flutter/material.dart';

import './product_orders.dart';
import './service_orders.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool products = false;
  @override
  Widget build(BuildContext context) {
    const double sp = 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        titleTextStyle: Theme.of(context).textTheme.headline2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    products = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: !products ? Colors.amber.shade50 : Colors.white,
                  height: 30,
                  width: (MediaQuery.of(context).size.width / 2) - (sp / 2),
                  child: const Text('Services',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    products = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: products ? Colors.amber.shade50 : Colors.white,
                  height: 30,
                  width: (MediaQuery.of(context).size.width / 2) - (sp / 2),
                  child: const Text('Products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              )
            ],
          ),
        ),
      ),
      body: products ? const ProductOrders() : const ServiceOrders(),
    );
  }
}
