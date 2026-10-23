class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String? photoUrl;
  final bool isAdmin;
  final int attemptedCount;
  final int correctCount;
  final int incorrectCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.isAdmin = false,
    this.attemptedCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get accuracy {
    if (attemptedCount == 0) return 0.0;
    return (correctCount / attemptedCount) * 100.0;
  }

  String get proficiencyBadge {
    if (attemptedCount < 10) return 'New Learner';
    final acc = accuracy;
    if (acc >= 90) return 'Citizen Champion 🌟';
    if (acc >= 75) return 'Civic Scholar 🏅';
    if (acc >= 50) return 'Aware Citizen 🎖️';
    return 'Active Learner 📚';
  }

  UserProfile copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? photoUrl,
    bool clearPhotoUrl = false,
    bool? isAdmin,
    int? attemptedCount,
    int? correctCount,
    int? incorrectCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
      isAdmin: isAdmin ?? this.isAdmin,
      attemptedCount: attemptedCount ?? this.attemptedCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'isAdmin': isAdmin,
      'attemptedCount': attemptedCount,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return UserProfile(
      uid: documentId ?? map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? 'JanGyan Citizen',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      isAdmin: map['isAdmin'] as bool? ?? false,
      attemptedCount: (map['attemptedCount'] as num?)?.toInt() ?? 0,
      correctCount: (map['correctCount'] as num?)?.toInt() ?? 0,
      incorrectCount: (map['incorrectCount'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
