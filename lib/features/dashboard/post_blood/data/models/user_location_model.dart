class UserLocationModel {
  final String userId;
  final String userName;
  final String userLcoation;

  UserLocationModel(
      {required this.userId,
      required this.userName,
      required this.userLcoation});

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      userId: json['user_id'] ?? '',
      userName: json['donor_name'] ?? '',
      userLcoation: json['donor_location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'donor_name': userName,
      'donor_location': userLcoation,
    };
  }
}
