class ChefFollowersResponse {
  final bool success;
  final String message;
  final int followersCount;
  final int followingCount;
  final List<Map<String, dynamic>> followers;
  final Map<String, dynamic> raw;

  ChefFollowersResponse({
    required this.success,
    required this.message,
    required this.followersCount,
    required this.followingCount,
    required this.followers,
    required this.raw,
  });

  factory ChefFollowersResponse.fromJson(Map<String, dynamic> json) {
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

    return ChefFollowersResponse(
      success: json['success']?.toString().toLowerCase() == 'true',
      message: json['msg']?.toString() ?? '',
      followersCount:
          int.tryParse(json['followers_count']?.toString() ?? '0') ?? 0,
      followingCount:
          int.tryParse(json['following_counts']?.toString() ?? '0') ?? 0,
      followers: _parseList(json['followers_details']),
      raw: json,
    );
  }
}


