import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_cart.dart';

import '../../widgets/product_order_item.dart';
import '../../widgets/service_order_item.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({Key? key, this.cart = false}) : super(key: key);

  final bool cart;

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> data = Provider.of<UserCart>(context).data;
    double totalProductsAmount = 0;
    double totalServicesAmount = 0;

    List<Widget> pol = [];
    if (data['products'].isNotEmpty) {
      pol.add(Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 8),
          child: const Text(
            'Products',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic),
          )));
    }

    for (var productOrderItem in data['products']) {
      totalProductsAmount +=
          (productOrderItem['price'] * productOrderItem['quantity']);
      pol.add(ProductOrderItem(productOrderItem));
    }

    List<Widget> sol = [];
    if (data['services'].isNotEmpty) {
      sol.add(Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 8),
          child: const Text(
            'Services',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic),
          )));
    }

    for (var serviceOrderItem in data['services']) {
      totalProductsAmount +=
          (serviceOrderItem['price'] * serviceOrderItem['quantity']);
      sol.add(ServiceOrderItem(serviceOrderItem));
    }

    List<Widget> orderItems = [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: RichText(
              // textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Total Amount : ',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                  children: [
                TextSpan(
                    text: ' ₹ ${totalProductsAmount + totalServicesAmount}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ))
              ])))
    ];

    orderItems.addAll(pol);
    orderItems.addAll(sol);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Order Summary'),
          titleTextStyle: Theme.of(context).textTheme.headline2),
      body: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 50,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(children: orderItems),
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: Provider.of<UserCart>(context).paying
                          ? null
                          : () {
                              Provider.of<UserCart>(context, listen: false)
                                  .makePayment(context, cart: cart);
                            },
                      child: Provider.of<UserCart>(context).paying
                          ? const CircularProgressIndicator()
                          : const Text('Place Order',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Theme.of(context).colorScheme.secondary;
                          }
                          return Theme.of(context).colorScheme.secondary;
                        }),
                        // fixedSize: MaterialStateProperty.all(
                        //     const Size(double.infinity, 48)),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))),
            ],
          )),
    );
  }
}
