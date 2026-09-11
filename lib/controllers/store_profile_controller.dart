import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/store_profile_model.dart';
import '../services/store_profile_service.dart';
import 'auth_controller.dart';

class StoreProfileController extends GetxController {
  final StoreProfileService storeProfileService =
  StoreProfileService();

  final AuthController authController =
  Get.find<AuthController>();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  final storeProfile = Rxn<StoreProfileModel>();

  late TextEditingController storeNameController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();

    storeNameController = TextEditingController();
    descriptionController = TextEditingController();
    phoneController = TextEditingController();

    // Wait for AuthController to get the Firebase user.
    ever(authController.user, (user) {
      if (user != null) {
        getStoreProfile();
      } else {
        storeProfile.value = null;
        errorMessage.value = '';
      }
    });

    // If user is already available.
    if (authController.user.value != null) {
      getStoreProfile();
    }
  }

  Future<void> getStoreProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final profile =
      await storeProfileService.getStoreProfile();

      storeProfile.value = profile;

      storeNameController.text = profile.storeName;
      descriptionController.text =
          profile.storeDescription;
      phoneController.text = profile.phone;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStoreProfile() async {
    try {
      if (storeNameController.text.trim().isEmpty) {
        Get.snackbar(
          'Required',
          'Please enter your store name',
        );
        return;
      }

      isSaving.value = true;
      errorMessage.value = '';

      await storeProfileService.updateStoreProfile(
        storeName: storeNameController.text,
        storeDescription: descriptionController.text,
        phone: phoneController.text,
      );

      final currentProfile = storeProfile.value;

      if (currentProfile != null) {
        storeProfile.value = currentProfile.copyWith(
          storeName: storeNameController.text.trim(),
          storeDescription:
          descriptionController.text.trim(),
          phone: phoneController.text.trim(),
        );
      }

      Get.snackbar(
        'Success',
        'Store profile updated successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Failed to update store profile',
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    storeNameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();

    super.onClose();
  }
}