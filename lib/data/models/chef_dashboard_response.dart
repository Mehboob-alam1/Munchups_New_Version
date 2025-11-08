class ChefDashboardResponse {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> occasions;
  final int notificationCount;
  final Map<String, dynamic> raw;

  ChefDashboardResponse({
    required this.success,
    required this.message,
    required this.occasions,
    required this.notificationCount,
    required this.raw,
  });

  factory ChefDashboardResponse.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> _parseList(dynamic value) {
      if (value is List) {
        return value
            .map((item) {
              if (item is Map<String, dynamic>) {
                return item;
              }
              if (item is Map) {
                return Map<String, dynamic>.from(item as Map);
              }
              return null;
            })
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      return <Map<String, dynamic>>[];
    }

    return ChefDashboardResponse(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['msg']?.toString() ?? '',
      occasions: _parseList(json['oc_category_order_arr']),
      notificationCount:
          int.tryParse(json['notification_count']?.toString() ?? '0') ?? 0,
      raw: json,
    );
  }
}

