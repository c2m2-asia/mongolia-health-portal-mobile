// To parse this JSON data, do
//
//     final osmTags = osmTagsFromJson(jsonString);

import 'dart:convert';

OsmTags osmTagsFromJson(String str) => OsmTags.fromJson(json.decode(str));

String osmTagsToJson(OsmTags data) => json.encode(data.toJson());

class OsmTags {
  OsmTags({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory OsmTags.fromJson(Map<String, dynamic> json) => OsmTags(
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
  Datum({this.label, this.value, this.editTags, this.labelLocale});

  String label;
  String value;
  List<EditTag> editTags;
  LabelLocale labelLocale;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        label: json["label"],
        value: json["value"],
        editTags: List<EditTag>.from(
            json["editTags"].map((x) => EditTag.fromJson(x))),
        labelLocale: LabelLocale.fromJson(json["labelLocale"]),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "editTags": List<dynamic>.from(editTags.map((x) => x.toJson())),
        "labelLocale": labelLocale.toJson(),
      };
}

class EditTag {
  EditTag({
    this.osmTag,
    this.isEditable,
    this.label,
    this.type,
    this.helperText,
    this.selectors,
    this.labelLocale,
  });

  String osmTag;
  IsEditable isEditable;
  String label;
  Type type;
  String helperText;
  List<Selector> selectors;
  LabelLocale labelLocale;

  factory EditTag.fromJson(Map<String, dynamic> json) => EditTag(
        osmTag: json["osm_tag"],
        isEditable: isEditableValues.map[json["isEditable"]],
        label: json["label"],
        type: typeValues.map[json["type"]],
        helperText: json["helperText"],
        selectors: json["selectors"] == null
            ? null
            : List<Selector>.from(
                json["selectors"].map((x) => Selector.fromJson(x))),
        labelLocale: LabelLocale.fromJson(json["labelLocale"]),
      );

  Map<String, dynamic> toJson() => {
        "osm_tag": osmTag,
        "isEditable": isEditableValues.reverse[isEditable],
        "label": label,
        "type": typeValues.reverse[type],
        "helperText": helperText,
        "selectors": selectors == null
            ? null
            : List<dynamic>.from(selectors.map((x) => x.toJson())),
        "labelLocale": labelLocale.toJson(),
      };
}

class LabelLocale {
  LabelLocale({
    this.en,
    this.mn,
  });

  String en;
  String mn;

  factory LabelLocale.fromJson(Map<String, dynamic> json) => LabelLocale(
        en: json["en"],
        mn: json["mn"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "mn": mn == null ? en : mn,
      };
}

enum IsEditable { TRUE, FALSE }

final isEditableValues =
    EnumValues({"False": IsEditable.FALSE, "True": IsEditable.TRUE});

class Selector {
  Selector({this.osmValue, this.label, this.labelLocale});

  String osmValue;
  String label;
  bool isChecked = false;
  LabelLocale labelLocale;

  factory Selector.fromJson(Map<String, dynamic> json) => Selector(
        osmValue: json["osm_value"],
        label: json["label"],
        labelLocale: LabelLocale.fromJson(json["labelLocale"]),
      );

  Map<String, dynamic> toJson() => {
        "osm_value": osmValue,
        "label": label,
        "labelLocale": labelLocale == null ? label : labelLocale.toJson(),
      };

  @override
  String toString() {
    return 'Selector{osmValue: $osmValue, label: $label, isChecked: $isChecked}';
  }
}

enum Type { TEXT, MULTI_SELECT, SINGLE_SELECT }

final typeValues = EnumValues({
  "multi-select": Type.MULTI_SELECT,
  "single-select": Type.SINGLE_SELECT,
  "text": Type.TEXT
});

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
