import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
    IconData icon, String title, String subtitle, Color color) {
  Get.snackbar(
    margin: const EdgeInsets.all(20.0),
    title,
    subtitle,
    icon: Icon(icon, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color,
    colorText: Colors.white,
    duration: const Duration(milliseconds: 2000),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  );
}
