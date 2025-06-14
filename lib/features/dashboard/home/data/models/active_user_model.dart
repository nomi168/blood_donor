import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveUserModel {
  final String email;
  final Timestamp today;

  ActiveUserModel({
    required this.email,
    required this.today,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      email: json['email'] ?? '',
      today: json['today'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'today': today,
    };
  }
}
