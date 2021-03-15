// To parse this JSON data, do
//
//     final adminBoundaryResponse = adminBoundaryResponseFromMap(jsonString);

import 'dart:convert';

AdminBoundaryResponse adminBoundaryResponseFromMap(String str) =>
    AdminBoundaryResponse.fromMap(json.decode(str));

String adminBoundaryResponseToMap(AdminBoundaryResponse data) =>
    json.encode(data.toMap());

class AdminBoundaryResponse {
  AdminBoundaryResponse({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  List<AdminBoundary> data;

  factory AdminBoundaryResponse.fromMap(Map<String, dynamic> json) =>
      AdminBoundaryResponse(
        status: json["status"],
        message: json["message"],
        data: List<AdminBoundary>.from(
            json["data"].map((x) => AdminBoundary.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Division {
  Division({
    this.label,
    this.id,
    this.selector,
    this.divisions,
  });

  Label label;
  String id;
  String selector;
  List<AdminBoundary> divisions;

  factory Division.fromMap(Map<String, dynamic> json) => Division(
        label: Label.fromMap(json["label"]),
        id: json["id"],
        selector: json["selector"],
        divisions: List<AdminBoundary>.from(
            json["divisions"].map((x) => AdminBoundary.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "label": label.toMap(),
        "id": id,
        "selector": selector,
        "divisions": List<dynamic>.from(divisions.map((x) => x.toMap())),
      };
}

class AdminBoundary {
  AdminBoundary({
    this.label,
    this.id,
    this.selector,
    this.divisions,
  });

  String label;
  String id;
  Selector selector;
  List<Division> divisions;

  @override
  String toString() {
    return 'AdminBoundary{label: $label, id: $id, selector: $selector, divisions: $divisions}';
  }

  factory AdminBoundary.fromMap(Map<String, dynamic> json) => AdminBoundary(
        label: json["label"],
        id: json["id"],
        selector: selectorValues.map[json["selector"]],
        divisions: json["divisions"] == null
            ? null
            : List<Division>.from(
                json["divisions"].map((x) => Division.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "label": label,
        "id": id,
        "selector": selectorValues.reverse[selector],
        "divisions": divisions == null
            ? null
            : List<dynamic>.from(divisions.map((x) => x.toMap())),
      };
}

class Label {
  Label({
    this.mn,
    this.en,
  });

  String mn;
  String en;

  factory Label.fromMap(Map<String, dynamic> json) => Label(
        mn: json["mn"],
        en: json["en"],
      );

  Map<String, dynamic> toMap() => {
        "mn": mn,
        "en": en,
      };
}

enum Selector { CITY, KHOROO }

final selectorValues =
    EnumValues({"city": Selector.CITY, "khoroo": Selector.KHOROO});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
