class ProviderProfile {
  final String id;
  final String userId;
  final String name;
  final String? serviceCategory;
  final int? experience;
  final String? address;
  final String verificationStatus;
  final bool availability;
  final double rating;
  final int reviewsCount;

  ProviderProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.verificationStatus,
    required this.availability,
    required this.rating,
    required this.reviewsCount,
    this.serviceCategory,
    this.experience,
    this.address,
  });

  /// A friendly fallback for display when the provider hasn't set a
  /// service category yet (e.g. right after signup).
  String get displayRole => serviceCategory?.isNotEmpty == true ? serviceCategory! : 'Service Provider';

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      name: json['name'] as String,
      serviceCategory: json['service_category'] as String?,
      experience: json['experience'] as int?,
      address: json['address'] as String?,
      verificationStatus: json['verification_status'] as String,
      availability: json['availability'] as bool,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
    );
  }
}
