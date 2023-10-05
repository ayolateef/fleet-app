import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_fleet/screens/home/widget/vehicle_plate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../auth/sign_in/cubit/sign_in_cubit.dart';
import '../../auth/sign_in/model/user.dart';
import '../../route/route.dart';
import '../../utilis/button.dart';
import '../../utilis/colors.dart';
import '../../utilis/config/app_startup.dart';
import '../../utilis/go_caby_appbar.dart';
import '../../utilis/custom_text_field.dart';
import '../../utilis/dialog.dart';
import '../../utilis/messenger.dart';
import '../../utilis/navigation/navigation_service.dart';
import '../../utilis/string.dart';
import '../../utilis/util.dart';
import '../../utilis/validator.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../model/vehicle_model.dart';
import '../model/vehicle_type_model.dart';

class VehicleDocument extends StatefulWidget {
  final String? plateNumber;
  const VehicleDocument({Key? key, required this.plateNumber})
      : super(key: key);

  @override
  State<VehicleDocument> createState() => _VehicleDocumentState();
}

class _VehicleDocumentState extends State<VehicleDocument> {
  File? selectedImages;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _licenceNumController = TextEditingController();
  final TextEditingController _expireNumController = TextEditingController();

  VehicleModel? vehicleModel;
  User? user;

  List<VehicleTypeModel> carType = [];
  bool isVehicle = false;
  bool hasUploadDocument = false;
  bool isDateSelected = false;
  DateTime selectedExpiryDate = DateTime.now();

  @override
  void initState() {
    if (getIt.isRegistered<User>()) {
      user = getIt<User>();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CabyAppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: BlocListener(
                bloc: getIt<ProfileCubit>(),
                listener: (context, state) async {
                  if (state is UploadVehicleLoading) {
                    DialogUtil.showLoadingDialog(context);
                  }

                  if (state is UploadVehicleError) {
                    DialogUtil.dismissLoadingDialog();
                    NotificationMessage.showError(context,
                        message: state.message);
                  }

                  if (state is UploadVehicleSuccess) {
                    await getIt<SignInCubit>().getProfile(isLogin: false);
                    DialogUtil.dismissLoadingDialog();
                    // User has already uploaded the document, navigate to HomeScreen
                    User user = getIt<User>();

                    if (user.preference?.serviceType == ServiceTypes.DELIVERY) {
                      getIt<NavigationService>()
                          .clearAllTo(routeName: RootRoutes.home);
                    } else {
                      getIt<NavigationService>()
                          .clearAllTo(routeName: RootRoutes.home);
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 58.h,
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
                          Text(
                            "Upload Your Driver License",
                            style: TextStyle(
                              color: AppColors.darkBlue,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Visibility(
                            visible: selectedImages == null,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 188.w,
                                  height: 56.h,
                                  child: AppButton(
                                    borderColor: AppColors.darkBlue,
                                    radius: 10.r,
                                    color: AppColors.white,
                                    text: StringResources.SELECT_FROM_GALLERY,
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.darkBlue),
                                    onPressed: () async {
                                      // final List<XFile>? pictures =
                                      //     await _picker.pickMultiImage();
                                      final pictures =
                                          await pickImage(ImageSource.gallery);

                                      if (pictures != null) {
                                        selectedImages = pictures;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20.5.h,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 188.w,
                                    height: 56.h,
                                    child: AppButton(
                                      borderColor: AppColors.darkBlue,
                                      radius: 5.r,
                                      color: AppColors.darkBlue,
                                      text: StringResources.USE_CAMERA,
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.white),
                                      onPressed: () async {
                                        final pictures =
                                            await pickImage(ImageSource.camera);

                                        if (pictures != null) {
                                          selectedImages = pictures;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (selectedImages != null)
                            Stack(
                              children: <Widget>[
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  height: selectedImages!.path
                                              .contains("jpg") ||
                                          selectedImages!.path
                                              .contains("png") ||
                                          selectedImages!.path.contains("jpeg")
                                      ? 300
                                      : 80,
                                  width: 300.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: selectedImages!.path.contains("jpg") ||
                                          selectedImages!.path
                                              .contains("png") ||
                                          selectedImages!.path.contains("jpeg")
                                      ? Image.file(File(selectedImages!.path))
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 15,
                                              right: 45,
                                              top: 5,
                                              bottom: 5),
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 10,
                                              right: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.45),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ListView(
                                            children: const <Widget>[
                                              Text(
                                                "",
                                                // basename(fileClass.file.path),
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedImages = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        size: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Wrap(
                          //   spacing: 8.w,
                          //   runSpacing: 8.h,
                          //   children: List.generate(selectedImages.length ?? 0,
                          //       (index) {
                          //     final selectedImage = selectedImages[index];
                          //     return
                          //   }),
                          // ),
                          SizedBox(height: 50.5.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringResources.LICENCE_NUM,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              CustomTextField(
                                textEditingController: _licenceNumController,
                                type: FieldType.text,
                                textInputFormatters: [
                                  LengthLimitingTextInputFormatter(14),
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
                                ],
                                validator: (v) {
                                  return Validator.requiredValidator(
                                    v,
                                    StringResources.LICENCE_NUM,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              Text(
                                StringResources.EXPIRING_DATE,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              CustomTextField(
                                textEditingController: _expireNumController,
                                type: FieldType.date,
                                readOnly: true,
                                validator: (v) {
                                  return Validator.requiredValidator(
                                      v, StringResources.EXPIRING_DATE);
                                },
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedExpiryDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    _expireNumController.text = formattedDate;
                                    selectedExpiryDate = pickedDate;
                                    setState(() {});
                                  }
                                },
                              ),
                              if (isDateSelected &&
                                  selectedExpiryDate.isBefore(DateTime.now()))
                                Text(
                                  "Expiry date has passed.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                            ],
                          ),
                          SizedBox(height: 100.5.h),
                          AppButton(
                            radius: 56.r,
                            color: AppColors.primaryColor,
                            text: StringResources.SUBMIT,
                            height: 56,
                            textStyle: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                            onPressed: () async {
                              if (selectedImages != null) {
                                upload(widget.plateNumber);
                              } else {
                                NotificationMessage.showError(context,
                                    message:
                                        "Kindly upload your driver's license");
                                return;
                              }
                            },
                          ),
                          SizedBox(
                            height: 40.h,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  //File image = File(selectedImages[index].path);
  upload(plateNumber) {
    getIt<ProfileCubit>().uploadVehicle(
      plateNumber: plateNumber,
      // pass ur documentNumber to the property of type in imageToSend class
      image: [
        ImageToSend(file: selectedImages, type: _licenceNumController.text)
      ],
      documentType: "DRIVERS_LICENSE",
      documentOwner: "DRIVER",
      // documentNumber: _licenceNumController.text,
      expiryDate: _expireNumController.text,
    );
  }
}
