import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_or_edit_address.dart';
import '../../providers/user.dart';
import '../../providers/user_cart.dart';

import '../../widgets/shimmer.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({Key? key, this.selectAddress = false, this.cart = false})
      : super(key: key);

  final bool selectAddress;
  final bool cart;

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  void initState() {
    if (Provider.of<User>(context, listen: false).initAddress) {
      Provider.of<User>(context, listen: false).getAddresses(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(widget.selectAddress ? 'Select Address' : 'Manage Address'),
      titleTextStyle: Theme.of(context).textTheme.headline3,
    );

    final address = Provider.of<User>(context).addresses;

    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
          child: Provider.of<User>(context).initAddress
              ? ShimmerWidget(Column(children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ]))
              : address.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: ListView(children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AddOrEditAddress()));
                          },
                          child: Container(
                            color: Colors.grey,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Add New Address',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Icon(Octicons.chevron_right, size: 40),
                              ],
                            ),
                          ),
                        ),
                      ]))
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      height: MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: ListView.builder(
                        itemCount: address.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: InkWell(
                              onTap: widget.selectAddress
                                  ? () {
                                      Provider.of<UserCart>(context,
                                              listen: false)
                                          .selectAddress(
                                              context, address[index],
                                              cart: widget.cart);
                                    }
                                  : null,
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  height: 140,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      border: const Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 4))),
                                  child: Row(children: [
                                    const SizedBox(width: 16),
                                    const Icon(FontAwesome5.map_marked_alt,
                                        size: 52),
                                    const SizedBox(width: 24),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address[index]['fullName'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          address[index]['mobileNumber'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          address[index]["tc"],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          address[index]["spr"],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          address[index]["pinCode"],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Stack(children: [
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddOrEditAddress(
                                                          address:
                                                              address[index],
                                                        )));
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/edit.svg',
                                              height: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 35,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<User>(context,
                                                    listen: false)
                                                .deleteAddress(context, index);
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/delete.svg',
                                              height: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))
                                  ])),
                            ),
                          );
                        },
                      )),
          onRefresh: () async {
            await Provider.of<User>(context, listen: false)
                .getAddresses(context);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddOrEditAddress()));
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
