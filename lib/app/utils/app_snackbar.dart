import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show(
      String title,
      String message,
      ) {
    Get.snackbar(
      title, message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}