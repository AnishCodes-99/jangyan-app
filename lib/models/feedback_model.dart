class FeedbackModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final int rating;
  final String category;
  final String message;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.rating,
    required this.category,
    required this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'rating': rating,
      'category': category,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return FeedbackModel(
      id: docId ?? map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Anonymous',
      userEmail: map['userEmail'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 5,
      category: map['category'] as String? ?? 'General',
      message: map['message'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
