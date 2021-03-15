import 'dart:convert';

import 'feature_response.dart';

SearchResponse searchResponseFromMap(String str) => SearchResponse.fromMap(json.decode(str));

String searchResponseToMap(SearchResponse data) => json.encode(data.toMap());

class SearchResponse {
  SearchResponse({
    this.status,
    this.message,
    this.result,
  });

  int status;
  String message;
  List<SearchItem> result;

  factory SearchResponse.fromMap(Map<String, dynamic> json) => SearchResponse(
    status: json["status"],
    message: json["message"],
    result: List<SearchItem>.from(json["data"].map((x) => SearchItem.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}
List<SearchItem> searchResponseFromJson(String str) =>
    List<SearchItem>.from(
        json.decode(str).map((x) => SearchItem.fromJson(x)));

String searchResponseToJson(List<SearchItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchItem {
  bool success;
  int id;
  Geometries geometries;
  List<String> service;
  List<String> category;
  List<String> speciality;

  SearchItem(
      {this.success,
      this.id,
      this.geometries,
      this.service,
      this.category,
      this.speciality});

  SearchItem.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    id = json['id'];
    geometries = json['geometries'] != null
        ? new Geometries.fromJson(json['geometries'])
        : null;
    service = List<String>.from(json["service"].map((x) => x));
    category = List<String>.from(json["category"].map((x) => x));
    speciality = List<String>.from(json["speciality"].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['id'] = this.id;
    if (this.geometries != null) {
      data['geometries'] = this.geometries.toJson();
    }
    data['service'] = this.service;
    data['category'] = this.category;
    data['speciality'] = this.speciality;
    return data;
  }

  @override
  String toString() {
    return 'SearchResponse{success: $success, id: $id, geometries: $geometries, service: $service, category: $category, speciality: $speciality}';
  }
}

class Geometries {
  String type;
  Properties properties;
  Geometry geometry;

  Geometries({this.type, this.properties, this.geometry});

  Geometries.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    return data;
  }
}

class Properties {
  String type;
  String id;
  Tags tags;

  Properties({this.type, this.id, this.tags});

  Properties.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.tags != null) {
      data['tags'] = this.tags.toJson();
    }
    return data;
  }
}
