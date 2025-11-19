class ChefDashboardEntity {
  final bool success;
  final String message;
  final List<Map<String, dynamic>> occasions;
  final int notificationCount;
  final Map<String, dynamic> raw;

  const ChefDashboardEntity({
    required this.success,
    required this.message,
    required this.occasions,
    required this.notificationCount,
    required this.raw,
  });
}


