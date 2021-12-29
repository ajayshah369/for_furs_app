import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './utilities/dio_instance.dart';
import './utilities/custom_color.dart';

import './screens/auth/register_or_login.dart';
import './screens/auth/verify_phone.dart';
import './screens/auth/set_password.dart';
import './screens/auth/verify_password.dart';
import './screens/auth/verify_login_otp.dart';
import './screens/auth/verify_password_reset_otp.dart';

import './screens/loading_screen.dart';
import './screens/tabs.dart';

import './providers/user.dart';
import './providers/product.dart';
import './providers/user_cart.dart';
import './providers/service.dart';
import './providers/user_orders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51K124DSGRtTblIP3yipg3syPIVndjpn9wKInmaOIOSaknPhehcROjL91dwNLlNB7IpnBel1fl4ovrrTeJr2ER3cF00cW6L57TT';
  Stripe.merchantIdentifier = 'acct_1K124DSGRtTblIP3';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setDioInterceptors();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      fontFamily: 'Open Sans',
      primarySwatch: generateMaterialColor(const Color(0xFF000000)),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontStyle: FontStyle.italic),
        headline2: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: Colors.white,
        ),
        headline3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.white,
        ),
      ),
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<User>(create: (c) {
            return User();
          }),
          ChangeNotifierProvider<Product>(create: (c) {
            return Product();
          }),
          ChangeNotifierProvider<UserCart>(create: (c) {
            return UserCart();
          }),
          ChangeNotifierProvider<Service>(create: (c) {
            return Service();
          }),
          ChangeNotifierProvider<UserOrders>(create: (c) {
            return UserOrders();
          })
        ],
        child: MaterialApp(
          title: 'For Furs',
          debugShowCheckedModeBanner: false,
          theme: themeData.copyWith(
              colorScheme: themeData.colorScheme
                  .copyWith(secondary: const Color(0XFFFFDE59))),
          routes: {
            '/': (ctx) => const Loading(),
            '/registerOrLogin': (ctx) => const RegisterOrLogin(),
            '/verifyPhone': (ctx) => const VerifyPhone(),
            '/setPassword': (ctx) => const SetPassword(),
            '/verifyPassword': (ctx) => const VerifyPassword(),
            '/verifyLoginOtp': (ctx) => const VerifyLoginOtp(),
            '/verifyPasswordResetOtp': (ctx) => const VerifyPasswordResetOtp(),
            '/tabs': (ctx) => const Tabs(),
          },
        ));
  }
}
