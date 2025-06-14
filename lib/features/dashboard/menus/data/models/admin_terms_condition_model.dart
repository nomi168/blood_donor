class AdminTermsconditionModel {
  final int id;
  final String termsCondition;

  AdminTermsconditionModel({
    required this.id,
    required this.termsCondition,
  });

  factory AdminTermsconditionModel.fromJson(Map<String, dynamic> json) {
    return AdminTermsconditionModel(
      id: json['id'] ?? '',
      termsCondition: json['terms_condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'terms_condition': termsCondition,
    };
  }
}
