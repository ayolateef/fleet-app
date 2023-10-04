import 'package:flutter/material.dart';

import '../../first_page.dart';
import '../../login.dart';
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
  }
  return null;
};
