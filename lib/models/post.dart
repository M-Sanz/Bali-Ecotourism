import 'review.dart'; // Import the Review model

class Post {
  final int id;
  final String type;
  final String title;
  final String? featuredImageUrl;
  final String location;
  final ReviewSummary? reviewSummary;
  final String description;
  final List<Review>? reviews; // Make reviews nullable
  final List<String>? galleryImages;
  final String iframe;
  final double? latitude;
  final double? longitude;
  bool isBookmarked;

  Post(
      {required this.id,
      required this.type,
      required this.title,
      required this.location,
      this.featuredImageUrl,
      this.reviewSummary,
      required this.description,
      this.reviews, // Optional reviews in constructor
      this.galleryImages,
      required this.isBookmarked,
      required this.iframe,
      required this.latitude,
      required this.longitude});

  Post copyWith({
    int? id,
    String? type,
    String? title,
    String? featuredImageUrl,
    String? location,
    ReviewSummary? reviewSummary,
    String? description,
    List<Review>? reviews,
    List<String>? galleryImages,
    String? iframe,
    double? latitude,
    double? longitude,
    bool? isBookmarked,
  }) {
    return Post(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      location: location ?? this.location,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      reviewSummary: reviewSummary ?? this.reviewSummary,
      description: description ?? this.description,
      reviews: reviews ?? this.reviews,
      galleryImages: galleryImages ?? this.galleryImages,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      iframe: iframe ?? this.iframe,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final codeParts = (json['code'] as String? ?? '').split(',');
    double latitude = 0.0;
    double longitude = 0.0;

    if (codeParts.length >= 2) {
      latitude = double.tryParse(codeParts[0]) ?? 0.0;
      longitude = double.tryParse(codeParts[1]) ?? 0.0;
    }

    return Post(
        id: json['id'] as int? ?? 0,
        type: (json['type'] as String? ?? '').trim(),
        title: _parseTitle(json['title']),
        location: (json['map_section_title'] as String? ?? '').trim(),
        featuredImageUrl: _parseFeaturedImageUrl(json['featured_image']),
        reviewSummary: _parseReviewSummary(json['review_summary']),
        description: _cleanDescription(json['description']),
        reviews: _parseReviews(json['reviews']),
        galleryImages: _parseGalleryImages(json['attachment_urls']),
        isBookmarked: json['is_bookmarked'] as bool? ?? false,
        iframe: (json['iframe'] as String? ?? '').trim(),
        longitude: longitude,
        latitude: latitude);
  }

  static List<String>? _parseGalleryImages(dynamic attachments) {
    if (attachments is List) {
      return attachments.map((url) => url as String).toList();
    }
    return null;
  }

  static String _parseTitle(dynamic titleData) {
    if (titleData is Map<String, dynamic>) {
      return (titleData['rendered'] as String? ?? '').trim();
    }
    return '';
  }

  static String? _parseFeaturedImageUrl(dynamic imageData) {
    if (imageData is Map<String, dynamic>) {
      final sizes = imageData['sizes'];
      if (sizes is Map<String, dynamic>) {
        final full = sizes['full'];
        if (full is Map<String, dynamic>) {
          return full['source_url'] as String?;
        }
      }
    }
    return null;
  }

  static ReviewSummary? _parseReviewSummary(dynamic reviewData) {
    if (reviewData is Map<String, dynamic>) {
      return ReviewSummary.fromJson(reviewData);
    }
    return null;
  }

  static List<Review>? _parseReviews(dynamic reviewsData) {
    if (reviewsData is List) {
      return reviewsData.map((review) => Review.fromJson(review)).toList();
    }
    return null; // Return null if no reviews are found
  }

  static String _cleanDescription(dynamic description) {
    final desc = (description as String? ?? '');
    return desc
        .replaceAll(RegExp(r'<!--.*?-->'), '') // Remove all HTML comments
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove all HTML tags
        .replaceAll(RegExp(r'\s+'), ' ') // Collapse multiple whitespaces
        .trim();
  }
}

class ReviewSummary {
  final double averageRating;
  final int reviewCount;

  ReviewSummary({
    required this.averageRating,
    required this.reviewCount,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as int?) ?? 0,
    );
  }
}
