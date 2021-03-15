import 'dart:convert';

GeoFeatures geoFeaturesFromJson(String str) => GeoFeatures.fromJson(json.decode(str));

String geoFeaturesToJson(GeoFeatures data) => json.encode(data.toJson());

class GeoFeatures {
  GeoFeatures({
    this.success,
    this.message,
    this.geometries,
    this.parameters,
    this.insights,
    this.filters,
  });

  int success;
  String message;
  Geometries geometries;
  Map<String, Ter> parameters;
  Map<String, Insight> insights;
  List<Ter> filters;

  factory GeoFeatures.fromJson(Map<String, dynamic> json) => GeoFeatures(
    success: json["success"],
    message: json["message"],
    geometries: Geometries.fromJson(json["geometries"]),
    parameters: Map.from(json["parameters"]).map((k, v) => MapEntry<String, Ter>(k, Ter.fromJson(v))),
    insights: Map.from(json["insights"]).map((k, v) => MapEntry<String, Insight>(k, Insight.fromJson(v))),
    filters: List<Ter>.from(json["filters"].map((x) => Ter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "geometries": geometries.toJson(),
    "parameters": Map.from(parameters).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "insights": Map.from(insights).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}

class Ter {
  Ter({
    this.label,
    this.type,
    this.parameterName,
    this.options,
    this.databaseSchemaKey,
    this.range,
    this.boolean,
  });

  String label;
  String type;
  String parameterName;
  List<Option> options;
  String databaseSchemaKey;
  Range range;
  bool boolean;

  factory Ter.fromJson(Map<String, dynamic> json) => Ter(
    label: json["label"],
    type: json["type"],
    parameterName: json["parameter_name"],
    options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    databaseSchemaKey: json["database_schema_key"] == null ? null : json["database_schema_key"],
    range: json["range"] == null ? null : Range.fromJson(json["range"]),
    boolean: json["boolean"] == null ? null : json["boolean"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "type": type,
    "parameter_name": parameterName,
    "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
    "database_schema_key": databaseSchemaKey == null ? null : databaseSchemaKey,
    "range": range == null ? null : range.toJson(),
    "boolean": boolean == null ? null : boolean,
  };
}

class Option {
  Option({
    this.value,
    this.label,
    this.databaseSchemaKey,
  });

  String value;
  String label;
  String databaseSchemaKey;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    value: json["value"],
    label: json["label"],
    databaseSchemaKey: json["database_schema_key"] == null ? null : json["database_schema_key"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "database_schema_key": databaseSchemaKey == null ? null : databaseSchemaKey,
  };
}

class Range {
  Range({
    this.step,
    this.max,
    this.min,
    this.high,
    this.low,
  });

  int step;
  int max;
  int min;
  int high;
  int low;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
    step: json["step"],
    max: json["max"],
    min: json["min"],
    high: json["high"],
    low: json["low"],
  );

  Map<String, dynamic> toJson() => {
    "step": step,
    "max": max,
    "min": min,
    "high": high,
    "low": low,
  };
}

class Geometries {
  Geometries({
    this.pois,
    this.boundary,
    this.boundaryWithWards,
  });

  Pois pois;
  BoundaryClass boundary;
  BoundaryWithWards boundaryWithWards;

  factory Geometries.fromJson(Map<String, dynamic> json) => Geometries(
    pois: Pois.fromJson(json["pois"]),
    boundary: BoundaryClass.fromJson(json["boundary"]),
    boundaryWithWards: BoundaryWithWards.fromJson(json["boundaryWithWards"]),
  );

  Map<String, dynamic> toJson() => {
    "pois": pois.toJson(),
    "boundary": boundary.toJson(),
    "boundaryWithWards": boundaryWithWards.toJson(),
  };
}

class BoundaryClass {
  BoundaryClass({
    this.type,
    this.properties,
    this.geometry,
    this.id,
  });

  BoundaryType type;
  BoundaryProperties properties;
  Geometry geometry;
  String id;

  factory BoundaryClass.fromJson(Map<String, dynamic> json) => BoundaryClass(
    type: boundaryTypeValues.map[json["type"]],
    properties: BoundaryProperties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": boundaryTypeValues.reverse[type],
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
    "id": id,
  };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  PurpleType type;
  List<List<List<double>>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: purpleTypeValues.map[json["type"]],
    coordinates: List<List<List<double>>>.from(json["coordinates"].map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble())))))),
  );

  Map<String, dynamic> toJson() => {
    "type": purpleTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
  };
}

