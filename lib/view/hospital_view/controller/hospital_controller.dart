import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/hospital_model.dart';

class HospitalController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var isLoading = false.obs;
  var hospitals = <Hospital>[].obs;
  var filteredHospitals = <Hospital>[].obs;
  var errorMessage = ''.obs;

  // Image handling
  Rx<File?> selectedImage = Rx<File?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final bedsController = TextEditingController();
  var isGovernment = false.obs;
  var specialties = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHospitals();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    bedsController.dispose();
    super.onClose();
  }

  // Fetch all hospitals from Firestore
  Future<void> fetchHospitals() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final snapshot = await _firestore.collection('hospitals').get();
      final List<Hospital> hospitalList =
          snapshot.docs.map((doc) => Hospital.fromFirestore(doc)).toList();

      hospitals.assignAll(hospitalList);
      filteredHospitals.assignAll(hospitalList);
    } catch (e) {
      errorMessage.value = 'Failed to load hospitals: $e';
      Get.snackbar(
        'Error',
        'Failed to load hospitals',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new hospital to Firestore
  Future<void> addHospital() async {
    try {
      if (!validateForm()) return;

      isLoading.value = true;
      Timestamp now = Timestamp.now();

      // Default image URL
      String imageUrl = 'assets/images/hospital_placeholder.png';

      // Create hospital data
      final hospitalData = {
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
        'beds': int.tryParse(bedsController.text.trim()) ?? 0,
        'isGovernment': isGovernment.value,
        'specialties': specialties,
        'imageUrl': imageUrl,
        'createdAt': now,
        'updatedAt': now,
      };

      // Add to Firestore
      await _firestore.collection('hospitals').add(hospitalData);

      // Clear form
      clearForm();

      // Refresh hospital list
      await fetchHospitals();

      Get.snackbar(
        'Success',
        'Hospital added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Navigate back to hospital list
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add hospital: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate form fields
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter hospital name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter hospital address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter hospital phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  // Clear form fields
  void clearForm() {
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    websiteController.clear();
    bedsController.clear();
    isGovernment.value = false;
    specialties.clear();
    selectedImage.value = null;
  }

  // Filter hospitals by name
  void filterHospitals(String query) {
    if (query.isEmpty) {
      filteredHospitals.assignAll(hospitals);
    } else {
      filteredHospitals.assignAll(
        hospitals
            .where(
              (hospital) =>
                  hospital.name.toLowerCase().contains(query.toLowerCase()) ||
                  hospital.address.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  // Add or remove specialty
  void toggleSpecialty(String specialty) {
    if (specialties.contains(specialty)) {
      specialties.remove(specialty);
    } else {
      specialties.add(specialty);
    }
  }
}
