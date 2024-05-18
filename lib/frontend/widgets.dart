import 'package:flutter/material.dart';

inputField(context,
    {required TextEditingController controller,
    required Icon icon,
    required String hintText,
    required passwordField,
    required readOnly,
    onChanged,
    int maxLines = 1,
    int minLines = 1,
    TextInputType keyboardType = TextInputType.name}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.85,
    child: TextField(
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: passwordField,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
    ),
  );
}
