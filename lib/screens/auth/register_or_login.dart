import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../utilities/dio_instance.dart';

import '../../widgets/logo.dart';
import '../../widgets/next_button.dart';

class RegisterOrLogin extends StatefulWidget {
  const RegisterOrLogin({Key? key}) : super(key: key);

  @override
  State<RegisterOrLogin> createState() => _RegisterOrLoginState();
}

class _RegisterOrLoginState extends State<RegisterOrLogin> {
  bool loading = false;
  String error = '';
  String success = '';

  final double width = 220;
  String phone = '';

  void onSubmit(BuildContext ctx) async {
    if (!RegExp(r'^[1-9]{1}[0-9]{9}$').hasMatch(phone)) {
      setState(() {
        error = 'Invalid phone number';
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          error = '';
        });
      });
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      var response = await dio
          .post('user/registerOrLogin', data: {'phone': '+91 ' + phone});
      final message = jsonDecode(response.toString())['message'];
      setState(() {
        success = 'Success ✔';
      });
      await Future.delayed(const Duration(seconds: 1), () {});
      String redirect = '/';
      if (message == 'verify phone') {
        redirect = '/verifyPhone';
      } else if (message == 'enter password') {
        redirect = '/verifyPassword';
      } else if (message == 'enter otp') {
        redirect = '/verifyLoginOtp';
      }
      setState(() {
        success = '';
      });
      Navigator.of(ctx).pushNamed(redirect);
    } on DioError catch (e) {
      setState(() {
        error = jsonDecode(e.response.toString())['message'];
      });

      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          error = '';
        });
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register or Login'),
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
                'Enter your phone number (required)',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                  ),
                ),
              ),
              child: TextFormField(
                style: const TextStyle(fontSize: 20, letterSpacing: 1),
                maxLength: 10,
                initialValue: phone,
                onChanged: (v) {
                  phone = v;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    label: Text('Enter Phone'),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    prefixText: '+91 ',
                    counterText: '',
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
          ],
        ),
      ),
    );
  }
}
