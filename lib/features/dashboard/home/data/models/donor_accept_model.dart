class DonateAcceptModel {
  final String id;
  final String takerId;
  final String fullname;
  final String image;
  final String email;
  final String hospitalName;
  final String date;
  final String time;
  final String location;
  final String note;
  final String blood;
  final String bloodImage;
  final String unit;
  final String phoneNumber;
  final String situation;
  final String bloodType;
  final String donorName;
  final String donorEmail;
  final String donorNumber;
  final String donorImage;
  final String donorBlood;
  final bool status;
  final bool receivedStatus;
  final bool takerReceivedStatus;

  DonateAcceptModel({
    required this.id,
    required this.takerId,
    required this.fullname,
    required this.image,
    required this.email,
    required this.hospitalName,
    required this.date,
    required this.time,
    required this.location,
    required this.note,
    required this.blood,
    required this.bloodImage,
    required this.unit,
    required this.phoneNumber,
    required this.situation,
    required this.bloodType,
    required this.donorName,
    required this.donorEmail,
    required this.donorNumber,
    required this.donorImage,
    required this.donorBlood,
    required this.status,
    required this.receivedStatus,
    required this.takerReceivedStatus,
  });

  factory DonateAcceptModel.fromJson(Map<String, dynamic> json) {
    return DonateAcceptModel(
        id: json['id'] ?? '',
        takerId: json['takerid'] ?? '',
        fullname: json['fullname'] ?? '',
        image: json['image'] ?? '',
        email: json['email'] ?? '',
        hospitalName: json['hospitalname'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        location: json['location'] ?? '',
        note: json['note'] ?? '',
        blood: json['blood'] ?? '',
        bloodImage: json['blood_image'],
        unit: json['unit'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        situation: json['situation'] ?? '',
        bloodType: json['bloodtype'] ?? '',
        donorName: json['donor_name'] ?? '',
        donorEmail: json['donor_email'] ?? '',
        donorNumber: json['donor_number'] ?? '',
        donorImage: json['donor_image'] ?? '',
        donorBlood: json['donor_blood'] ?? '',
        status: json['status'] ?? false,
        receivedStatus: json['received_status'] ?? false,
        takerReceivedStatus: json['taker_received_status'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'takerid': takerId,
      'fullname': fullname,
      'image': image,
      'email': email,
      'hospitalname': hospitalName,
      'date': date,
      'time': time,
      'location': location,
      'note': note,
      'blood': blood,
      'blood_image':bloodImage,
      'unit': unit,
      'phone_number': phoneNumber,
      'situation': situation,
      'bloodtype': bloodType,
      'donor_name': donorName,
      'donor_email': donorEmail,
      'donor_number': donorNumber,
      'donor_image': donorImage,
      'donor_blood': donorBlood,
      'status': status,
      'received_status': receivedStatus,
      'taker_received_status': takerReceivedStatus
    };
  }
}
