class FaqModel {
  final bool success;
  final String message;
  final String faq;

  FaqModel({
    required this.success,
    required this.message,
    required this.faq,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['msg']?.toString() ?? '',
      faq: json['faq']?.toString() ?? '',
    );
  }
}
