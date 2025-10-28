class LocationUpdateModel {
  final String takerEmail;
  final String donorEmail;
  final String id;
  final double latitude;
  final double longitude;

  LocationUpdateModel({
    required this.takerEmail,
    required this.donorEmail,
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  /// Convert model to JSON (for sending in API)
  Map<String, dynamic> toJson() {
    return {
      'taker_email': takerEmail,
      'donor_email': donorEmail,
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Create model from JSON (optional, for reading response)
  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) {
    return LocationUpdateModel(
      takerEmail: json['taker_email'] ?? '',
      donorEmail: json['donor_email'] ?? '',
      id: json['id'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
