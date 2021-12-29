import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_cart.dart';

import '../../widgets/notification.dart';
import '../../widgets/product_cart_item.dart';
import '../../widgets/service_cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () async {
      await Provider.of<UserCart>(context, listen: false).getCart(context);
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userCart = Provider.of<UserCart>(context);
    int cartQuantity = userCart.cartQuantity;
    double cartAmount = userCart.cartAmount;
    List<dynamic> productCartItems = userCart.productCartItems;
    List<dynamic> serviceCartItems = userCart.serviceCartItems;

    List<Widget> cartList = [
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
                    text: ' ₹ $cartAmount',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ))
              ])))
    ];

    List<Widget> pcl = [];
    if (productCartItems.isNotEmpty) {
      pcl.add(Container(
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

      for (var cartItem in productCartItems) {
        pcl.add(ProductCartItem(cartItem));
      }
    }

    List<Widget> scl = [];
    if (serviceCartItems.isNotEmpty) {
      scl.add(Container(
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

      for (var cartItem in serviceCartItems) {
        scl.add(ServiceCartItem(cartItem));
      }
    }

    cartList.addAll(pcl);
    cartList.addAll(scl);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        titleTextStyle: Theme.of(context).textTheme.headline3,
        actions: const [NotificationWidget()],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
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
                          child: Column(children: cartList),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: cartQuantity == 0
                              ? null
                              : () {
                                  for (var service in serviceCartItems) {
                                    if (!service.containsKey('dateTime')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Plesae select Date for your services')));
                                      return;
                                    }
                                  }
                                  Provider.of<UserCart>(context, listen: false)
                                      .checkout(context, cart: true);
                                },
                          child: Text(
                              cartQuantity == 0
                                  ? 'Your cart is empty'
                                  : 'Checkout ($cartQuantity Items)',
                              style: const TextStyle(
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
                  if (userCart.modifyingCart)
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.white60,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          )),
                        ))
                ],
              ),
            ),
    );
  }
}
