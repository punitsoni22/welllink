import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:welllink/utils/routes/app_routes.dart';
import 'package:welllink/view/appointment_view/model/appointment_model.dart';
import 'package:welllink/view/doctor_view/model/doctor_model.dart';
import 'package:welllink/view/hospital_view/model/hospital_model.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables
  var isLoading = false.obs;
  var hospitals = <Hospital>[].obs;
  var filteredHospitals = <Hospital>[].obs;
  var doctors = <Doctor>[].obs;
  var filteredDoctors = <Doctor>[].obs;
  var appointments = <Appointment>[].obs;
  var userAppointments = <Appointment>[].obs;
  var selectedHospital = Rxn<Hospital>();
  var selectedDoctor = Rxn<Doctor>();
  var selectedDate = Rxn<DateTime>();
  var selectedTimeSlot = ''.obs;
  var availableTimeSlots = <String>[].obs;
  var errorMessage = ''.obs;

  // Form controllers
  final patientNameController = TextEditingController();
  final patientPhoneController = TextEditingController();
  final patientEmailController = TextEditingController();
  final notesController = TextEditingController();

  // Time slots (30 min intervals from 10 AM to 6 PM)
  final List<String> allTimeSlots = [
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '12:00 PM - 12:30 PM',
    '12:30 PM - 01:00 PM',
    '01:00 PM - 01:30 PM',
    '01:30 PM - 02:00 PM',
    '02:00 PM - 02:30 PM',
    '02:30 PM - 03:00 PM',
    '03:00 PM - 03:30 PM',
    '03:30 PM - 04:00 PM',
    '04:00 PM - 04:30 PM',
    '04:30 PM - 05:00 PM',
    '05:00 PM - 05:30 PM',
    '05:30 PM - 06:00 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchHospitals();
  }

  @override
  void onClose() {
    patientNameController.dispose();
    patientPhoneController.dispose();
    patientEmailController.dispose();
    notesController.dispose();
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
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch doctors by hospital ID
  Future<void> fetchDoctorsByHospital(String hospitalId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final QuerySnapshot snapshot =
          await _firestore
              .collection('doctors')
              .where('hospitalId', isEqualTo: hospitalId)
              .where('isAvailable', isEqualTo: true)
              .get();

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
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Select hospital and navigate to doctor list
  void selectHospital(Hospital hospital) {
    selectedHospital.value = hospital;
    fetchDoctorsByHospital(hospital.id);
    Get.toNamed(AppRoutes.appointmentDoctorListView);
  }

  // Select doctor and navigate to booking view
  void selectDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
    selectedDate.value = null;
    selectedTimeSlot.value = '';
    Get.toNamed(AppRoutes.appointmentBookingView);
  }

  // Select date and update available time slots
  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;
    await updateAvailableTimeSlots();
  }

  // Update available time slots based on existing appointments
  Future<void> updateAvailableTimeSlots() async {
    if (selectedDate.value == null || selectedDoctor.value == null) return;

    try {
      isLoading.value = true;

      // Get the start and end of the selected date
      final DateTime startDate = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
      );
      final DateTime endDate = startDate.add(const Duration(days: 1));

      // Fetch appointments for the selected doctor on the selected date
      final QuerySnapshot snapshot =
          await _firestore
              .collection('appointments')
              .where('doctorId', isEqualTo: selectedDoctor.value!.id)
              .where(
                'appointmentDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where('appointmentDate', isLessThan: Timestamp.fromDate(endDate))
              .get();

      final List<Appointment> appointmentList =
          snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList();

      // Get booked time slots
      final List<String> bookedSlots =
          appointmentList.map((appointment) => appointment.timeSlot).toList();

      // Check if the selected day is in doctor's available days
      final String dayName = DateFormat('EEEE').format(selectedDate.value!);
      final bool isDayAvailable = selectedDoctor.value!.availableDays.contains(
        dayName,
      );

      if (!isDayAvailable) {
        availableTimeSlots.clear();
        Get.snackbar(
          'Not Available',
          'The doctor is not available on ${dayName}s',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Filter out booked slots
      final List<String> available =
          allTimeSlots.where((slot) => !bookedSlots.contains(slot)).toList();

      availableTimeSlots.assignAll(available);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load available time slots: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user already has an appointment on the selected date
  Future<bool> hasExistingAppointment() async {
    if (selectedDate.value == null) return false;

    try {
      // Get the start and end of the selected date
      final DateTime startDate = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
      );
      final DateTime endDate = startDate.add(const Duration(days: 1));

      // Check for existing appointments with the same phone number on the same day
      final QuerySnapshot snapshot =
          await _firestore
              .collection('appointments')
              .where(
                'patientPhone',
                isEqualTo: patientPhoneController.text.trim(),
              )
              .where(
                'appointmentDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where('appointmentDate', isLessThan: Timestamp.fromDate(endDate))
              .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking existing appointments: $e');
      return false;
    }
  }

  // Book appointment
  Future<void> bookAppointment() async {
    try {
      if (!validateForm()) return;

      isLoading.value = true;

      // Check if user already has an appointment on this day
      bool hasAppointment = await hasExistingAppointment();
      if (hasAppointment) {
        Get.snackbar(
          'Booking Limit',
          'You already have an appointment scheduled for this day. Maximum one appointment per day is allowed.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        isLoading.value = false;
        return;
      }

      Timestamp now = Timestamp.now();

      // Get current user ID if logged in
      String? userId = _auth.currentUser?.uid;

      // Create appointment data
      final appointmentData = {
        'patientName': patientNameController.text.trim(),
        'patientPhone': patientPhoneController.text.trim(),
        'patientEmail': patientEmailController.text.trim(),
        'doctorId': selectedDoctor.value!.id,
        'doctorName': selectedDoctor.value!.name,
        'hospitalId': selectedHospital.value!.id,
        'hospitalName': selectedHospital.value!.name,
        'appointmentDate': Timestamp.fromDate(selectedDate.value!),
        'timeSlot': selectedTimeSlot.value,
        'status': 'pending',
        'notes': notesController.text.trim(),
        'createdAt': now,
        'updatedAt': now,
        'userId': userId ?? '', // Store user ID with appointment
      };

      // Add to Firestore
      await _firestore.collection('appointments').add(appointmentData);

      // Clear form
      clearForm();

      Get.snackbar(
        'Success',
        'Appointment booked successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to home screen
      Get.offAllNamed(AppRoutes.homeScreenView);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to book appointment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validate form fields
  bool validateForm() {
    if (patientNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }

    if (patientPhoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Please select a date');
      return false;
    }

    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar('Error', 'Please select a time slot');
      return false;
    }

    return true;
  }

  // Clear form fields
  void clearForm() {
    patientNameController.clear();
    patientPhoneController.clear();
    patientEmailController.clear();
    notesController.clear();
    selectedDate.value = null;
    selectedTimeSlot.value = '';
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
                  ),
            )
            .toList(),
      );
    }
  }

  // Fetch appointments for the current logged-in user
  Future<void> fetchUserAppointments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current user ID
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        Get.snackbar(
          'Not Logged In',
          'Please log in to view your appointments',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Query appointments for the current user
      final QuerySnapshot snapshot =
          await _firestore
              .collection('appointments')
              .where('userId', isEqualTo: currentUser.uid)
              .orderBy('appointmentDate', descending: true)
              .get();

      final List<Appointment> appointmentList =
          snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList();

      userAppointments.assignAll(appointmentList);
    } catch (e) {
      errorMessage.value = 'Failed to load appointments: $e';
      Get.snackbar(
        'Error',
        'Failed to load your appointments',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      isLoading.value = true;

      // Update appointment status to cancelled
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'updatedAt': Timestamp.now(),
      });

      // Refresh the user appointments list
      await fetchUserAppointments();

      Get.snackbar(
        'Success',
        'Appointment cancelled successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel appointment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
