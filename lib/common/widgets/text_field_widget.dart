import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int maxLines;
  final int? minLines;
  final MouseCursor? mouseCursor;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.mouseCursor,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        mouseCursor: mouseCursor,
        readOnly: readOnly,
        decoration: customDecoration(
          hint: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
InputDecoration customDecoration({
  required String hint,
  Widget? suffixIcon,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: hintStyle ??
        TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500
        ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 12,
    ),
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
    ),
  );
}
