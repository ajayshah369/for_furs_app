import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../utilities/dio_instance.dart';

import '../widgets/logo.dart';
import '../widgets/retry.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool noInternet = false;

  void _isLoggedIn(BuildContext ctx) async {
    setState(() {
      noInternet = false;
    });
    try {
      var response = await dio.get('user/isLoggedIn');
      Provider.of<User>(ctx, listen: false)
          .isLoggedIn(jsonDecode(response.toString())['id']);
      Navigator.of(ctx).pushReplacementNamed('/tabs');
    } on DioError catch (e) {
      if (e.response == null) {
        setState(() {
          noInternet = true;
        });
        return;
      }
      Navigator.of(ctx).pushReplacementNamed('/registerOrLogin');
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () async {
      _isLoggedIn(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [Logo()],
        ),
        body: noInternet
            ? Retry(
                tryAgain: () => _isLoggedIn(context),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
