import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_fleet/screens/route/route.dart';
import 'package:go_fleet/screens/utilis/asset_images.dart';
import 'package:go_fleet/screens/utilis/button.dart';
import 'package:go_fleet/screens/utilis/colors.dart';
import 'package:go_fleet/screens/utilis/config/app_startup.dart';
import 'package:go_fleet/screens/utilis/navigation/navigation_service.dart';
import 'package:go_fleet/screens/utilis/string.dart';

import 'auth/route/routes.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AssetResources.FIRST_PAGE_IMAGE,
            ),
            fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              AssetResources.GO_LOGO,
            ),
            SizedBox(height: 23.h),
            Text(
              StringResources.FLEET_MANAGER,
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 132.h,
            ),
            AppButton(
              onPressed: () {
                getIt<NavigationService>().to(routeName: AuthRoutes.signUp);
              },
              radius: 56.r,
              text: StringResources.BECOME_A_FLEET_MANAGER,
              color: AppColors.primaryColor,
            ),
            SizedBox(
              height: 23.h,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  getIt<NavigationService>().to(routeName: RootRoutes.signIn);
                },
                child: Text(
                  StringResources.SIGN_IN,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
