import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../utilities/dio_instance.dart';

import '../../widgets/logo.dart';
import '../../widgets/next_button.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({this.cancel = false, Key? key}) : super(key: key);

  final bool cancel;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool loading = false;
  String error = '';
  String success = '';

  final double width = 200;
  String password = '';

  // ignore: prefer_typing_uninitialized_variables
  var t;

  @override
  void initState() {
    t = Timer(const Duration(minutes: 9), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/tabs', (route) => false);
    });
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  void onSubmit(BuildContext ctx) async {
    if (password.length < 6) {
      setState(() {
        error = 'Password must be at least 6 characters';
      });
      return;
    }
    setState(() {
      loading = true;
      error = '';
    });
    try {
      await dio.post('user/setPassword', data: {'password': password});
      setState(() {
        success = 'Password set successfully ✔';
      });
      await Future.delayed(const Duration(seconds: 1), () {
        if (widget.cancel) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(ctx).pushNamedAndRemoveUntil('/tabs', (route) => false);
        }
      });
    } on DioError catch (e) {
      setState(() {
        error = jsonDecode(e.response.toString())['message'];
      });
    }
    setState(() {
      loading = false;
      success = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Password'),
        centerTitle: true,
        actions: const [Logo()],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: const Text(
                'Enter Password',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2))),
              child: TextFormField(
                style: const TextStyle(fontSize: 16),
                initialValue: password,
                onChanged: (v) {
                  password = v;
                },
                decoration: const InputDecoration(
                    hintText: 'Password',
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            error.isNotEmpty
                ? SizedBox(
                    width: width,
                    child: Text(
                      error,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : success.isNotEmpty
                    ? SizedBox(
                        width: width,
                        child: Text(
                          success,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.green),
                        ))
                    : SizedBox(
                        width: width,
                        child: const Text(
                          '',
                          textAlign: TextAlign.start,
                        )),
            const SizedBox(height: 10),
            NextButton(
              loading,
              onSubmit,
              width: width,
            ),
            TextButton(
                onPressed: () {
                  if (widget.cancel) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/tabs', (route) => false);
                  }
                },
                child: Text(
                  widget.cancel ? 'Cancel' : 'Skip',
                  style: TextStyle(color: Colors.blue.shade700),
                ))
          ],
        ),
      ),
    );
  }
}
