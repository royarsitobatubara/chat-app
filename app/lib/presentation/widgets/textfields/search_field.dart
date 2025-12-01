import 'package:app/core/constants/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  const SearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: AppColor.white),
        decoration: InputDecoration(
          hintText: 'search_here'.tr(),
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: AppColor.secondary,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.lightBlue),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.lightBlue),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
