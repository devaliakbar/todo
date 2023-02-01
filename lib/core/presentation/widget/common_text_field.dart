import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String title;
  final int maxLength;
  final bool hideMaxLength;
  final int maxLine;

  const CommonTextField(
      {super.key,
      required this.title,
      this.maxLength = 50,
      this.hideMaxLength = false,
      this.maxLine = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      maxLines: maxLine,
      decoration: InputDecoration(
          label: Text(title),
          counter: hideMaxLength ? const SizedBox.shrink() : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[400]),
          fillColor: Colors.white),
    );
  }
}
