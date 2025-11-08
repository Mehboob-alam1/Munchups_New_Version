class HomeDataModel {
  final bool success;
  final String message;
  final List<dynamic> chefs;
  final List<dynamic> grocers;
  final Map<String, dynamic> raw;

  HomeDataModel({
    required this.success,
    required this.message,
    required this.chefs,
    required this.grocers,
    required this.raw,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final bool isSuccess = json['success']?.toString().toLowerCase() == 'true';
    final String message = json['msg']?.toString() ?? '';

    List<dynamic> _parseList(dynamic value) {
      if (value == null || value == 'NA') {
        return <dynamic>[];
      }
      if (value is List) {
        return value;
      }
      return <dynamic>[];
    }

    // The API sometimes returns `all_grocery` or `all_grocer`.
    final List<dynamic> grocerList = _parseList(
      json['all_grocery'] ?? json['all_grocer'],
    );

    return HomeDataModel(
      success: isSuccess,
      message: message,
      chefs: _parseList(json['all_chef']),
      grocers: grocerList,
      raw: json,
    );
  }
}
