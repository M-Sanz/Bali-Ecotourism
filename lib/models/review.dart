class Review {
  final String username;
  final int rating;
  final String comment;
  final String date; // This will now only store the date
  final List<int>? assignedPosts;
  final String? title;

  Review(
      {required this.username,
      required this.rating,
      required this.comment,
      required this.date,
      this.assignedPosts,
      this.title});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['author']['name'] as String, // Match the JSON structure
      rating: json['rating'] as int,
      comment: json['content'] as String,
      date: _parseDate(json['date']
          as String), // Parse the date to extract only the date part
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': "title",
      'content': comment,
      'rating': rating,
      'assigned_posts':
          assignedPosts ?? [], // Include assigned posts in the JSON
    };
  }

  // A helper method to format the date to 'YYYY-MM-DD'
  static String _parseDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return '';
    }
  }
}

class CreateReviewResponse {
  final bool success;
  final String message;
  final int? reviewId;
  final Map<String, dynamic>? review;

  CreateReviewResponse({
    required this.success,
    required this.message,
    this.reviewId,
    this.review,
  });

  factory CreateReviewResponse.fromJson(Map<String, dynamic> json) {
    return CreateReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error occurred',
      reviewId: json['review_id'],
      review: json['review'],
    );
  }
}
