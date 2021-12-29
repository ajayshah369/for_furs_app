import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../../providers/user.dart';
import '../../utilities/dio_instance.dart';

import '../../widgets/logo.dart';
import '../../widgets/next_button.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({Key? key}) : super(key: key);

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  bool loading = false;
  String error = '';
  String success = '';

  bool loading2 = false;
  String error2 = '';
  String success2 = '';

  final double width = 220;
  int seconds = 60;
  String otp = '';

  // ignore: prefer_typing_uninitialized_variables
  var t;
  // ignore: prefer_typing_uninitialized_variables
  var s;

  @override
  void initState() {
    t = Timer(const Duration(minutes: 9), () {
      Navigator.of(context).pop();
    });

    s = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    s.cancel();
    super.dispose();
  }

  void onSubmit(BuildContext ctx) async {
    if (otp.length != 6) {
      return;
    }
    setState(() {
      loading = true;
      error = '';
    });
    try {
      var response = await dio.post('user/verifyPhone', data: {'otp': otp});
      setState(() {
        success = 'Success ✔';
      });
      await Future.delayed(const Duration(seconds: 1), () {
        Provider.of<User>(ctx, listen: false)
            .isLoggedIn(jsonDecode(response.toString())['id']);
        Navigator.of(ctx)
            .pushNamedAndRemoveUntil('/setPassword', (route) => false);
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

  void resendOtp(BuildContext ctx) async {
    setState(() {
      loading2 = true;
    });
    try {
      await dio.get('/user/resendPhoneOtp');
      setState(() {
        success2 = 'Otp resent successfully ✔';
      });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          success2 = '';
        });
      });
    } on DioError catch (e) {
      setState(() {
        error2 = jsonDecode(e.response.toString())['message'];
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          error2 = '';
        });
      });
    }
    setState(() {
      loading2 = false;
      seconds = 60;
    });
    t.cancel();
    t = Timer(const Duration(minutes: 9), () {
      Navigator.of(context).pop();
    });

    s = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify phone'),
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
                'Enter otp sent to you phone number',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width,
              child: TextFormField(
                smartDashesType: SmartDashesType.enabled,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                maxLength: 6,
                initialValue: otp,
                onChanged: (v) {
                  otp = v;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Enter otp',
                    counterText: '',
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 2)),
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
            SizedBox(
              width: width,
              child: TextButton(
                  onPressed: seconds == 0 && !loading2
                      ? () => resendOtp(context)
                      : null,
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.blue.shade700;
                    }),
                  ),
                  child: loading2
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade700,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Resend Otp'),
                            if (seconds != 0)
                              Text(' in $seconds s',
                                  style: const TextStyle(color: Colors.black)),
                          ],
                        )),
            ),
            const SizedBox(
              height: 10,
            ),
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
