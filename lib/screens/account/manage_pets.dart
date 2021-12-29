import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_or_edit_pet.dart';
import '../../providers/user.dart';

import '../../widgets/shimmer.dart';

class ManagePets extends StatefulWidget {
  const ManagePets({Key? key}) : super(key: key);

  @override
  _ManagePetsState createState() => _ManagePetsState();
}

class _ManagePetsState extends State<ManagePets> {
  @override
  void initState() {
    if (Provider.of<User>(context, listen: false).initPet) {
      Provider.of<User>(context, listen: false).getPets(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Your Pets'),
      titleTextStyle: Theme.of(context).textTheme.headline3,
    );

    final pets = Provider.of<User>(context).pets;

    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
          child: Provider.of<User>(context).initPet
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
              : pets.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: ListView(children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddOrEditPet()));
                          },
                          child: Container(
                            color: Colors.grey,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Add New Pet',
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
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                height: 140,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 4))),
                                child: Row(children: [
                                  const SizedBox(width: 16),
                                  Image.network(
                                    pets[index]['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 24),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pets[index]['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        pets[index]['age'].toString() +
                                            ' years old',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        pets[index]["breed"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
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
                                                      AddOrEditPet(
                                                        pet: pets[index],
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
                                              .removePet(context, index);
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
                          );
                        },
                      )),
          onRefresh: () async {
            await Provider.of<User>(context, listen: false)
                .getAddresses(context);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddOrEditPet()));
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
