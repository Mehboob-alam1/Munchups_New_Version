class AppContentModel {
  final bool success;
  final String message;
  final String termsConditions;
  final String privacyPolicy;
  final String aboutUs;

  AppContentModel({
    required this.success,
    required this.message,
    required this.termsConditions,
    required this.privacyPolicy,
    required this.aboutUs,
  });

  factory AppContentModel.fromJson(Map<String, dynamic> json) {
    return AppContentModel(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['msg']?.toString() ?? '',
      termsConditions: json['terms_conditions']?.toString() ?? '',
      privacyPolicy: json['privacy_policy']?.toString() ?? '',
      aboutUs: json['about_us']?.toString() ?? '',
    );
  }
}

