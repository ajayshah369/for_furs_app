import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../providers/user_cart.dart';

class ServiceCartItem extends StatelessWidget {
  const ServiceCartItem(this.item, {Key? key}) : super(key: key);

  final Map<String, dynamic> item;

  void pickDate(BuildContext ctx) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        context: ctx,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: DateTime.now().add(const Duration(days: 1)),
              maxDate: DateTime.now().add(const Duration(days: 7)),
              showActionButtons: true,
              onCancel: () {
                Navigator.of(context).pop();
              },
              onSubmit: (Object? value) {
                Provider.of<UserCart>(context, listen: false)
                    .setDateTimeForService(ctx, item['_id'], value as Object);
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                item['service']['image'],
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['service']['name'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text('₹ ${item['service']['price'].toString()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                TextButton(
                    onPressed: () {
                      pickDate(context);
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(
                      item.containsKey('dateTime')
                          ? DateFormat('dd MMM yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  item['dateTime']))
                          : 'Select Date',
                      style: const TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade400,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<UserCart>(context, listen: false)
                              .removeFromServiceCart(
                                  context, item['service']['_id'],
                                  onCartScreen: true);
                        },
                        child: const Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                      ),
                      Text(item['quantity'].toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic)),
                      InkWell(
                        onTap: () {
                          Provider.of<UserCart>(context, listen: false)
                              .addToServiceCart(context, item['service']['_id'],
                                  onCartScreen: true);
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Provider.of<UserCart>(context, listen: false)
                        .removeAllFromServiceCart(
                            context, item['service']['_id']);
                  },
                  child: SvgPicture.asset(
                    'assets/delete.svg',
                    height: 20,
                    color: Colors.red,
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
