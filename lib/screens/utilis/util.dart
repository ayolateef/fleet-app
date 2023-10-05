import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_fleet/screens/utilis/photo_bottom_sheet.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'colors.dart';

Future<Uint8List> getBytesFromAsset(String path, int width, int height) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<File?> pickImage(ImageSource source) async {
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return cropImage(pickedFile);
  }
}

Future<File?> cropImage(XFile documentImages) async {
  File? croppedFile = await ImageCropper().cropImage(
    sourcePath: documentImages.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Crop selected image',
      toolbarColor: AppColors.black.withOpacity(0.7),
      toolbarWidgetColor: Colors.white,
      activeControlsWidgetColor: AppColors.primaryColor,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    iosUiSettings: const IOSUiSettings(
      minimumAspectRatio: 0.5,
      aspectRatioLockDimensionSwapEnabled: true,
    ),
  );

  return croppedFile;
}
