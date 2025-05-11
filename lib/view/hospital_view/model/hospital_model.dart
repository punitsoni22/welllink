import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String imageUrl;
  final GeoPoint? location;
  final List<String> specialties;
  final int beds;
  final bool isGovernment;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.website = '',
    this.imageUrl = 'assets/images/hospital_placeholder.png',
    this.location,
    this.specialties = const [],
    this.beds = 0,
    this.isGovernment = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hospital.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Hospital(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      imageUrl: data['imageUrl'] ?? 'assets/images/hospital_placeholder.png',
      location: data['location'],
      specialties: List<String>.from(data['specialties'] ?? []),
      beds: data['beds'] ?? 0,
      isGovernment: data['isGovernment'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'imageUrl': imageUrl,
      'location': location,
      'specialties': specialties,
      'beds': beds,
      'isGovernment': isGovernment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}