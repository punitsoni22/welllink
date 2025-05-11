import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final String phone;
  final String email;
  final String imageUrl;
  final String hospitalId;
  final String hospitalName;
  final bool isAvailable;
  final List<String> availableDays;
  final String experience;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.phone,
    required this.email,
    this.imageUrl = 'assets/images/doctor_placeholder.png',
    required this.hospitalId,
    required this.hospitalName,
    this.isAvailable = true,
    required this.availableDays,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      qualification: data['qualification'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? 'assets/images/doctor_placeholder.png',
      hospitalId: data['hospitalId'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      availableDays: List<String>.from(data['availableDays'] ?? []),
      experience: data['experience'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'isAvailable': isAvailable,
      'availableDays': availableDays,
      'experience': experience,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}