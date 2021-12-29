import 'package:flutter/material.dart';

class Retry extends StatefulWidget {
  const Retry(
      {required this.tryAgain, this.error = 'No internet connection', Key? key})
      : super(key: key);
  final Function tryAgain;
  final String error;

  @override
  State<Retry> createState() => _RetryState();
}

class _RetryState extends State<Retry> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.warning_rounded, size: 50, color: Colors.red),
          const SizedBox(
            height: 10,
          ),
          Text(widget.error,
              style: const TextStyle(
                color: Colors.red,
              )),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => widget.tryAgain(),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(200, 40)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero)),
              ),
              child: const Text(
                'Try again!',
                style: TextStyle(
                  fontSize: 16,
                ),
              ))
        ],
      ),
    );
  }
}
