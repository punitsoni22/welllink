import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String patientName;
  final String patientPhone;
  final String patientEmail;
  final String doctorId;
  final String doctorName;
  final String hospitalId;
  final String hospitalName;
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String notes;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.patientEmail,
    required this.doctorId,
    required this.doctorName,
    required this.hospitalId,
    required this.hospitalName,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      patientPhone: data['patientPhone'] ?? '',
      patientEmail: data['patientEmail'] ?? '',
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      hospitalId: data['hospitalId'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      appointmentDate: (data['appointmentDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      status: data['status'] ?? 'pending',
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'patientPhone': patientPhone,
      'patientEmail': patientEmail,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'timeSlot': timeSlot,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}