class ChefFollowersEntity {
  final bool success;
  final String message;
  final int followersCount;
  final int followingCount;
  final List<Map<String, dynamic>> followers;
  final Map<String, dynamic> raw;

  const ChefFollowersEntity({
    required this.success,
    required this.message,
    required this.followersCount,
    required this.followingCount,
    required this.followers,
    required this.raw,
  });
}


