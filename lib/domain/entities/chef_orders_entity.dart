class ChefOrdersEntity {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> orders;
  final List<Map<String, dynamic>> activeBulkOrders;
  final List<Map<String, dynamic>> completedBulkOrders;
  final Map<String, dynamic> raw;

  const ChefOrdersEntity({
    required this.success,
    required this.message,
    required this.orders,
    required this.activeBulkOrders,
    required this.completedBulkOrders,
    required this.raw,
  });
}


