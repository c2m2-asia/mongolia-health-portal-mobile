// To parse this JSON data, do
//
//     final resourcesResponse = resourcesResponseFromMap(jsonString);

import 'dart:convert';

ResourcesResponse resourcesResponseFromMap(String str) =>
    ResourcesResponse.fromMap(json.decode(str));

String resourcesResponseToMap(ResourcesResponse data) =>
    json.encode(data.toMap());

class ResourcesResponse {
  ResourcesResponse({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<Resource> data;

  factory ResourcesResponse.fromMap(Map<String, dynamic> json) =>
      ResourcesResponse(
        status: json["status"],
        message: json["message"],
        data: List<Resource>.from(json["data"].map((x) => Resource.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Resource {
  Resource({
    this.id,
    this.title,
    this.description,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String description;
  String link;
  DateTime createdAt;
  DateTime updatedAt;

  factory Resource.fromMap(Map<String, dynamic> json) => Resource(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        link: json["link"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "link": link,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
