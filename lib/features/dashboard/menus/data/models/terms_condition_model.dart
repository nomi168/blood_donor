class TermsConditionModel {
  final bool eligibility;
  final bool privacyPolicy;
  final bool donationProcess;
  final bool safety;
  final bool hygiene;
  final String userId;

  TermsConditionModel({
    required this.eligibility,
    required this.privacyPolicy,
    required this.donationProcess,
    required this.safety,
    required this.hygiene,
    required this.userId,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
      eligibility: json['eligibility'] ?? false,
      privacyPolicy: json['privacy_policy'] ?? false,
      donationProcess: json['donation_process'] ?? false,
      safety: json['safety'] ?? false,
      hygiene: json['hygiene'] ?? false,
      userId: json['user_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eligibility': eligibility,
      'privacy_policy': privacyPolicy,
      'donation_process': donationProcess,
      'safety': safety,
      'hygiene': hygiene,
      'user_id': userId,
    };
  }
}
