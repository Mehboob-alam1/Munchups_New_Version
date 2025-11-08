class ChefOrdersResponse {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> orders;
  final List<Map<String, dynamic>> activeBulkOrders;
  final List<Map<String, dynamic>> completedBulkOrders;
  final Map<String, dynamic> raw;

  ChefOrdersResponse({
    required this.success,
    required this.message,
    required this.orders,
    required this.activeBulkOrders,
    required this.completedBulkOrders,
    required this.raw,
  });

  factory ChefOrdersResponse.fromJson(Map<String, dynamic> json) {
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

    return ChefOrdersResponse(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['msg']?.toString() ?? '',
      orders: _parseList(json['data']),
      activeBulkOrders: _parseList(json['oc_active_order_arr']),
      completedBulkOrders: _parseList(json['oc_complete_order_arr']),
      raw: json,
    );
  }
}

