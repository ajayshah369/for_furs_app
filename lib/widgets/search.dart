import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search(
      {Key? key,
      required this.height,
      required this.onSubmit,
      this.initialValue = '',
      this.hintText = 'Search in For Furs'})
      : super(key: key);

  final double height;
  final String initialValue;
  final String hintText;
  final Function onSubmit;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String value = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            width: 260,
            child: TextFormField(
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
                initialValue: widget.initialValue,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(6),
                  hintText: widget.hintText,
                )),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            child: ElevatedButton(
                onPressed: () {
                  widget.onSubmit(value);
                  FocusScope.of(context).unfocus();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8))))),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16),
                )),
          )
        ],
      ),
    );
  }
}
