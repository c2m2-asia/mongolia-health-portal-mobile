import 'dart:convert';

FeatureBoundary featureBoundaryFromJson(String str) => FeatureBoundary.fromJson(json.decode(str));

String featureBoundaryToJson(FeatureBoundary data) => json.encode(data.toJson());

class FeatureBoundary {
  FeatureBoundary({
    this.type,
    this.name,
    this.crs,
    this.features,
  });

  String type;
  String name;
  Crs crs;
  List<Feature> features;

  factory FeatureBoundary.fromJson(Map<String, dynamic> json) => FeatureBoundary(
    type: json["type"],
    name: json["name"],
    crs: Crs.fromJson(json["crs"]),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "crs": crs.toJson(),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class Crs {
  Crs({
    this.type,
    this.properties,
  });

  String type;
  CrsProperties properties;

  factory Crs.fromJson(Map<String, dynamic> json) => Crs(
    type: json["type"],
    properties: CrsProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
  };
}

class CrsProperties {
  CrsProperties({
    this.name,
  });

  String name;

  factory CrsProperties.fromJson(Map<String, dynamic> json) => CrsProperties(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class Feature {
  Feature({
    this.type,
    this.properties,
    this.geometry,
  });

  String type;
  FeatureProperties properties;
  Geometry geometry;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: json["type"],
    properties: FeatureProperties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
  };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<List<List<List<double>>>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<List<List<List<double>>>>.from(json["coordinates"].map((x) => List<List<List<double>>>.from(x.map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble())))))))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))))),
  };
}

class FeatureProperties {
  FeatureProperties({
    this.objectid,
    this.shapeLeng,
    this.shapeArea,
  });

  int objectid;
  double shapeLeng;
  double shapeArea;

  factory FeatureProperties.fromJson(Map<String, dynamic> json) => FeatureProperties(
    objectid: json["OBJECTID"],
    shapeLeng: json["Shape_Leng"].toDouble(),
    shapeArea: json["Shape_Area"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "OBJECTID": objectid,
    "Shape_Leng": shapeLeng,
    "Shape_Area": shapeArea,
  };
}
