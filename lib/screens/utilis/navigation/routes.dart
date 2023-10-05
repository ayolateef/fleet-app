import 'package:flutter/material.dart';
import 'package:go_fleet/screens/auth/route/routes.dart';
import 'package:go_fleet/screens/auth/signup/root.dart';
import 'package:go_fleet/screens/home/home.dart';

import '../../auth/sign_in/widget/otp_page.dart';
import '../../first_page.dart';
import '../../auth/sign_in/login.dart';
import '../../home/routes/routes.dart';
import '../../home/widget/vehicle_infomation.dart';
import '../../route/route.dart';
import '../../splash_screen.dart';
import '../caby_webview.dart';

// ignore: prefer_function_declarations_over_variables
var routes = (RouteSettings settings) {
  switch (settings.name) {
    case RootRoutes.initial:
      return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: const RouteSettings(name: RootRoutes.initial));

    case RootRoutes.firstPage:
      return MaterialPageRoute(
        builder: (context) => const FirstPage(),
      );

    case RootRoutes.webView:
      Map? args = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) => CabyWebView(
          title: args['title'],
          url: args['url'],
        ),
      );

    case RootRoutes.signIn:
      return MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );
    case AuthRoutes.otp:
      Map? args = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) => OtpPage(
          phoneNumber: args['phone'],
          linkFrom: args['type'],
          email: args['email'],
        ),
      );
    case AuthRoutes.signUp:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case RootRoutes.home:
      return MaterialPageRoute(
        builder: (context) => const Vehicle(),
      );
    case ProfileRoutes.vehicleInformation:
      Map? args = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) => VehicleInfo(
          plateNumber: args['plateNumber'],
        ),
      );
  }
  return null;
};
