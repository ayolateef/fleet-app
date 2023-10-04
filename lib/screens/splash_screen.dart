import 'package:flutter/material.dart';
import 'package:go_fleet/screens/route/route.dart';
import 'package:go_fleet/screens/utilis/config/app_configs.dart';
import 'package:go_fleet/screens/utilis/asset_images.dart';
import 'package:go_fleet/screens/utilis/colors.dart';
import 'package:go_fleet/screens/utilis/config/app_startup.dart';
import 'package:go_fleet/screens/utilis/navigation/navigation_service.dart';
import 'package:go_fleet/screens/utilis/storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool isFirstTime;

  @override
  void initState() {
    isUserFirstTime().then((value) {
      isFirstTime = value;
      setState(() {});
    });

    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        getIt<NavigationService>().to(routeName: RootRoutes.firstPage);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> isUserFirstTime() async {
    var firstTime = await LocalStorageUtils.read(AppConstants.isUserFirstTime);
    return firstTime == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(child: Image.asset(AssetResources.SPLASH_IMAGE)),
          ],
        ),
      ),
    );
  }
}
