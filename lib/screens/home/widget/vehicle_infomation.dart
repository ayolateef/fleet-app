import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_fleet/screens/home/widget/vehicle_plate.dart';
import 'package:intl/intl.dart';
import '../../auth/sign_in/cubit/sign_in_cubit.dart';
import '../../auth/sign_in/model/user.dart';
import '../../utilis/app_dropdown_modal.dart';
import '../../utilis/button.dart';
import '../../utilis/colors.dart';
import '../../utilis/config/app_startup.dart';
import '../../utilis/go_caby_appbar.dart';
import '../../utilis/custom_text_field.dart';
import '../../utilis/dialog.dart';
import '../../utilis/messenger.dart';
import '../../utilis/navigation/navigation_service.dart';
import '../../utilis/string.dart';
import '../../utilis/validator.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../model/vehicle_info_model.dart';
import '../model/vehicle_model.dart';
import '../model/vehicle_type_model.dart';
import '../routes/routes.dart';

// enum SelectPrefEnum { login, profile, signup }

class VehicleInfo extends StatefulWidget {
  final String? plateNumber;
  const VehicleInfo({Key? key, required this.plateNumber}) : super(key: key);

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController carYearController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  CarColor? carColor;
  CarsModel? carManufacturer;
  VehicleTypeModel? carBrand;
  VehicleModel? vehicleModel;

  List<CarColor> allColors = [];
  void getColors() async {
    final String response =
        await rootBundle.loadString('assets/json/colors.json');
    final data = (await jsonDecode(response)) as Iterable;
    allColors = data.map((e) => CarColor(e['value'] as String)).toList();
  }

