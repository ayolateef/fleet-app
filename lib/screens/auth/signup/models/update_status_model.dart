import 'dart:ui';

class UpdateStatus {
  final String text;
  bool isSelected;
  final Color textColor;
  final String backendText;
  UpdateStatus(
      {required this.text,
      required this.isSelected,
      required this.textColor,
      required this.backendText});
}
