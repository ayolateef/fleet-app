import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';

final picker = ImagePicker();

final TextStyle itemInfo = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w600,
  color: AppColors.grey[40],
  height: 1.20,
);

void showPhotoDialogBottomSheet(
    {required BuildContext context, required Function(File) onCompleted}) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SizedBox(
            height: 200.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 28.h),
                GestureDetector(
                    onTap: () => _openCamera(context, onCompleted),
                    child: takePhoto(context)),
                SizedBox(height: 40.h),
                GestureDetector(
                    onTap: () => chooseFromGallery(
                          context: context,
                          onCompleted: onCompleted,
                        ),
                    child: _chooseFromGallery(context)),
              ],
            ),
          ),
        );
      });
}

Widget takePhoto(BuildContext context) => Row(
      children: [
        const Icon(Icons.camera),
        SizedBox(width: 10.w),
        Text("Take a new photo", style: itemInfo)
      ],
    );
Widget _chooseFromGallery(BuildContext context) => Row(
      children: [
        const Icon(Icons.browse_gallery),
        SizedBox(width: 10.w),
        Text("Open gallery", style: itemInfo)
      ],
    );

void _openCamera(BuildContext context, Function(File) onCompleted) async {
  final XFile? picture = await picker.pickImage(source: ImageSource.camera);
  if (picture == null) {
    // NotificationMessage.showError(context,
    //     message: S.of(context).noFileSelected);
  } else {
    onCompleted(File(picture.path));
  }
  Navigator.of(context).pop();
}

void chooseFromGallery(
    {required BuildContext context,
    required Function(File) onCompleted}) async {
  // FilePickerResult? picture = await FilePicker.platform.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: ['jpg', 'png'],
  // );
  final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

  if (picture == null) {
    // NotificationMessage.showError(context,
    //     message: S.of(context).noFileSelected);
  } else {
    onCompleted(File(picture.path));
  }
}
