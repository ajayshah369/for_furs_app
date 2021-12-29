import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton(this.loading, this.onSubmit,
      {Key? key, this.width = 220, this.height = 40})
      : super(key: key);

  final bool loading;
  final Function onSubmit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: loading ? null : () => onSubmit(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).primaryColor;
            }
            return Theme.of(context).primaryColor;
          }),
          fixedSize: MaterialStateProperty.all(
              Size(width as double, height as double)),
        ),
        child: loading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Next',
                style: TextStyle(fontSize: 16),
              ));
  }
}
