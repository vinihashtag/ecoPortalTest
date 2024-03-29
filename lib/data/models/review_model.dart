import 'dart:convert';

class ReviewModel {
  String id;
  String title;
  String body;
  String movieId;
  String nodeId;
  num rating;
  String userReviewerId;

  ReviewModel({
    required this.id,
    required this.title,
    required this.body,
    required this.movieId,
    required this.nodeId,
    required this.rating,
    required this.userReviewerId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'movieId': movieId});
    result.addAll({'nodeId': nodeId});
    result.addAll({'rating': rating});
    result.addAll({'userReviewerId': userReviewerId});

    return result;
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      movieId: map['movieId'] ?? '',
      nodeId: map['nodeId'] ?? '',
      rating: map['rating'] ?? 0,
      userReviewerId: map['userReviewerId'] ?? '',
    );
  }

  factory ReviewModel.empty() =>
      ReviewModel(body: '', id: '', movieId: '', nodeId: '', rating: 0, title: '', userReviewerId: '');

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) => ReviewModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.movieId == movieId &&
        other.nodeId == nodeId &&
        other.rating == rating &&
        other.userReviewerId == userReviewerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        movieId.hashCode ^
        nodeId.hashCode ^
        rating.hashCode ^
        userReviewerId.hashCode;
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, title: $title, body: $body, movieId: $movieId, nodeId: $nodeId, rating: $rating, userReviewerId: $userReviewerId)';
  }
}
