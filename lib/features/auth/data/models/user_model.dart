class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String image;
  final String email;
  final String phonenumber;
  final String gender;
  final String location;
  final String password;
  final bool status;
  final String type;
  final String deviceToken;
  final bool availabledonate;
  final String bloodgroup;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.image,
    required this.email,
    required this.phonenumber,
    required this.gender,
    required this.location,
    required this.password,
    required this.status,
    required this.type,
    required this.deviceToken,
    required this.availabledonate,
    required this.bloodgroup,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      password: json['password'] ?? '',
      status: json['status'] ?? false,
      type: json['type'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
      availabledonate: json['availabledonate'] ?? false,
      bloodgroup: json['bloodgroup'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'image': image,
      'email': email,
      'phonenumber': phonenumber,
      'gender': gender,
      'location': location,
      'password': password,
      'status': status,
      'type': type,
      'deviceToken': deviceToken,
      'availabledonate': availabledonate,
      'bloodgroup': bloodgroup,
    };
  }
}
