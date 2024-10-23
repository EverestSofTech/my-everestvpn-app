import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ThemeController extends GetxController {
  // Reactive variable to manage the theme mode
  var isDarkMode = false.obs;

  // Method to toggle theme mode
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  // Get the current theme data based on the state
  ThemeData get themeData {
    return isDarkMode.value ? ThemeData.dark() : ThemeData.light();
  }
}
