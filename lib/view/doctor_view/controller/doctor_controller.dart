import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welllink/view/doctor_view/model/doctor_model.dart';
import 'package:welllink/view/hospital_view/model/hospital_model.dart';

class DoctorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var isLoading = false.obs;
  var doctors = <Doctor>[].obs;
  var filteredDoctors = <Doctor>[].obs;
  var errorMessage = ''.obs;
  var selectedHospital = Rxn<Hospital>();
  var hospitals = <Hospital>[].obs;
  var selectedImage = Rx<File?>(null);

  // Form controllers
  final nameController = TextEditingController();
  final specializationController = TextEditingController();
  final qualificationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final experienceController = TextEditingController();

  // Selected values
  var availableDays = <String>[].obs;
  var isAvailable = true.obs;

  // Days of the week
  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
    fetchHospitals(); // Add this line to fetch hospitals when controller initializes
  }

  @override
  void onClose() {
    nameController.dispose();
    specializationController.dispose();
    qualificationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    experienceController.dispose();
    super.onClose();
  }

  // Fetch all doctors from Firestore
  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final QuerySnapshot snapshot =
          await _firestore.collection('doctors').orderBy('name').get();

      final List<Doctor> doctorList =
          snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();

      doctors.assignAll(doctorList);
      filteredDoctors.assignAll(doctorList);
    } catch (e) {
      errorMessage.value = 'Failed to load doctors: $e';
      Get.snackbar(
        'Error',
        'Failed to load doctors',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all hospitals for dropdown
  Future<void> fetchHospitals() async {
    try {
      isLoading.value = true;

      final QuerySnapshot snapshot =
          await _firestore.collection('hospitals').orderBy('name').get();

      final List<Hospital> hospitalList =
          snapshot.docs.map((doc) => Hospital.fromFirestore(doc)).toList();

      hospitals.assignAll(hospitalList);

      // Set default hospital if available
      if (hospitals.isNotEmpty && selectedHospital.value == null) {
        selectedHospital.value = hospitals.first;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load hospitals: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new doctor to Firestore
  Future<void> addDoctor() async {
    try {
      if (!validateForm()) return;

      isLoading.value = true;
      Timestamp now = Timestamp.now();

      // Default image URL
      String imageUrl = 'assets/images/doctor_placeholder.png';
      // Create doctor data
      final doctorData = {
        'name': nameController.text.trim(),
        'specialization': specializationController.text.trim(),
        'qualification': qualificationController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'experience': experienceController.text.trim(),
        'hospitalId': selectedHospital.value?.id ?? '',
        'hospitalName': selectedHospital.value?.name ?? '',
        'isAvailable': isAvailable.value,
        'availableDays': availableDays,
        'imageUrl': imageUrl,
        'createdAt': now,
        'updatedAt': now,
      };

      // Add to Firestore
      await _firestore.collection('doctors').add(doctorData);

      Get.back(); // Go back to doctor list
      Get.snackbar(
        'Success',
        'Doctor added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh the list
      fetchDoctors();
      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add doctor: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate form fields
  // Validate form inputs
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter doctor name');
      return false;
    }

    if (specializationController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter specialization');
      return false;
    }

    if (qualificationController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter qualification');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return false;
    }

    if (selectedHospital.value == null) {
      Get.snackbar('Error', 'Please select a hospital');
      return false;
    }

    if (availableDays.isEmpty) {
      Get.snackbar('Error', 'Please select at least one available day');
      return false;
    }

    if (experienceController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter years of experience');
      return false;
    }

    return true;
  }

  // Clear form fields
  void clearForm() {
    nameController.clear();
    specializationController.clear();
    qualificationController.clear();
    phoneController.clear();
    emailController.clear();
    experienceController.clear();
    selectedHospital.value = null;
    availableDays.clear();
    isAvailable.value = true;
    selectedImage.value = null;
  }

  // Filter doctors by name or specialization
  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(doctors);
    } else {
      filteredDoctors.assignAll(
        doctors
            .where(
              (doctor) =>
                  doctor.name.toLowerCase().contains(query.toLowerCase()) ||
                  doctor.specialization.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  doctor.hospitalName.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
  }

  // Toggle available day
  void toggleDay(String day) {
    if (availableDays.contains(day)) {
      availableDays.remove(day);
    } else {
      availableDays.add(day);
    }
  }
}
