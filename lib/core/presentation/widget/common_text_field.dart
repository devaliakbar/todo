import 'package:flutter/material.dart';
import 'package:todo/core/res/app_theme/app_theme.dart';

class CommonTextField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int maxLength;
  final bool hideMaxLength;
  final int maxLine;

  const CommonTextField(
      {super.key,
      required this.title,
      this.controller,
      this.validator,
      this.maxLength = 50,
      this.hideMaxLength = false,
      this.maxLine = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLine,
      validator: validator,
      decoration: InputDecoration(
          label: Text(title),
          counter: hideMaxLength ? const SizedBox.shrink() : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          hintStyle: TextStyle(color: AppTheme.color.greyLight),
          fillColor: Colors.white),
    );
  }
}
