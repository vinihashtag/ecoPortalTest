import 'dart:convert';

class MovieModel {
  final String id;
  final String imgUrl;
  final String title;
  final DateTime releaseDate;
  final String nodeId;

  MovieModel({
    required this.id,
    required this.imgUrl,
    required this.title,
    required this.releaseDate,
    required this.nodeId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'imgUrl': imgUrl});
    result.addAll({'title': title});
    result.addAll({'releaseDate': releaseDate.toIso8601String()});
    result.addAll({'nodeId': nodeId});

    return result;
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      title: map['title'] ?? '',
      releaseDate: DateTime.tryParse(map['releaseDate']) ?? DateTime.now(),
      nodeId: map['nodeId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source) => MovieModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MovieModel(id: $id, imgUrl: $imgUrl, title: $title, releaseDate: $releaseDate, nodeId: $nodeId)';
  }
}
