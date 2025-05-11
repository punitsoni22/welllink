import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/routes/app_routes.dart';
import 'package:welllink/utils/constant/prefs.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLogin = false.obs;
  var isLoading = false.obs;
  var isTermsAccepted = false.obs;
  var userRole = ''.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Prefs _prefs = Prefs();

  @override
  void onInit() async {
    super.onInit();
    emailController.text = '';
    passwordController.text = '';
    nameController.text = '';
    isTermsAccepted.value = false;
    userRole.value = '';

    // Initialize Prefs and load saved role
    await _prefs.init();
    userRole.value = _prefs.get();
  }

  Future<void> login() async {
    try {
      isLogin.value = true;
      isLoading.value = true;

      // Validation
      if (emailController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter an email address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (passwordController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter a password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Firebase login
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Fetch user role from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc.get('role') ?? 'user';
          if (role != 'user' && role != 'admin') {
            role = 'user'; // Default to user if role is invalid
          }
          // Save role using Prefs
          await _prefs.save(role);
          userRole.value = role;

          Get.snackbar(
            'Success',
            'Logged in successfully as $role',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          Get.offAllNamed(AppRoutes.homeScreenView);
        } else {
          Get.snackbar(
            'Error',
            'User data not found',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
      }
      Get.snackbar(
        'Login Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLogin.value = false;
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      if (!isTermsAccepted.value) {
        Get.snackbar(
          'Error',
          'Please accept the Terms of Service and Privacy Policy',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Validation
      if (nameController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your name',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (emailController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter an email address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (passwordController.text.trim().length < 6) {
        Get.snackbar(
          'Error',
          'Password must be at least 6 characters',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Firebase registration
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Update user display name
        await userCredential.user!
            .updateDisplayName(nameController.text.trim());

        // Create user document in Firestore
        String uuid = userCredential.user!.uid;
        Timestamp now = Timestamp.now();
        String role = 'user'; // Default role for new users

        await _firestore.collection('users').doc(uuid).set({
          'uuid': uuid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': role,
          'createdAt': now,
          'updatedAt': now,
        });

        // Save role using Prefs
        await _prefs.save(role);
        userRole.value = role;

        Get.snackbar(
          'Success',
          'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed(AppRoutes.homeScreenView);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
      }
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}