enum PurpleType { POLYGON }

final purpleTypeValues = EnumValues({
  "Polygon": PurpleType.POLYGON
});

class BoundaryProperties {
  BoundaryProperties({
    this.id,
    this.adminLevel,
    this.altName,
    this.boundary,
    this.description,
    this.name,
    this.nameNe,
    this.nameSuffix,
    this.type,
    this.altName1,
    this.locality,
  });

  String id;
  String adminLevel;
  String altName;
  BoundaryEnum boundary;
  String description;
  String name;
  String nameNe;
  String nameSuffix;
  FluffyType type;
  String altName1;
  String locality;

  factory BoundaryProperties.fromJson(Map<String, dynamic> json) => BoundaryProperties(
    id: json["@id"],
    adminLevel: json["admin_level"],
    altName: json["alt_name"],
    boundary: boundaryEnumValues.map[json["boundary"]],
    description: json["description"] == null ? null : json["description"],
    name: json["name"],
    nameNe: json["name:ne"],
    nameSuffix: json["name:suffix"] == null ? null : json["name:suffix"],
    type: fluffyTypeValues.map[json["type"]],
    altName1: json["alt_name1"] == null ? null : json["alt_name1"],
    locality: json["locality"] == null ? null : json["locality"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id,
    "admin_level": adminLevel,
    "alt_name": altName,
    "boundary": boundaryEnumValues.reverse[boundary],
    "description": description == null ? null : description,
    "name": name,
    "name:ne": nameNe,
    "name:suffix": nameSuffix == null ? null : nameSuffix,
    "type": fluffyTypeValues.reverse[type],
    "alt_name1": altName1 == null ? null : altName1,
    "locality": locality == null ? null : locality,
  };
}

enum BoundaryEnum { ADMINISTRATIVE }

final boundaryEnumValues = EnumValues({
  "administrative": BoundaryEnum.ADMINISTRATIVE
});

enum FluffyType { BOUNDARY }

final fluffyTypeValues = EnumValues({
  "boundary": FluffyType.BOUNDARY
});

enum BoundaryType { FEATURE }

final boundaryTypeValues = EnumValues({
  "Feature": BoundaryType.FEATURE
});

class BoundaryWithWards {
  BoundaryWithWards({
    this.type,
    this.features,
  });

  String type;
  List<BoundaryWithWardsFeature> features;

