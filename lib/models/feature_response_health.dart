// To parse this JSON data, do
//
//     final featureResponseHealth = featureResponseHealthFromJson(jsonString);

import 'dart:convert';
import 'package:c2m2_mongolia/models/feature_boundary.dart';

FeatureResponseHealth featureResponseHealthFromJson(String str) => FeatureResponseHealth.fromJson(json.decode(str));

String featureResponseHealthToJson(FeatureResponseHealth data) => json.encode(data.toJson());

class FeatureResponseHealth {
  FeatureResponseHealth({
    this.success,
    this.message,
    this.boundary,
    this.geometries,
  });

  bool success;
  String message;
  FeatureBoundary boundary;
  Geometries geometries;

  factory FeatureResponseHealth.fromJson(Map<String, dynamic> json) => FeatureResponseHealth(
    success: json["success"],
    message: json["message"],
    boundary: FeatureBoundary.fromJson(json["boundary"]),
    geometries: Geometries.fromJson(json["geometries"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "boundary": boundary.toJson(),
    "geometries": geometries.toJson(),
  };
}

class Geometries {
  Geometries({
    this.type,
    this.features,
  });

  String type;
  List<Feature> features;

  factory Geometries.fromJson(Map<String, dynamic> json) => Geometries(
    type: json["type"],
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
  };
}

class Feature {
  Feature({
    this.type,
    this.id,
    this.properties,
    this.geometry,
  });

  FeatureType type;
  String id;
  Properties properties;
  Geometry geometry;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: featureTypeValues.map[json["type"]],
    id: json["id"],
    properties: Properties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
  );

  Map<String, dynamic> toJson() => {
    "type": featureTypeValues.reverse[type],
    "id": id,
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
  };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  GeometryType type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: geometryTypeValues.map[json["type"]],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": geometryTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum GeometryType { POINT }

final geometryTypeValues = EnumValues({
  "Point": GeometryType.POINT
});

class Properties {
  Properties({
    this.type,
    this.id,
    this.tags,
    this.relations,
    this.meta,
  });

  PropertiesType type;
  int id;
  Tags tags;
  List<dynamic> relations;
  Meta meta;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    type: propertiesTypeValues.map[json["type"]],
    id: json["id"],
    tags: Tags.fromJson(json["tags"]),
    relations: List<dynamic>.from(json["relations"].map((x) => x)),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "type": propertiesTypeValues.reverse[type],
    "id": id,
    "tags": tags.toJson(),
    "relations": List<dynamic>.from(relations.map((x) => x)),
    "meta": meta.toJson(),
  };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Tags {
  Tags({
    this.amenity,
    this.wheelchair,
    this.healthcare,
    this.name,
    this.addrHousenumber,
    this.addrStreet,
    this.nameMn,
    this.nameEn,
    this.toiletsWheelchair,
    this.wheelchairDescription,
    this.addrCity,
    this.internetAccess,
    this.openingHours,
    this.phone,
    this.email,
    this.addrCountry,
    this.facebook,
    this.addrPostcode,
    this.addrDistrict,
    this.addrState,
    this.addrSubdistrict,
    this.healthFacilityType,
    this.healthcareSpeciality,
    this.insuranceHealth,
    this.operatorType,
    this.tagsOperator,
    this.contactEmail,
    this.contactFacebook,
    this.contactPhone,
    this.website,
    this.openingHoursCovid19,
    this.emergency,
    this.level,
    this.description,
    this.internetAccessSsid,
    this.startDate,
    this.nameRu,
    this.socialFacility,
    this.socialFacilityFor,
    this.towerType,
    this.driveThrough,
    this.dispensing
  });

  Amenity amenity;
  InsuranceHealth wheelchair;
  Amenity healthcare;
  String name;
  String addrHousenumber;
  String addrStreet;
  String nameMn;
  String nameEn;
  InsuranceHealth toiletsWheelchair;
  String wheelchairDescription;
  String addrCity;
  InternetAccess internetAccess;
  String openingHours;
  String phone;
  String email;
  String addrCountry;
  String facebook;
  String addrPostcode;
  String addrDistrict;
  String addrState;
  String addrSubdistrict;
  Amenity healthFacilityType;
  String healthcareSpeciality;
  InsuranceHealth insuranceHealth;
  String operatorType;
  String tagsOperator;
  String contactEmail;
  String contactFacebook;
  String contactPhone;
  String website;
  String openingHoursCovid19;
  String emergency;
  String level;
  String description;
  String internetAccessSsid;
  String startDate;
  String nameRu;
  String socialFacility;
  String socialFacilityFor;
  String towerType;
  String driveThrough;
  String dispensing;

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
    amenity: amenityValues.map[json["amenity"]],
    wheelchair: json["wheelchair"] == null ? null : insuranceHealthValues.map[json["wheelchair"]],
    healthcare: json["healthcare"] == null ? null : amenityValues.map[json["healthcare"]],
    name: json["name"] == null ? null : json["name"],
    addrHousenumber: json["addr:housenumber"] == null ? null : json["addr:housenumber"],
    addrStreet: json["addr:street"] == null ? null : json["addr:street"],
    nameMn: json["name:mn"] == null ? null : json["name:mn"],
    nameEn: json["name:en"] == null ? null : json["name:en"],
    toiletsWheelchair: json["toilets:wheelchair"] == null ? null : insuranceHealthValues.map[json["toilets:wheelchair"]],
    wheelchairDescription: json["wheelchair:description"] == null ? null : json["wheelchair:description"],
    addrCity: json["addr:city"] == null ? null : json["addr:city"],
    internetAccess: json["internet_access"] == null ? null : internetAccessValues.map[json["internet_access"]],
    openingHours: json["opening_hours"] == null ? null : json["opening_hours"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    addrCountry: json["addr:country"] == null ? null : json["addr:country"],
    facebook: json["facebook"] == null ? null : json["facebook"],
    addrPostcode: json["addr:postcode"] == null ? null : json["addr:postcode"],
    addrDistrict: json["addr:district"] == null ? null : json["addr:district"],
    addrState: json["addr:state"] == null ? null : json["addr:state"],
    addrSubdistrict: json["addr:subdistrict"] == null ? null : json["addr:subdistrict"],
    healthFacilityType: json["health_facility:type"] == null ? null : amenityValues.map[json["health_facility:type"]],
    healthcareSpeciality: json["healthcare:speciality"] == null ? null : json["healthcare:speciality"],
    insuranceHealth: json["insurance:health"] == null ? null : insuranceHealthValues.map[json["insurance:health"]],
    operatorType: json["operator:type"] == null ? null : json["operator:type"],
    tagsOperator: json["operator"] == null ? null : json["operator"],
    contactEmail: json["contact:email"] == null ? null : json["contact:email"],
    contactFacebook: json["contact:facebook"] == null ? null : json["contact:facebook"],
    contactPhone: json["contact:phone"] == null ? null : json["contact:phone"],
    website: json["website"] == null ? null : json["website"],
    openingHoursCovid19: json["opening_hours:covid19"] == null ? null : json["opening_hours:covid19"],
    emergency: json["emergency"] == null ? null : json["emergency"],
    level: json["level"] == null ? null : json["level"],
    description: json["description"] == null ? null : json["description"],
    internetAccessSsid: json["internet_access:ssid"] == null ? null : json["internet_access:ssid"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    nameRu: json["name:ru"] == null ? null : json["name:ru"],
    socialFacility: json["social_facility"] == null ? null : json["social_facility"],
    socialFacilityFor: json["social_facility:for"] == null ? null : json["social_facility:for"],
    towerType: json["tower:type"] == null ? null : json["tower:type"],
    driveThrough: json["drive_through"] == null ? null : json["drive_through"],
    dispensing: json["dispensing"] == null ? null : json["dispensing"],
  );

  Map<String, dynamic> toJson() => {
    "amenity": amenityValues.reverse[amenity],
    "wheelchair": wheelchair == null ? null : insuranceHealthValues.reverse[wheelchair],
    "healthcare": healthcare == null ? null : amenityValues.reverse[healthcare],
    "name": name == null ? null : name,
    "addr:housenumber": addrHousenumber == null ? null : addrHousenumber,
    "addr:street": addrStreet == null ? null : addrStreet,
    "name:mn": nameMn == null ? null : nameMn,
    "name:en": nameEn == null ? null : nameEn,
    "toilets:wheelchair": toiletsWheelchair == null ? null : insuranceHealthValues.reverse[toiletsWheelchair],
    "wheelchair:description": wheelchairDescription == null ? null : wheelchairDescription,
    "addr:city": addrCity == null ? null : addrCity,
    "internet_access": internetAccess == null ? null : internetAccessValues.reverse[internetAccess],
    "opening_hours": openingHours == null ? null : openingHours,
    "phone": phone == null ? null : phone,
    "email": email == null ? null : email,
    "addr:country": addrCountry == null ? null : addrCountry,
    "facebook": facebook == null ? null : facebook,
    "addr:postcode": addrPostcode == null ? null : addrPostcode,
    "addr:district": addrDistrict == null ? null : addrDistrict,
    "addr:state": addrState == null ? null : addrState,
    "addr:subdistrict": addrSubdistrict == null ? null : addrSubdistrict,
    "health_facility:type": healthFacilityType == null ? null : amenityValues.reverse[healthFacilityType],
    "healthcare:speciality": healthcareSpeciality == null ? null : healthcareSpeciality,
    "insurance:health": insuranceHealth == null ? null : insuranceHealthValues.reverse[insuranceHealth],
    "operator:type": operatorType == null ? null : operatorType,
    "operator": tagsOperator == null ? null : tagsOperator,
    "contact:email": contactEmail == null ? null : contactEmail,
    "contact:facebook": contactFacebook == null ? null : contactFacebook,
    "contact:phone": contactPhone == null ? null : contactPhone,
    "website": website == null ? null : website,
    "opening_hours:covid19": openingHoursCovid19 == null ? null : openingHoursCovid19,
    "emergency": emergency == null ? null : emergency,
    "level": level == null ? null : level,
    "description": description == null ? null : description,
    "internet_access:ssid": internetAccessSsid == null ? null : internetAccessSsid,
    "start_date": startDate == null ? null : startDate,
    "name:ru": nameRu == null ? null : nameRu,
    "social_facility": socialFacility == null ? null : socialFacility,
    "social_facility:for": socialFacilityFor == null ? null : socialFacilityFor,
    "tower:type": towerType == null ? null : towerType,
    "drive_through": driveThrough == null ? null : driveThrough,
    "dispensing": dispensing == null ? null : dispensing,
  };
}

enum Amenity { DENTIST, CLINIC, DOCTORS, HOSPITAL, NURSING_HOME, SOCIAL_FACILITY, DOCTOR,PHARMACY, BABY_HATCH }

final amenityValues = EnumValues({
  "clinic": Amenity.CLINIC,
  "dentist": Amenity.DENTIST,
  "doctor": Amenity.DOCTOR,
  "doctors": Amenity.DOCTORS,
  "hospital": Amenity.HOSPITAL,
  "nursing_home": Amenity.NURSING_HOME,
  "social_facility": Amenity.SOCIAL_FACILITY,
  "pharmacy": Amenity.PHARMACY,
  "baby_hatch": Amenity.BABY_HATCH
});

enum InsuranceHealth { NO, LIMITED, YES }

final insuranceHealthValues = EnumValues({
  "limited": InsuranceHealth.LIMITED,
  "no": InsuranceHealth.NO,
  "yes": InsuranceHealth.YES
});

enum InternetAccess { WLAN, YES }

final internetAccessValues = EnumValues({
  "wlan": InternetAccess.WLAN,
  "yes": InternetAccess.YES
});

enum PropertiesType { NODE }

final propertiesTypeValues = EnumValues({
  "node": PropertiesType.NODE
});

enum FeatureType { FEATURE }

final featureTypeValues = EnumValues({
  "Feature": FeatureType.FEATURE
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
