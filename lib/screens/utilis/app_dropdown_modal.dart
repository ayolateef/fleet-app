import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../home/model/vehicle_type_model.dart';
import 'custom_text_field.dart';
import 'navigation/navigation_service.dart';

class AppDropdownModal<T> extends StatefulWidget {
  final String headerText;
  final String? descriptionText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final List<T>? options;
  final T? value;
  final bool hasSearch;
  final String? parentName;
  final double modalHeight;
  final ValueChanged<T?> onChanged;
  bool useMargin;
  bool isLoading;
  AppDropdownModal(
      {Key? key,
      required this.headerText,
      this.hintText,
      this.enabled = true,
      required this.onChanged,
      this.validator,
      this.parentName,
      this.descriptionText,
      required this.options,
      this.value,
      this.useMargin = true,
      required this.modalHeight,
      this.hasSearch = false,
      this.isLoading = false})
      : super(key: key);

  @override
  State<AppDropdownModal> createState() => _AppDropdownModalState();
}

class _AppDropdownModalState<T extends DropdownBaseModel>
    extends State<AppDropdownModal> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<T> filteredItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      controller.text = widget.value!.displayName;
    } else {
      controller.clear();
    }
    if (searchController.text.isEmpty) {
      filteredItems = widget.options!.cast<T>();
    }
    return CustomTextField(
      header: widget.headerText,
      hint: widget.hintText,
      useMargin: widget.useMargin,

      readOnly: true,
      // onChanged: add_customer_business.onChanged,
      validator: widget.validator,
      textEditingController: controller,
      suffix: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: widget.isLoading
            ? const CupertinoActivityIndicator()
            : Icon(
                Icons.arrow_drop_down,
                size: 24,
                color:
                    filteredItems.isEmpty ? Colors.grey : Colors.grey.shade700,
              ),
      ),
      onTap: filteredItems.isEmpty
          ? null
          : () async {
              // if (filteredItems.isEmpty) toast("Empty List");
              _showModal(widget.headerText);
            },
    );
  }

  void _showModal(String headerText) {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, setModalState) {
            return Wrap(
              children: [
                SizedBox(
                  height: widget.modalHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                headerText.trim().endsWith('*')
                                    ? headerText.trim().substring(
                                        0, headerText.trim().lastIndexOf('*'))
                                    : headerText.trim(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 13.w),
                                child: IconButton(
                                  onPressed: () =>
                                      GetIt.I.get<NavigationService>().back(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.h),
                        _separator,
                        SizedBox(height: 13.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.hasSearch
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          List temp = widget.options!
                                              .where((element) => element
                                                  .displayName
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                          setModalState(() {
                                            filteredItems = temp as List<T>;
                                          });
                                        },
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                          height: 1.4,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xFFF4F4F4),
                                          isDense: true,
                                          filled: true,
                                          prefixIcon: const Icon(Icons.search,
                                              color: Colors.black),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 12.w),
                                          border: InputBorder.none,
                                          hintText: 'search',
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            height: 1,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              widget.hasSearch
                                  ? SizedBox(height: 10.h)
                                  : const SizedBox.shrink(),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: filteredItems.length,
                                  separatorBuilder: (_, index) => _separator,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        // vertical: 13.h,
                                      ),
                                      title: Text(
                                        filteredItems[index]
                                            .displayName
                                            .capitalize(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                          height: 1.4,
                                        ),
                                      ),
                                      onTap: () {
                                        // setState(() {
                                        controller.text =
                                            filteredItems[index].displayName;
                                        // });
                                        widget.onChanged(filteredItems[index]);
                                        GetIt.I.get<NavigationService>().back();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

const Divider _separator = Divider(
  height: 0,
  thickness: .5,
  color: Color(0xFFDCD6CF),
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
