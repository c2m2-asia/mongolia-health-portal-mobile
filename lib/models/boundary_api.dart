// To parse this JSON data, do
//
//     final boundary = boundaryFromJson(jsonString);

import 'dart:convert';

Boundary boundaryFromJson(String str) => Boundary.fromJson(json.decode(str));

String boundaryToJson(Boundary data) => json.encode(data.toJson());

class Boundary {
  Boundary({
    this.type,
    this.geometry,
    this.properties,
  });

  String type;
  Geometry geometry;
  Properties properties;

  factory Boundary.fromJson(Map<String, dynamic> json) => Boundary(
    type: json["type"],
    geometry: Geometry.fromJson(json["geometry"]),
    properties: Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "geometry": geometry.toJson(),
    "properties": properties.toJson(),
  };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<List<List<double>>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<List<List<double>>>.from(json["coordinates"].map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble())))))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
  };
}

class Properties {
  Properties({
    this.objectid,
    this.code,
    this.khorooNam,
    this.areaM2,
    this.au1Code,
    this.au2Code,
    this.nam,
    this.duureg,
    this.khoroo,
    this.objectId,
    this.khMon,
    this.shapeLeng,
    this.shapeArea,
  });

  int objectid;
  String code;
  String khorooNam;
  int areaM2;
  String au1Code;
  String au2Code;
  int nam;
  String duureg;
  int khoroo;
  int objectId;
  String khMon;
  double shapeLeng;
  double shapeArea;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    objectid: json["OBJECTID"],
    code: json["code"],
    khorooNam: json["Khoroo_nam"],
    areaM2: json["area_m2"],
    au1Code: json["au1_code"],
    au2Code: json["au2_code"],
    nam: json["nam"],
    duureg: json["duureg"],
    khoroo: json["khoroo"],
    objectId: json["object_id"],
    khMon: json["KH_MON"],
    shapeLeng: json["Shape_Leng"].toDouble(),
    shapeArea: json["Shape_Area"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "OBJECTID": objectid,
    "code": code,
    "Khoroo_nam": khorooNam,
    "area_m2": areaM2,
    "au1_code": au1Code,
    "au2_code": au2Code,
    "nam": nam,
    "duureg": duureg,
    "khoroo": khoroo,
    "object_id": objectId,
    "KH_MON": khMon,
    "Shape_Leng": shapeLeng,
    "Shape_Area": shapeArea,
  };
}
