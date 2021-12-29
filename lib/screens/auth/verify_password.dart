import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../utilities/dio_instance.dart';

import '../../widgets/logo.dart';
import '../../widgets/next_button.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({Key? key}) : super(key: key);

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  bool loading = false;
  String error = '';
  String password = '';
  String success = '';

  bool loading2 = false;
  String error2 = '';
  String password2 = '';
  String success2 = '';

  final double width = 220;

  // ignore: prefer_typing_uninitialized_variables
  var t;

  @override
  void initState() {
    t = Timer(const Duration(minutes: 9), () {
      Navigator.of(context).pop();
    });

    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  void onSubmit(BuildContext ctx) async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      var response =
          await dio.post('user/verifyPassword', data: {'password': password});
      setState(() {
        success = 'Password verified successfully ✔';
      });
      await Future.delayed(const Duration(seconds: 1), () {
        Provider.of<User>(ctx, listen: false)
            .isLoggedIn(jsonDecode(response.toString())['id']);
        Navigator.of(ctx).pushNamedAndRemoveUntil('/tabs', (route) => false);
      });
    } on DioError catch (e) {
      setState(() {
        error = jsonDecode(e.response.toString())['message'];
      });
    }
    setState(() {
      loading = false;
    });
  }

  void forgotPasswordLoginViaOtp(BuildContext ctx) async {
    setState(() {
      loading2 = true;
      error2 = '';
    });
    try {
      await dio.get('user/forgotPasswordLoginViaOtp');
      setState(() {
        success2 = 'Login otp sent successfully ✔';
      });
      await Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(ctx).pushNamed('/verifyLoginOtp');
      });
    } on DioError catch (e) {
      setState(() {
        error2 = jsonDecode(e.response.toString())['message'];
      });
    }
    setState(() {
      loading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Password'),
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
                onPressed:
                    loading2 ? null : () => forgotPasswordLoginViaOtp(context),
                child: loading2
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade700,
                        ))
                    : Text(
                        'Forgot password login via otp',
                        style: TextStyle(color: Colors.blue.shade700),
                      )),
            const SizedBox(height: 10),
            error2.isNotEmpty
                ? SizedBox(
                    width: width,
                    child: Text(
                      error2,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : success2.isNotEmpty
                    ? SizedBox(
                        width: width,
                        child: Text(
                          success2,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.green),
                        ))
                    : SizedBox(
                        width: width,
                        child: const Text(
                          '',
                          textAlign: TextAlign.start,
                        )),
          ],
        ),
      ),
    );
  }
}
