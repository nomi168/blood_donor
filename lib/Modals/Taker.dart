class Taker {
  final String id;
  final String? t_id;
  final String name;
  final String imageURL;
  final String blood;
  final String location;
  final String hospitaname;
  final String rating;
  final String time;
  final String date;
  final String note;
  final String email;
  final String number;
  final bool status;
  final String? tak_id;

  // Constructor
  Taker({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.blood,
    required this.location,
    required this.hospitaname,
    required this.rating,
    required this.time,
    required this.date,
    required this.note,
    required this.email,
    required this.number,
    required this.status,
    this.t_id,
    this.tak_id,
  });

  // Factory method to create an instance from JSON
  factory Taker.fromJson(Map<String, dynamic> json) {
    return Taker(
      id: json['id'],
      name: json['name'],
      imageURL: json['image'],
      blood: json['blood'],
      location: json['location'],
      hospitaname: json['hospitalname'],
      rating: json['rating'],
      time: json['time'],
      date: json['date'],
      note: json['note'],
      email: json['email'],
      number: json['number'],
      status: json['status'],
      t_id: json['t_id'],
      tak_id: json['taker_id'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'blood': blood,
      'location': location,
      'hospitaname': hospitaname,
      'rating': rating,
      'time': time,
      'date': date,
      'note': note,
      'email': email,
      'number': number,
      'status': status,
      't_id': t_id,
      'tak_id': tak_id,
    };
  }
}
