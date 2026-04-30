import 'package:flutter/material.dart';

class ProfileSectionEditFieldBinding {
  const ProfileSectionEditFieldBinding({
    required this.controller,
    this.selectedApiValueKey,
    this.datePicker = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String? selectedApiValueKey;
  final bool datePicker;
  final TextInputType? keyboardType;
}
