// To parse this JSON data, do
//
//     final osmTags = osmTagsFromJson(jsonString);

import 'dart:convert';

import 'feature_tags.dart';

FilterTags osmTagsFromJson(String str) => FilterTags.fromJson(json.decode(str));

String osmTagsToJson(FilterTags data) => json.encode(data.toJson());

class FilterTags {
  FilterTags({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory FilterTags.fromJson(Map<String, dynamic> json) => FilterTags(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.label,
    this.value,
    this.filterTags,
  });

  String label;
  String value;
  List<EditTag> filterTags;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    label: json["label"],
    value: json["value"],
    filterTags: List<EditTag>.from(json["filterTags"].map((x) => EditTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "filterTags": List<dynamic>.from(filterTags.map((x) => x.toJson())),
  };
}
