// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    this.success,
    this.message,
    this.averageRating,
    this.result,
  });

  bool success;
  String message;
  String averageRating;
  List<Result> result;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        success: json["success"],
        message: json["message"],
        averageRating: json["average_rating"],
        result:
            List<Result>.from(json["data"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "average_rating": averageRating,
        "data": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class PostReview {
  PostReview({
    this.status,
    this.data,
  });

  int status;
  Result data;

  factory PostReview.fromMap(Map<String, dynamic> json) => PostReview(
    status: json["status"],
    data: Result.fromJson(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Result {
  Result({
    this.id,
    this.osmUsername,
    this.rating,
    this.comments,
    this.serviceId,
    this.service,
    this.healthExpertise,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String osmUsername;
  int rating;
  String comments;
  String serviceId;
  dynamic service;
  dynamic healthExpertise;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        osmUsername: json["osm_username"],
        rating: json["rating"],
        comments: json["comments"],
        serviceId: json["service_id"],
        service: json["service"],
        healthExpertise: json["health_expertise"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "osm_username": osmUsername,
        "rating": rating,
        "comments": comments,
        "service_id": serviceId,
        "service": service,
        "health_expertise": healthExpertise,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
