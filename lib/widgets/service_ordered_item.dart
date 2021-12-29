import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceOrderedItem extends StatelessWidget {
  const ServiceOrderedItem(this.item, {Key? key}) : super(key: key);

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    var dateTimeArray = item['dateTime'].toString().split('T')[0].split('-');
    final DateTime dateTime = DateTime(int.parse(dateTimeArray[0]),
        int.parse(dateTimeArray[1]), int.parse(dateTimeArray[2]));
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
                Text(item['name'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text('₹ ${item['price'].toString()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text(
                  item.containsKey('dateTime')
                      ? DateFormat('dd MMM yyyy').format(dateTime)
                      : 'Select Date',
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'qty:  ${item['quantity'].toString()}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                Text(
                    'Total: ₹ ${(item['price'] * item['quantity']).toString()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
                Text(item['orderStatus'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.green)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
