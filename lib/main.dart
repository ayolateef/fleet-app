import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_fleet/screens/splash_screen.dart';
import 'package:go_fleet/screens/utilis/config/app_startup.dart';
import 'package:go_fleet/screens/utilis/navigation/navigation_service.dart';
import 'package:go_fleet/screens/utilis/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await AppStartUp().setUp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(454, 982),
        builder: (BuildContext context, child) => MaterialApp(
              title: 'Go Fleet',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              navigatorKey: GetIt.I<NavigationService>().navigatorKey,
              home: const SplashScreen(),
              onGenerateRoute: routes,
            ));
  }
}
