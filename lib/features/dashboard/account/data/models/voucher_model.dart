class VoucherModel {
  final String id;
  final String name;
  final String email;
  final String number;
  final String image;
  final String blood;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String designName;
  final String designPath;
  final bool isUsed;

  VoucherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.image,
    required this.blood,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.designName,
    required this.designPath,
    required this.isUsed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'image': image,
      'blood': blood,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'design_name': designName,
      'design_path': designPath,
      'is_used': isUsed,
    };
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      number: map['number'] ?? '',
      image: map['image'] ?? '',
      blood: map['blood'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: (map['start_date'] is DateTime)
          ? map['start_date']
          : DateTime.tryParse(map['start_date'].toString()) ?? DateTime.now(),
      endDate: (map['end_date'] is DateTime)
          ? map['end_date']
          : DateTime.tryParse(map['end_date'].toString()) ?? DateTime.now(),
      designName: map['design_name'] ?? '',
      designPath: map['design_path'] ?? '',
      isUsed: map['is_used'] ?? false,
    );
  }
}
