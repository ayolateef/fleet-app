import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_fleet/screens/home/widget/vehicle_plate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/sign_in/model/user.dart';
import '../utilis/asset_images.dart';
import '../utilis/colors.dart';
import '../utilis/config/app_startup.dart';
import '../utilis/messenger.dart';
import '../utilis/navigation/navigation_service.dart';
import '../utilis/string.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'model/vehicle_model.dart';
import 'routes/routes.dart';

class Vehicle extends StatefulWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  List<VehicleModel> vehicles = [];
  bool loading = true;
  bool isSelected = false;
  User user = getIt<User>();
  bool hasImage = true;

  @override
  void initState() {
    super.initState();
    getVehicle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener(
            bloc: getIt<ProfileCubit>(),
            listener: (context, state) {
              if (state is GetVehiclesLoading) {
                loading = true;
                setState(() {});
              }

              if (state is GetVehiclesError) {
                loading = false;
                setState(() {});
                NotificationMessage.showError(context,
                    message: "Unable to get vehicles at the moment");
              }

              if (state is GetVehiclesSuccess) {
                vehicles = state.vehicles;
                loading = false;
                setState(() {});
              }
            },
            child: Container(
              // height: 1.sh,
              // width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      getIt<NavigationService>().back();
                    },
                    child: SvgPicture.asset(
                      AssetResources.BACk_ICON,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    StringResources.VEHICLES,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    StringResources.SELECT_YOUR_VEHICLE,
                    style: TextStyle(
                      color: AppColors.grey[20],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  loading
                      ? SizedBox(
                          width: 1.sw,
                          child: Center(
                            child: Image.asset(
                              AssetResources.LOADING_GIF,
                              fit: BoxFit.fill,
                              height: 200.w,
                              width: 200.w,
                            ),
                          ),
                        )
                      : vehicles.isEmpty
                          ? Column(
                              children: [
                                Text(
                                  "You do not have any vehicles added yet!",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                              ],
                            )
                          : Column(
                              children: List.generate(
                                vehicles.length,
                                (index) {
                                  final vehicle = vehicles.elementAt(index);

                                  return GestureDetector(
                                    onTap: () {
                                      getIt<NavigationService>()
                                          .toWithParameters(
                                        routeName:
                                            ProfileRoutes.vehiclePlateScreen,
                                        args: {
                                          "plateNumber": vehicle.plateNumber,
                                          "entryPage": EntryPage.profile,
                                          "isVehiclePage": true
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    AssetResources.CAR),
                                                SizedBox(
                                                  width: 25.w,
                                                ),
                                                Text(
                                                  vehicle.plateNumber,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            CupertinoSwitch(
                                              value: vehicle.primaryVehicle,
                                              onChanged: (value) {
                                                if (!vehicle.primaryVehicle) {
                                                  getIt<ProfileCubit>()
                                                      .setVehicleAsPrimary(
                                                    vehicle.id,
                                                  );
                                                }

                                                for (var e in vehicles) {
                                                  e.primaryVehicle = false;
                                                }

                                                vehicle.primaryVehicle = true;
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        ),
                                        Divider(
                                          height: 1.h,
                                          color: AppColors.bgGrey,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ProfileRoutes.vehicleInformation,
                          arguments: {"plateNumber": null}).then((value) {
                        if (value != null && value == true) {
                          getVehicle();
                        }
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(AssetResources.ADD_MORE),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Add New Car',
                          style: GoogleFonts.poppins(
                              fontSize: 18.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getVehicle() {
    getIt<ProfileCubit>().getAllVehicles();
  }
}
