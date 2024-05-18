import 'package:flutter/material.dart';
import 'package:servio/backend/variables.dart';

setUserdataOnEditProfilePage() {
  displayNameController.value = TextEditingValue(text: displayName);
  emailController.value = TextEditingValue(text: email);
  passwordController.value = const TextEditingValue(text: '');
}
