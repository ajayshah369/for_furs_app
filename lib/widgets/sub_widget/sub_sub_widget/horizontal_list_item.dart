import 'package:flutter/material.dart';

class HorizontalListItem extends StatefulWidget {
  const HorizontalListItem(
      this.width, this.item, this.index, this.func1, this.func2,
      {Key? key})
      : super(key: key);

  final double width;
  final Map<String, dynamic> item;
  final int index;
  final Function func1;
  final Function func2;

  @override
  State<HorizontalListItem> createState() => _HorizontalListItemState();
}

class _HorizontalListItemState extends State<HorizontalListItem> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.func1(context, widget.item['_id']);
      },
      child: Container(
        width: widget.width,
        margin: EdgeInsets.only(right: 16, left: widget.index == 0 ? 16 : 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Container(
              height: widget.width,
              margin: const EdgeInsets.only(bottom: 6),
              child: Image.network(
                widget.item['image'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.item['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // RichText(
                      //     text: TextSpan(
                      //         text: 'Rs. ',
                      //         style: const TextStyle(
                      //             fontSize: 12, color: Colors.black),
                      //         children: [
                      //       TextSpan(
                      //         text: item['price'],
                      //         style: const TextStyle(
                      //             fontSize: 12,
                      //             color: Colors.black,
                      //             decoration: TextDecoration.lineThrough),
                      //       )
                      //     ])),
                      Text('₹ ${widget.item['price']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          )),
                      // Text(
                      //   '(${item['discount']} % off)',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Theme.of(context).colorScheme.secondary,
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary)),
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                        });
                        await widget.func2(context, widget.item['_id']);
                        setState(() {
                          loading = false;
                        });
                      },
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.black),
                      ))
          ],
        ),
      ),
    );
  }
}
