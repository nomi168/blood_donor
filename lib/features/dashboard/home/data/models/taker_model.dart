import 'package:cloud_firestore/cloud_firestore.dart';

class FeedTakerModel {
  String? takerId;
  String? email;
  String? name;
  String? number;
  String? image;
  String? hospitalName;
  String? bloodType;
  String? date;
  String? time;
  String? location;
  String? unit;
  String? note;
  String? blood;
  String? situation;
  String? rating;
  bool? status;
  String? createdAt;

  FeedTakerModel({
    this.takerId,
    this.email,
    this.name,
    this.number,
    this.image,
    this.hospitalName,
    this.bloodType,
    this.date,
    this.time,
    this.location,
    this.unit,
    this.note,
    this.blood,
    this.situation,
    this.rating,
    this.status,
    this.createdAt,
  });

  factory FeedTakerModel.fromJson(Map<String, dynamic> json) {
    return FeedTakerModel(
      takerId: json['taker_id'],
      email: json['email'],
      name: json['name'],
      number: json['number'],
      image: json['image'],
      hospitalName: json['hospitalname'],
      bloodType: json['blood_type'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      unit: json['unit'],
      note: json['note'],
      blood: json['blood'],
      situation: json['situation'],
      rating: json['rating'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate().toIso8601String()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taker_id': takerId,
      'email': email,
      'name': name,
      'number': number,
      'image': image,
      'hospitalname': hospitalName,
      'blood_type': bloodType,
      'date': date,
      'time': time,
      'location': location,
      'unit': unit,
      'note': note,
      'blood': blood,
      'situation': situation,
      'rating': rating,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
