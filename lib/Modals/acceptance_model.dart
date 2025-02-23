// class AcceptanceModel {
//   final int? id;
//   final String name

// }
class AcceptanceModel {
  final String? name;
  final String? hospital;
  final String? blood;
  final String? date;
  final String? time;
  final String? location;
  final String? rating;
  final int? id;
  final String? note;
  final String? image;
  final String? email;
  final String? acceptName;
  final String? acceptEmail;
  final String? acceptImage;
  final String? acceptBlood;
  final String? acceptRating;
  final int? acceptNumber;
  final String? takerId;
  final String? date1;
  final String? time1;
  final bool? status;

  AcceptanceModel({
    this.name,
    this.hospital,
    this.blood,
    this.date,
    this.time,
    this.location,
    this.rating,
    this.id,
    this.note,
    this.image,
    this.email,
    this.acceptName,
    this.acceptEmail,
    this.acceptImage,
    this.acceptBlood,
    this.acceptRating,
    this.acceptNumber,
    this.takerId,
    this.date1,
    this.time1,
    this.status,
  });

  factory AcceptanceModel.fromMap(Map<String, dynamic> userDoc) {
    return AcceptanceModel(
      name: userDoc['fullname'],
      hospital: userDoc['hospitalname'],
      blood: userDoc['blood'],
      date: userDoc['date'],
      time: userDoc['time'],
      location: userDoc['location'],
      rating: userDoc['rating'],
      id: userDoc['id'],
      note: userDoc['note'],
      image: userDoc['image'],
      email: userDoc['email'],
      acceptName: userDoc['acceptname'],
      acceptEmail: userDoc['acceptemail'],
      acceptImage: userDoc['acceptimage'],
      acceptBlood: userDoc['acceptblood'],
      acceptRating: userDoc['acceptrating'],
      acceptNumber: userDoc['acceptnumber'],
      takerId: userDoc['takerid'],
      date1: userDoc['date1'],
      time1: userDoc['time1'],
      status: userDoc['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': name,
      'hospitalname': hospital,
      'blood': blood,
      'date': date,
      'time': time,
      'location': location,
      'rating': rating,
      'id': id,
      'note': note,
      'image': image,
      'email': email,
      'acceptname': acceptName,
      'acceptemail': acceptEmail,
      'acceptimage': acceptImage,
      'acceptblood': acceptBlood,
      'acceptrating': acceptRating,
      'acceptnumber': acceptNumber,
      'takerid': takerId,
      'date1': date1,
      'time1': time1,
      'status': status,
    };
  }
}
