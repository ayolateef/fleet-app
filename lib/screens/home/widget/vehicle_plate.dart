import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/sign_in/cubit/sign_in_cubit.dart';
import '../../auth/sign_in/model/user.dart';
import '../../route/route.dart';
import '../../utilis/asset_images.dart';
import '../../utilis/button.dart';
import '../../utilis/cache_image.dart';
import '../../utilis/colors.dart';
import '../../utilis/config/app_startup.dart';
import '../../utilis/go_caby_appbar.dart';
import '../../utilis/dialog.dart';
import '../../utilis/messenger.dart';
import '../../utilis/navigation/navigation_service.dart';
import '../../utilis/string.dart';
import '../../utilis/util.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../model/vehicle_model.dart';
import '../routes/routes.dart';

enum EntryPage { home, onBoarding, profile }

class VehiclePlatePage extends StatefulWidget {
  final String? plateNumber;
  final EntryPage entryPage;
  final bool? isVehiclePage;
  const VehiclePlatePage(
      {super.key,
      required this.plateNumber,
      required this.entryPage,
      this.isVehiclePage});

  @override
  _VehiclePlatePageState createState() => _VehiclePlatePageState();
}

class _VehiclePlatePageState extends State<VehiclePlatePage> {
  User? user;
  File? _frontPlateImage;
  File? _backPlateImage;
  final picker = ImagePicker();
  static String plateExpiryDate = '';
  VehicleModel? vehicles;
  String errorMessage = "";
  bool isVehiclePage = false;
  bool isError = false;
  List<Documents> images = [];
  @override
  void initState() {
    getIt<ProfileCubit>().getAllVehicles();
    if (getIt.isRegistered<User>()) {
      user = getIt<User>();
    }
    if (widget.plateNumber != null && widget.entryPage == EntryPage.profile) {
      getIt<ProfileCubit>().getVehicleByPlateNumber(widget.plateNumber);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CabyAppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
        titleWidget: Text(
          widget.entryPage == EntryPage.onBoarding
              ? "Upload Vehicle Plate"
              : 'Vehicle- ${widget.plateNumber}',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: AppColors.cabyCharcoal,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                26.verticalSpace,
                Text(
                  StringResources.UPLOAD_CAR_IMAGES,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.secondaryColor,
                  ),
                ),
                16.verticalSpace,
                Text(
                  StringResources.PLEASE_PROVIDE_A_CLEAR_IMAGE,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    color: AppColors.secondaryColor,
                    wordSpacing: 1.5,
                  ),
                ),
                48.verticalSpace,
                BlocListener(
                  bloc: getIt<ProfileCubit>(),
                  listener: (BuildContext context, state) async {
                    if (state is UploadVehicleLoading) {
                      DialogUtil.showLoadingDialog(context);
                    }

                    if (state is UploadVehicleError) {
                      DialogUtil.dismissLoadingDialog();
                      NotificationMessage.showError(context,
                          message: state.message);
                      DialogUtil.dismissLoadingDialog();
                    }
                    if (state is UploadVehicleSuccess) {
                      DialogUtil.dismissLoadingDialog();
                      NotificationMessage.showSuccess(context,
                          message: "Successfully Uploaded");
                      getIt<ProfileCubit>().getAllVehicles();
                      await getIt<SignInCubit>().getProfile(isLogin: false);

                      if (widget.entryPage == EntryPage.home) {
                        // Go back to the VehiclePage
                        getIt<NavigationService>()
                            .clearAllTo(routeName: RootRoutes.home);
                      } else if (widget.entryPage == EntryPage.onBoarding &&
                          user?.setup?.hasDrivingLicense == false) {
                        getIt<NavigationService>().pushReplace(
                            routeName: ProfileRoutes.vehicleDocuments,
                            args: {"plateNumber": widget.plateNumber});
                      } else {
                        if (user?.preference?.serviceType ==
                            ServiceTypes.DELIVERY) {
                          getIt<NavigationService>()
                              .clearAllTo(routeName: RootRoutes.home);
                        } else {
                          getIt<NavigationService>()
                              .clearAllTo(routeName: RootRoutes.home);
                        }
                      }
                    }

                    if (state is DriverVehicleLoading) {
                      isVehiclePage = true;
                    }
                    if (state is DriverVehicleError) {
                      isVehiclePage = false;
                      isError = true;
                      errorMessage = state.message;
                      setState(() {});
                    }
                    if (state is DriverVehicleSuccess) {
                      isVehiclePage = false;
                      images = state.vehicleModel.documents;
                      setState(() {});
                    }
                  },
                  child: Visibility(
                    visible: widget.plateNumber != null &&
                        widget.entryPage == EntryPage.profile,
                    replacement: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display selected front image
                              _buildImageOrButton(
                                  imageFile: _frontPlateImage,
                                  text: 'Upload Front Image',
                                  onDelete: () {
                                    _frontPlateImage = null;
                                  },
                                  onTap: () {
                                    pickImage(ImageSource.camera).then((value) {
                                      _frontPlateImage = value;
                                      setState(() {});
                                    });
                                  }),
                              38.verticalSpace,

                              _buildImageOrButton(
                                  imageFile: _backPlateImage,
                                  text: 'Upload Back Image',
                                  onDelete: () {
                                    _backPlateImage = null;
                                    setState(() {});
                                  },
                                  onTap: () {
                                    pickImage(ImageSource.camera).then((value) {
                                      _backPlateImage = value;
                                      setState(() {});
                                    });
                                  }),
                              48.verticalSpace,
                              Center(
                                child: AppButton(
                                  onPressed: (_frontPlateImage != null &&
                                          _backPlateImage != null)
                                      ? () => uploadVehiclePlate()
                                      : null,
                                  text: 'Submit Images',
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (isVehiclePage)
                          Center(
                              child: SizedBox(
                            height: 1.sw,
                            child: Center(
                              child: Image.asset(
                                AssetResources.LOADING_GIF,
                                fit: BoxFit.fill,
                                height: 200.w,
                                width: 200.w,
                              ),
                            ),
                          ))
                        else if (isError)
                          Container(
                            margin: EdgeInsets.only(top: 200.h),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(errorMessage),
                                  TextButton(
                                      onPressed: () {
                                        getIt<ProfileCubit>()
                                            .getVehicleByPlateNumber(
                                                widget.plateNumber);
                                      },
                                      child: Text(
                                        'Retry',
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkBlue),
                                      ))
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (images.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: images.any((element) =>
                                            element.documentNumber ==
                                            "FRONT_IMAGE"),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          child: GoCabyCacheImage(
                                            width: double.infinity,
                                            height: 200.h,
                                            imgUrl: images
                                                    .firstWhere(
                                                      (element) =>
                                                          element
                                                              .documentNumber ==
                                                          "FRONT_IMAGE",
                                                    )
                                                    .document ??
                                                "",
                                          ),
                                        ),
                                        replacement: _buildImageOrButton(
                                            onDelete: null,
                                            imageFile: _frontPlateImage,
                                            onTap: () {
                                              pickImage(ImageSource.camera)
                                                  .then((value) {
                                                _frontPlateImage = value;
                                                setState(() {});
                                              });
                                            }),
                                      ),
                                      SizedBox(height: 15.w),
                                      AppButton(
                                        onPressed: null,
                                        text: 'Upload Front Image',
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(height: 70.h),
                                      if (images.any((element) =>
                                              element.documentNumber ==
                                              "BACK_IMAGE") !=
                                          false)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          child: GoCabyCacheImage(
                                            width: double.infinity,
                                            height: 200.h,
                                            imgUrl: images
                                                    .firstWhere((element) =>
                                                        element
                                                            .documentNumber ==
                                                        "BACK_IMAGE")
                                                    .document ??
                                                "",
                                          ),
                                        )
                                      else
                                        _buildImageOrButton(
                                            imageFile: _backPlateImage,
                                            onDelete: null,
                                            onTap: () {
                                              pickImage(ImageSource.camera)
                                                  .then((value) {
                                                _backPlateImage = value;
                                                setState(() {});
                                              });
                                            }),
                                      SizedBox(height: 15.w),
                                      AppButton(
                                        onPressed: null,
                                        text: 'Upload Back Image',
                                        color: AppColors.primaryColor,
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                              ])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadVehiclePlate() {
    if (_frontPlateImage != null && _backPlateImage != null) {
      // Upload front plate image
      getIt<ProfileCubit>().uploadVehicle(
        plateNumber: widget.plateNumber,
        image: [
          ImageToSend(file: _frontPlateImage, type: "FRONT_IMAGE"),
          ImageToSend(file: _backPlateImage, type: "BACK_IMAGE")
        ],

        documentType: "CAR_IMAGE",
        documentOwner: "VEHICLE",
        // documentNumber: 'FRONT_IMAGE',
        expiryDate: plateExpiryDate,
      );
    }
  }

  Widget _buildImageOrButton(
      {VoidCallback? onTap,
      File? imageFile,
      String? text,
      VoidCallback? onDelete}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: imageFile == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetResources.defaultImage,
                  width: double.infinity,
                  height: 78.3.h,
                ),
                SizedBox(height: 50.h),
                Text(
                  text ?? '',
                  style: TextStyle(
                    height: 1.37,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7F91A8),
                  ),
                ),
                Text(
                  "File format: JPG, JPEG, PNG | Max File 2mb",
                  style: TextStyle(
                    height: 1.37,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7F91A8),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.file(
                      height: 200.h,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      imageFile,
                    ),
                  ),
                  if (onDelete != null)
                    Positioned(
                      top: 1.h,
                      right: 1.w,
                      child: IconButton(
                        onPressed: () {
                          onDelete();
                        },
                        icon: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: AppColors.cabyRed,
                          child: Icon(
                            Icons.close,
                            size: 20.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class ImageToSend {
  File? file;
  String? type;
  ImageToSend({this.file, this.type});
}