  User? user;
  List<VehicleModel> vehicles = [];
  String? selectedItem;
  String? pickedDate;
  DateFormat dateFormat = DateFormat("yyyy");
  DateTime selectedDate = DateTime.now();
  List<CarsModel> cars = [];
  List<VehicleTypeModel> carType = [];
  bool isVehicle = false;
  @override
  void initState() {
    getIt<ProfileCubit>().getAllVehicles();
    if (getIt.isRegistered<User>()) {
      user = getIt<User>();
      getColors();

      if (widget.plateNumber != null) {
        getVehicle();
      } else {
        getManufacturers();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CabyAppBar(
          leadingIcon: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              GetIt.I.get<NavigationService>().back();
            },
            icon: Icon(Icons.arrow_back, color: AppColors.darkBlue),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: BlocConsumer(
                bloc: getIt<ProfileCubit>(),
                listener: (context, state) {
                  if (state is DriverVehicleSuccess) {
                    vehicleModel = state.vehicleModel;
                    if (vehicleModel != null) {
                      carYearController.text = vehicleModel?.year ?? '';

                      carManufacturer = CarsModel(
                          vehicleModel?.model.split("-").first.trim() ?? "");
                      cars.add(CarsModel(carManufacturer!.name!));
                      carBrand = VehicleTypeModel(
                          modelNumber:
                              vehicleModel?.model.split("-").first.trim() ?? "",
                          name:
                              vehicleModel?.model.split("-").last.trim() ?? "");
                      carColor = CarColor(vehicleModel?.color);
                      carType.add(carBrand!);
                      plateNumberController.text =
                          vehicleModel?.plateNumber ?? '';
                      vinController.text = vehicleModel?.vin ?? '';
                    }
                    setState(() {});
                  }

                  if (state is GetVehiclesLoading) {
                    setState(() {});
                  }

                  if (state is GetVehiclesError) {
                    NotificationMessage.showError(context,
                        message: "Unable to get vehicles at the moment");
                  }

                  if (state is GetVehiclesSuccess) {
                    vehicles = state.vehicles;
                    setState(() {});
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display back plate image
                      SizedBox(
                        height: 22.79.h,
                      ),
                      Text(
                        StringResources.VEHICLE_INFORMATION,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "Please provide some information about your vehicle",
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Form(
                        key: _formKey,
                        onChanged: () {
                          isVehicle = _formKey.currentState!.validate();
                          setState(() {});
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocConsumer(
                              bloc: getIt<ProfileCubit>(),
                              listener: (BuildContext context, Object? state) {
                                if (state is ManufactureVehicleSuccess) {
                                  cars = state.vehicleManufacture;

                                  setState(() {});
                                }
                              },
                              builder: (BuildContext context, Object? state) {
                                return AppDropdownModal(
                                    options: cars,
                                    value: carManufacturer,
                                    isLoading:
                                        state is ManufactureVehicleLoading,
                                    hasSearch: true,
                                    onChanged: (CarsModel? value) {
                                      carManufacturer = value;

                                      getAllManufacturers(value?.name);
                                      setState(() {});
                                    },
                                    validator: (v) {
                                      return Validator.requiredValidator(v,
                                          "${StringResources.MANUFACTURER} is required");
                                    },
                                    modalHeight: 610.h,
                                    // hint: 'Select an option',
                                    headerText: StringResources.MANUFACTURER);
                              },
                            ),
                            SizedBox(
                              height: 20.5.h,
                            ),
                            BlocConsumer(
                              bloc: getIt<ProfileCubit>(),
                              builder: (BuildContext context, state) {
                                return AppDropdownModal(
                                  options: carType,
                                  value: carBrand,
                                  isLoading:
                                      state is AllManufactureVehicleLoading,
                                  hasSearch: true,
                                  onChanged: (value) {
                                    carBrand = value;
                                    if (vehicleModel != null) {
                                      carBrand = carType.firstWhere((element) =>
                                          element.name == vehicleModel?.model);
                                    }
                                    setState(() {});
                                  },
                                  validator: (v) {
                                    return Validator.requiredValidator(
                                        v.toString(),
                                        "${StringResources.CAR_BRAND} is required");
                                  },
                                  modalHeight: 610.h,
                                  // hint: 'Select an option',
                                  headerText: StringResources.CAR_BRAND,
                                );
                              },
                              listener: (BuildContext context, Object? state) {
                                if (state is AllManufactureVehicleSuccess) {
                                  carType = state.allVehicleManufacture;

                                  //setState(() {});
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.5.h,
                            ),
                            CustomTextField(
                              textEditingController: carYearController,
                              header: StringResources.YEAR,
                              enable: widget.plateNumber == null,
                              validator: (value) {
                                Validator.requiredValidator(
                                    value, StringResources.YEAR);
                                return null;
                              },
                              onTap: () {
                                _pickYear(context);
                              },
                            ),
                            AppDropdownModal(
                              headerText: StringResources.COLOR,
                              hasSearch: true,
                              value: carColor,
                              onChanged: (value) {
                                carColor = value as CarColor;
                                setState(() {});
                              },
                              validator: (v) {
                                return Validator.requiredValidator(
                                  v?.toString(),
                                  "Car color is required",
                                );
                              },
                              options: allColors,
                              modalHeight: 600.h,
                            ),
                            SizedBox(
                              height: 20.5.h,
                            ),
                            CustomTextField(
                              textEditingController: plateNumberController,
                              header: StringResources.PLATE_NUMBER,
                              enable: widget.plateNumber == null,
                              textInputFormatters: [
                                LengthLimitingTextInputFormatter(9),
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              validator: (v) {
                                if (v == null) {
                                  return StringResources.PLATE_NUMBER;
                                } else if (v.length < 7) {
                                  return "Plate number must contain at least 7 alphanumerics";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 100.5.h),
                            BlocListener(
                              bloc: getIt<ProfileCubit>(),
                              listener: (BuildContext context, state) async {
                                if (state is VehicleBrandSuccess) {
                                  vehicleModel = state.vehicleModel;
                                  setState(() {});
                                }

                                if (state is AddVehicleInfoLoading) {
                                  DialogUtil.showLoadingDialog(context);
                                }

                                if (state is AddVehicleInfoSuccess) {
                                  DialogUtil.dismissLoadingDialog();

                                  getIt<NavigationService>()
                                      .clearAllToWithParameters(
                                          routeName:
                                              ProfileRoutes.vehiclePlateScreen,
                                          args: {
                                        "plateNumber":
                                            plateNumberController.text,
                                        "entryPage": EntryPage.onBoarding
                                      });
                                }

                                if (state is AddVehicleInfoError) {
                                  DialogUtil.dismissLoadingDialog();
                                  NotificationMessage.showError(context,
                                      message: state.message);
                                }

                                if (state is UploadVehicleLoading) {
                                  DialogUtil.showLoadingDialog(context);
                                }

                                if (state is UploadVehicleSuccess) {
                                  DialogUtil.dismissLoadingDialog();
                                  getIt<ProfileCubit>()
                                      .getVehicleInfo(user!.userId);
                                  NotificationMessage.showSuccess(context,
                                      message:
                                          "Vehicle information successfully added!");
                                  getIt<SignInCubit>()
                                      .getProfile(isLogin: false);
                                }

                                if (state is UploadVehicleError) {
                                  DialogUtil.dismissLoadingDialog();
                                  NotificationMessage.showError(context,
                                      message: state.message);
                                }
                              },
                              child: Visibility(
                                visible: carBrand != null &&
                                    widget.plateNumber == null,
                                child: AppButton(
                                    radius: 56.r,
                                    color: AppColors.primaryColor,
                                    text: StringResources.SUBMIT,
                                    height: 56,
                                    textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        AddVehicleInfo addVehicleInfo;
                                        addVehicleInfo = AddVehicleInfo(
                                          color: carColor?.color,
                                          model:
                                              "${carManufacturer?.name} ${carBrand?.name.toString()}",
                                          operation: "CREATE",
                                          owner: true,
                                          plateNumber:
                                              plateNumberController.text,
                                          primaryVehicle: true,
                                          vehicleType: "CAR",
                                          vin: "",
                                          year: carYearController.text,
                                        );
                                        getIt<ProfileCubit>()
                                            .addVehicleInfo(addVehicleInfo);
                                      }
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }

  void _pickYear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          title: const Text('Select a Year'),
          // Changing default contentPadding to make the content looks better

          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            // Giving some size to the dialog so the gridview know its bounds

            height: size.height / 3,
            width: size.width,
            //  Creating a grid view with 3 elements per line.
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                ...List.generate(
                  20,
                  (index) => InkWell(
                    onTap: () {
                      // The action you want to happen when you select the year below,
                      selectedDate = DateTime(2023 - index + 1, 0, 0);

                      // Quitting the dialog through navigator.
                      Navigator.pop(context);
                      carYearController.text = dateFormat.format(selectedDate);
                    },
                    // This part is up to you, it's only ui elements
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        label: Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            // Showing the year text, it starts from 2022 and ends in 1900 (you can modify this as you like)
                            (2023 - index).toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getVehicle() {
    getIt<ProfileCubit>().getVehicleByPlateNumber(widget.plateNumber);
  }

  getManufacturers() {
    getIt<ProfileCubit>().getVehicleManufacture();
  }

  getAllManufacturers(vehicleName) {
    getIt<ProfileCubit>().getAllVehicleManufacture(name: vehicleName);
  }
}

// Inside the `_VehicleInfoState` class

class CarsModel extends DropdownBaseModel {
  String? name;
  CarsModel(this.name);

  @override
  // TODO: implement displayName
  String get displayName => name!;
}

class CarColor extends DropdownBaseModel {
  String? color;
  CarColor(this.color);

  @override
  // TODO: implement displayName
  String get displayName => color!;
}
