class ChatAcceptModel {
  String id;
  String takerId;
  String takerNumber;
  String takerEmail;
  String takerImage;
  String takerName;
  String date;
  String time;
  String donorId;
  String donorNumber;
  String donorEmail;
  String donorName;
  String donorImage;

  ChatAcceptModel({
    required this.id,
    required this.takerId,
    required this.takerNumber,
    required this.takerEmail,
    required this.takerImage,
    required this.takerName,
    required this.date,
    required this.time,
    required this.donorId,
    required this.donorNumber,
    required this.donorEmail,
    required this.donorName,
    required this.donorImage,
  });

  factory ChatAcceptModel.fromJson(Map<String, dynamic> json) {
    return ChatAcceptModel(
      id: json['id'] ?? '',
      takerId: json['taker_id'] ?? '',
      takerNumber: json['taker_number'] ?? '',
      takerEmail: json['taker_email'] ?? '',
      takerImage: json['taker_image'] ?? '',
      takerName: json['taker_name'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      donorId: json['donor_id'] ?? '',
      donorNumber: json['donor_number'] ?? '',
      donorEmail: json['donor_email'] ?? '',
      donorName: json['donor_name'] ?? '',
      donorImage: json['donor_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taker_id': takerId,
      'taker_number': takerNumber,
      'taker_email': takerEmail,
      'taker_image': takerImage,
      'taker_name': takerName,
      'date': date,
      'time': time,
      'donor_id': donorId,
      'donor_number': donorNumber,
      'donor_email': donorEmail,
      'donor_name': donorName,
      'donor_image': donorImage,
    };
  }
}
