
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodBank {
  final String name;
  final String email;
  final String contactNo;
  final String registrationNo;
  final String address;
  final String city;
  final String type;
  final bool availability;
  final DateTime createdAt;
  final List<BloodBankTiming> bloodBankTimings;

  BloodBank({
    required this.name,
    required this.email,
    required this.contactNo,
    required this.registrationNo,
    required this.address,
    required this.city,
    required this.type,
    required this.availability,
    required this.createdAt,
    required this.bloodBankTimings,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'contact_no': contactNo,
      'registration_no': registrationNo,
      'address': address,
      'city': city,
      'type': type,
      'availability': availability,
      'created_at': createdAt,
      'blood_bank_timings': bloodBankTimings.map((t) => t.toMap()).toList(),
    };
  }

  factory BloodBank.fromMap(Map<String, dynamic> map) {
    return BloodBank(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contactNo: map['contact_no'] ?? '',
      registrationNo: map['registration_no'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      type: map['type'] ?? '',
      availability: map['availability'] ?? false,
      createdAt: map['created_at'] is Timestamp
        ? (map['created_at'] as Timestamp).toDate()
        : (map['created_at'] is DateTime
            ? map['created_at']
            : DateTime.parse(map['created_at'].toString())),
      bloodBankTimings: (map['blood_bank_timings'] as List)
          .map((t) => BloodBankTiming.fromMap(t))
          .toList(),
    );
  }
}

class BloodBankTiming {
  final String day;
  final String openingTime;
  final String closingTime;

  BloodBankTiming({
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'opening_time': openingTime,
      'closing_time': closingTime,
    };
  }

  factory BloodBankTiming.fromMap(Map<String, dynamic> map) {
    return BloodBankTiming(
      day: map['day'] ?? '',
      openingTime: map['opening_time'] ?? '',
      closingTime: map['closing_time'] ?? '',
    );
  }
}
