class BloodHistoryModel {
  final String takername;
  final String takeremail;
  final String takerblood;
  final String takerimage;
  final String donorname;
  final String donoremail;
  final String donorblood;
  final String donorimage;

  BloodHistoryModel({
    required this.takername,
    required this.takeremail,
    required this.takerblood,
    required this.takerimage,
    required this.donorname,
    required this.donoremail,
    required this.donorblood,
    required this.donorimage,
  });

  factory BloodHistoryModel.fromMap(Map<String, dynamic> doc) {
    return BloodHistoryModel(
      takername: doc['takernaem'] ?? "",
      takeremail: doc['takeremail'] ?? "",
      takerblood: doc['takerblood'] ?? "",
      takerimage: doc['takerimage'] ?? "",
      donorname: doc['donorname'] ?? "",
      donoremail: doc['donoremail'] ?? "",
      donorblood: doc['donorblood'] ?? "",
      donorimage: doc['donorimage'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'takernaem': takername,
      'takeremail': takeremail,
      'takerblood': takerblood,
      'takerimage': takerimage,
      'donorname': donorname,
      'donoremail': donoremail,
      'donorblood': donorblood,
      'donorimage': donorimage,
    };
  }
}
