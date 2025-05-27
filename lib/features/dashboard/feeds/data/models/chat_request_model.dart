import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRequestModel {
  final String? senderId;
  final String? senderEmail;
  final String? senderName;
  final String? senderNumber;
  final String? recipientEmail;
  final String? recipientNumber;
  final String? receiverImage;
  final String? receiverId;
  final String? name;
  final String? image;
  final String? status;
  final Timestamp? timestamp;

  ChatRequestModel({
    this.senderId,
    this.senderEmail,
    this.senderName,
    this.senderNumber,
    this.recipientEmail,
    this.recipientNumber,
    this.receiverImage,
    this.receiverId,
    this.name,
    this.image,
    this.status,
    this.timestamp,
  });

  factory ChatRequestModel.fromJson(Map<String, dynamic> json) {
    return ChatRequestModel(
      senderId: json['sender_id'],
      senderEmail: json['senderEmail'],
      senderName: json['senderName'],
      senderNumber: json['senderNumber'],
      recipientEmail: json['recipientEmail'],
      recipientNumber: json['recipientNumber'],
      receiverImage: json['receiverimage'],
      receiverId: json['receiver_id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'senderNumber': senderNumber,
      'recipientEmail': recipientEmail,
      'recipientNumber': recipientNumber,
      'receiverimage': receiverImage,
      'receiver_id': receiverId,
      'name': name,
      'image': image,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
