import 'package:app/core/constants/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool loading;
  final VoidCallback handle;
  final String text;
  const SubmitButton({
    super.key,
    required this.loading,
    required this.text,
    required this.handle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.lightBlue,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.lightBlue.withValues(alpha: .5),
            offset: const Offset(0, 5),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : () => handle(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: loading
            ? const CircularProgressIndicator()
            : Text(
                text.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColor.primary,
                ),
              ),
      ),
    );
  }
}
