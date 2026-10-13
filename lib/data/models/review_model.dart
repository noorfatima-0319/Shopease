// A real review attached to a product, as returned by the API.
// Never fabricated in-app.
class ReviewModel {
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewerName: (json['reviewerName'] as String?) ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: (json['comment'] as String?) ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