  factory BoundaryWithWards.fromJson(Map<String, dynamic> json) => BoundaryWithWards(
    type: json["type"],
    features: List<BoundaryWithWardsFeature>.from(json["features"].map((x) => BoundaryWithWardsFeature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class BoundaryWithWardsFeature {
  BoundaryWithWardsFeature({
    this.type,
    this.geometry,
    this.properties,
    this.id,
    this.centroid,
  });

  BoundaryType type;
  Geometry geometry;
  BoundaryProperties properties;
  String id;
  Centroid centroid;

  factory BoundaryWithWardsFeature.fromJson(Map<String, dynamic> json) => BoundaryWithWardsFeature(
    type: boundaryTypeValues.map[json["type"]],
    geometry: Geometry.fromJson(json["geometry"]),
    properties: BoundaryProperties.fromJson(json["properties"]),
    id: json["id"],
    centroid: Centroid.fromJson(json["centroid"]),
  );

  Map<String, dynamic> toJson() => {
    "type": boundaryTypeValues.reverse[type],
    "geometry": geometry.toJson(),
    "properties": properties.toJson(),
    "id": id,
    "centroid": centroid.toJson(),
  };
}

class Centroid {
  Centroid({
    this.type,
    this.coordinates,
  });

  CentroidType type;
  List<double> coordinates;

  factory Centroid.fromJson(Map<String, dynamic> json) => Centroid(
    type: centroidTypeValues.map[json["type"]],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": centroidTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum CentroidType { POINT }

final centroidTypeValues = EnumValues({
  "Point": CentroidType.POINT
});

class Pois {
  Pois({
    this.type,
    this.features,
    this.createdOn,
  });

  String type;
  List<PoisFeature> features;
  int createdOn;

  factory Pois.fromJson(Map<String, dynamic> json) => Pois(
    type: json["type"],
    features: List<PoisFeature>.from(json["features"].map((x) => PoisFeature.fromJson(x))),
    createdOn: json["createdOn"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "createdOn": createdOn,
  };
}

class PoisFeature {
  PoisFeature({
    this.type,
    this.id,
    this.properties,
    this.geometry,
    this.wardId,
  });

  BoundaryType type;
  String id;
  PurpleProperties properties;
  Centroid geometry;
  String wardId;

  factory PoisFeature.fromJson(Map<String, dynamic> json) => PoisFeature(
    type: boundaryTypeValues.map[json["type"]],
    id: json["id"],
    properties: PurpleProperties.fromJson(json["properties"]),
    geometry: Centroid.fromJson(json["geometry"]),
    wardId: json["wardId"],
  );

  Map<String, dynamic> toJson() => {
    "type": boundaryTypeValues.reverse[type],
    "id": id,
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
    "wardId": wardId,
  };
}

class PurpleProperties {
  PurpleProperties({
    this.type,
    this.id,
    this.tags,
    this.relations,
    this.meta,
  });

  TentacledType type;
  int id;
  Tags tags;
  List<dynamic> relations;
  Meta meta;

  factory PurpleProperties.fromJson(Map<String, dynamic> json) => PurpleProperties(
    type: tentacledTypeValues.map[json["type"]],
    id: json["id"],
    tags: Tags.fromJson(json["tags"]),
    relations: List<dynamic>.from(json["relations"].map((x) => x)),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "type": tentacledTypeValues.reverse[type],
    "id": id,
    "tags": tags.toJson(),
    "relations": List<dynamic>.from(relations.map((x) => x)),
    "meta": meta.toJson(),
  };
}

class Meta {
  Meta({
    this.timestamp,
    this.version,
    this.changeset,
    this.user,
    this.uid,
  });

  DateTime timestamp;
  int version;
  int changeset;
  String user;
  int uid;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    timestamp: DateTime.parse(json["timestamp"]),
    version: json["version"],
    changeset: json["changeset"],
    user: json["user"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "version": version,
    "changeset": changeset,
    "user": user,
    "uid": uid,
  };
}

class Tags {
  Tags({
    this.addrPostcode,
    this.amenity,
    this.capacityBeds,
    this.email,
    this.emergency,
    this.facilityAmbulance,
    this.facilityIcu,
    this.facilityNicu,
    this.facilityOperatingTheater,
    this.facilityOperationTheatre,
    this.facilityVentilator,
    this.facilityXRay,
    this.name,
    this.nameNe,
    this.note,
    this.operatorType,
    this.personnelCount,
    this.phone,
    this.type,
    this.website,
    this.addrCity,
    this.addrStreet,
    this.emergencyService,
    this.facilityOperatingTheatre,
    this.openingHours,
    this.startDate,
    this.building,
    this.source,
    this.altName,
    this.healthAmenityType,
    this.healthcare,
    this.healthcareSpeciality,
    this.wheelchair,
    this.fax,
    this.buildingLevels,
    this.addrHousenumber,
    this.capacityBed,
    this.contactFax,
    this.addrPlace,
    this.emergencyServices,
    this.tagsOperator,
    this.contactEmail,
    this.nameEn,
    this.estd,
  });

  String addrPostcode;
  String amenity;
  String capacityBeds;
  String email;
  Building emergency;
  Building facilityAmbulance;
  Building facilityIcu;
  Building facilityNicu;
  Building facilityOperatingTheater;
  Building facilityOperationTheatre;
  Building facilityVentilator;
  Building facilityXRay;
  String name;
  String nameNe;
  String note;
  OperatorType operatorType;
  String personnelCount;
  String phone;
  String type;
  String website;
  String addrCity;
  String addrStreet;
  EmergencyService emergencyService;
  Building facilityOperatingTheatre;
  String openingHours;
  String startDate;
  Building building;
  String source;
  String altName;
  String healthAmenityType;
  String healthcare;
  String healthcareSpeciality;
  Building wheelchair;
  String fax;
  String buildingLevels;
  String addrHousenumber;
  String capacityBed;
  String contactFax;
  String addrPlace;
  EmergencyService emergencyServices;
  String tagsOperator;
  String contactEmail;
  String nameEn;
  String estd;

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
    addrPostcode: json["addr:postcode"] == null ? null : json["addr:postcode"],
    amenity: json["amenity"] == null ? null : json["amenity"],
    capacityBeds: json["capacity:beds"] == null ? null : json["capacity:beds"],
    email: json["email"] == null ? null : json["email"],
    emergency: json["emergency"] == null ? null : buildingValues.map[json["emergency"]],
    facilityAmbulance: json["facility:ambulance"] == null ? null : buildingValues.map[json["facility:ambulance"]],
    facilityIcu: json["facility:icu"] == null ? null : buildingValues.map[json["facility:icu"]],
    facilityNicu: json["facility:nicu"] == null ? null : buildingValues.map[json["facility:nicu"]],
    facilityOperatingTheater: json["facility:operating_theater"] == null ? null : buildingValues.map[json["facility:operating_theater"]],
    facilityOperationTheatre: json["facility:operation_theatre"] == null ? null : buildingValues.map[json["facility:operation_theatre"]],
    facilityVentilator: json["facility:ventilator"] == null ? null : buildingValues.map[json["facility:ventilator"]],
    facilityXRay: json["facility:x-ray"] == null ? null : buildingValues.map[json["facility:x-ray"]],
    name: json["name"],
    nameNe: json["name:ne"] == null ? null : json["name:ne"],
    note: json["note"] == null ? null : json["note"],
    operatorType: json["operator:type"] == null ? null : operatorTypeValues.map[json["operator:type"]],
    personnelCount: json["personnel:count"] == null ? null : json["personnel:count"],
    phone: json["phone"] == null ? null : json["phone"],
    type: json["type"] == null ? null : json["type"],
    website: json["website"] == null ? null : json["website"],
    addrCity: json["addr:city"] == null ? null : json["addr:city"],
    addrStreet: json["addr:street"] == null ? null : json["addr:street"],
    emergencyService: json["emergency_service"] == null ? null : emergencyServiceValues.map[json["emergency_service"]],
    facilityOperatingTheatre: json["facility:operating_theatre"] == null ? null : buildingValues.map[json["facility:operating_theatre"]],
    openingHours: json["opening_hours"] == null ? null : json["opening_hours"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    building: json["building"] == null ? null : buildingValues.map[json["building"]],
    source: json["source"] == null ? null : json["source"],
    altName: json["alt_name"] == null ? null : json["alt_name"],
    healthAmenityType: json["health_amenity:type"] == null ? null : json["health_amenity:type"],
    healthcare: json["healthcare"] == null ? null : json["healthcare"],
    healthcareSpeciality: json["healthcare:speciality"] == null ? null : json["healthcare:speciality"],
    wheelchair: json["wheelchair"] == null ? null : buildingValues.map[json["wheelchair"]],
    fax: json["fax"] == null ? null : json["fax"],
    buildingLevels: json["building:levels"] == null ? null : json["building:levels"],
    addrHousenumber: json["addr:housenumber"] == null ? null : json["addr:housenumber"],
    capacityBed: json["capacity:bed"] == null ? null : json["capacity:bed"],
    contactFax: json["contact:fax"] == null ? null : json["contact:fax"],
    addrPlace: json["addr:place"] == null ? null : json["addr:place"],
    emergencyServices: json["emergency_services"] == null ? null : emergencyServiceValues.map[json["emergency_services"]],
    tagsOperator: json["operator"] == null ? null : json["operator"],
    contactEmail: json["contact:email"] == null ? null : json["contact:email"],
    nameEn: json["name:en"] == null ? null : json["name:en"],
    estd: json["estd"] == null ? null : json["estd"],
  );

  Map<String, dynamic> toJson() => {
    "addr:postcode": addrPostcode == null ? null : addrPostcode,
    "amenity": amenityValues.reverse[amenity],
    "capacity:beds": capacityBeds == null ? null : capacityBeds,
    "email": email == null ? null : email,
    "emergency": emergency == null ? null : buildingValues.reverse[emergency],
    "facility:ambulance": facilityAmbulance == null ? null : buildingValues.reverse[facilityAmbulance],
    "facility:icu": facilityIcu == null ? null : buildingValues.reverse[facilityIcu],
    "facility:nicu": facilityNicu == null ? null : buildingValues.reverse[facilityNicu],
    "facility:operating_theater": facilityOperatingTheater == null ? null : buildingValues.reverse[facilityOperatingTheater],
    "facility:operation_theatre": facilityOperationTheatre == null ? null : buildingValues.reverse[facilityOperationTheatre],
    "facility:ventilator": facilityVentilator == null ? null : buildingValues.reverse[facilityVentilator],
    "facility:x-ray": facilityXRay == null ? null : buildingValues.reverse[facilityXRay],
    "name": name,
    "name:ne": nameNe == null ? null : nameNe,
    "note": note == null ? null : note,
    "operator:type": operatorType == null ? null : operatorTypeValues.reverse[operatorType],
    "personnel:count": personnelCount == null ? null : personnelCount,
    "phone": phone == null ? null : phone,
    "type": type == null ? null : type,
    "website": website == null ? null : website,
    "addr:city": addrCity == null ? null : addrCity,
    "addr:street": addrStreet == null ? null : addrStreet,
    "emergency_service": emergencyService == null ? null : emergencyServiceValues.reverse[emergencyService],
    "facility:operating_theatre": facilityOperatingTheatre == null ? null : buildingValues.reverse[facilityOperatingTheatre],
    "opening_hours": openingHours == null ? null : openingHours,
    "start_date": startDate == null ? null : startDate,
    "building": building == null ? null : buildingValues.reverse[building],
    "source": source == null ? null : source,
    "alt_name": altName == null ? null : altName,
    "health_amenity:type": healthAmenityType == null ? null : healthAmenityType,
    "healthcare": healthcare == null ? null : healthcare,
    "healthcare:speciality": healthcareSpeciality == null ? null : healthcareSpeciality,
    "wheelchair": wheelchair == null ? null : buildingValues.reverse[wheelchair],
    "fax": fax == null ? null : fax,
    "building:levels": buildingLevels == null ? null : buildingLevels,
    "addr:housenumber": addrHousenumber == null ? null : addrHousenumber,
    "capacity:bed": capacityBed == null ? null : capacityBed,
    "contact:fax": contactFax == null ? null : contactFax,
    "addr:place": addrPlace == null ? null : addrPlace,
    "emergency_services": emergencyServices == null ? null : emergencyServiceValues.reverse[emergencyServices],
    "operator": tagsOperator == null ? null : tagsOperator,
    "contact:email": contactEmail == null ? null : contactEmail,
    "name:en": nameEn == null ? null : nameEn,
    "estd": estd == null ? null : estd,
  };
}

enum Amenity { HOSPITAL }

final amenityValues = EnumValues({
  "hospital": Amenity.HOSPITAL
});

enum Building { YES, NO }

final buildingValues = EnumValues({
  "no": Building.NO,
  "yes": Building.YES
});

enum EmergencyService { AMBULANCE }

final emergencyServiceValues = EnumValues({
  "ambulance": EmergencyService.AMBULANCE
});

enum OperatorType { GOVERNMENT, PRIVATE, NGO, COMMUNITY }

final operatorTypeValues = EnumValues({
  "community": OperatorType.COMMUNITY,
  "government": OperatorType.GOVERNMENT,
  "NGO": OperatorType.NGO,
  "private": OperatorType.PRIVATE
});

enum TentacledType { RELATION, WAY, NODE }

final tentacledTypeValues = EnumValues({
  "node": TentacledType.NODE,
  "relation": TentacledType.RELATION,
  "way": TentacledType.WAY
});

class Insight {
  Insight({
    this.maxValue,
    this.value,
    this.insightTitle,
  });

  int maxValue;
  int value;
  String insightTitle;

  factory Insight.fromJson(Map<String, dynamic> json) => Insight(
    maxValue: json["max_value"],
    value: json["value"],
    insightTitle: json["insight_title"],
  );

  Map<String, dynamic> toJson() => {
    "max_value": maxValue,
    "value": value,
    "insight_title": insightTitle,
  };
}

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