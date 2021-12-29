import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:provider/provider.dart';

import '../../widgets/shimmer.dart';
import '../../providers/user.dart';

import './profile.dart';
import './manage_adress.dart';
import './manage_pets.dart';
import '../../screens/orders/orders.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void manageAddress(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManageAddress(),
      ),
    );
  }

  void managePets(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManagePets(),
      ),
    );
  }

  void orders(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Orders(),
      ),
    );
  }

  void fn(BuildContext context) {}

  @override
  void initState() {
    if (Provider.of<User>(context, listen: false).me.isEmpty) {
      Provider.of<User>(context, listen: false).getMe(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    Map<String, dynamic> user = userProvider.me;

    final List<Map<String, dynamic>> list = [
      {
        'icon': Entypo.bag,
        'title': 'Orders',
        'fn': orders,
      },
      {
        'icon': Entypo.newspaper,
        'title': 'Prescription',
        'fn': fn,
      },
      {
        'icon': Icons.bookmark_border_outlined,
        'title': 'Saved for later',
        'fn': fn,
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'ForFurs Wallet',
        'fn': fn,
      },
      {
        'icon': Entypo.book_open,
        'title': 'Pet Details',
        'fn': managePets,
      },
      {
        'icon': LineariconsFree.map,
        'title': 'Manage Address',
        'fn': manageAddress
      },
      {
        'icon': FontAwesome5.headset,
        'title': 'Customer Service',
        'fn': fn,
      }
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          // padding: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
                radius: user.containsKey('image') ? 24 : 25,
                backgroundImage: user.containsKey('image')
                    ? NetworkImage(user['image'])
                    : Image.asset('assets/user.png').image),
          ),
        ),
        title: user.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.containsKey('name'))
                    Text(
                      user['name'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
                    ),
                  if (user.containsKey('name')) const SizedBox(height: 5),
                  Text(
                    user['phone'],
                    style: TextStyle(
                        fontSize: user.containsKey('name') ? 12 : 16,
                        fontWeight: user.containsKey('name')
                            ? FontWeight.w400
                            : FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  )
                ],
              )
            : ShimmerWidget(Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ))),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<User>(context, listen: false).getMe(context);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.builder(
              itemCount: list.length + 1,
              itemBuilder: (context, index) {
                return index != list.length
                    ? Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.only(
                            bottom: 16, top: index == 0 ? 16 : 0),
                        padding: const EdgeInsets.only(left: 16, right: 10),
                        height: 60,
                        child: InkWell(
                          onTap: () {
                            list[index]['fn'](context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                  child: Row(
                                children: [
                                  Icon(list[index]['icon'],
                                      color: Colors.black54),
                                  const SizedBox(width: 20),
                                  Text(list[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87)),
                                ],
                              )),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 36) /
                                        2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFC4C4C4)),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Entypo.doc_text,
                                        color: Colors.black54),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Legal',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87))
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () =>
                                Provider.of<User>(context, listen: false)
                                    .logout(context),
                            child: Container(
                                alignment: Alignment.center,
                                width:
                                    (MediaQuery.of(context).size.width - 36) /
                                        2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFC4C4C4)),
                                height: 60,
                                child: userProvider.logoutLoading
                                    ? const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Icon(Entypo.logout,
                                              color: Colors.black54),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Logout',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87))
                                        ],
                                      )),
                          ),
                        ],
                      );
              }),
        ),
      ),
    );
  }
}
