import 'package:c2m2_mongolia/models/boundary_api.dart';

import 'feature_response_health.dart';

class FeatureResponse {
  bool success;
  String message;
  Geometries geometries;
  Boundary boundary;

  FeatureResponse({this.success, this.message, this.geometries, this.boundary});

  FeatureResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    geometries = json['geometries'] != null
        ? new Geometries.fromJson(json['geometries'])
        : null;
    boundary = Boundary.fromJson(json["boundary"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.geometries != null) {
      data['geometries'] = this.geometries.toJson();
    }
    data["boundary"] = boundary.toJson();
    return data;
  }
}

class Geometries {
  String type;
  List<Features> features;

  Geometries({this.type, this.features});

  Geometries.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['features'] != null) {
      features = new List<Features>();
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String type;
  String id;
  Properties properties;
  Geometry geometry;

  Features({this.type, this.id, this.properties, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
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
    data['id'] = this.id;
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
  int id;
  Tags tags;

  // List<Null> relations;
  Meta meta;

  // Properties({this.type, this.id, this.tags, this.relations, this.meta});
  Properties({this.type, this.id, this.tags, this.meta});

  Properties.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
    // if (json['relations'] != null) {
    // 	relations = new List<Null>();
    // 	json['relations'].forEach((v) { relations.add(new Null.fromJson(v)); });
    // }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.tags != null) {
      data['tags'] = this.tags.toJson();
    }
    // if (this.relations != null) {
    //   data['relations'] = this.relations.map((v) => v.toJson()).toList();
    // }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class Tags {
  String amenity;
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
  String dispensing;
  String brand;
  String brandWikidata;
  String brandWikipedia;
  String shop;
  String driveThrough;
  String ele;

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
    this.dispensing,
    this.brand,
    this.brandWikidata,
    this.brandWikipedia,
    this.shop,
    this.driveThrough,
    this.ele,
  });

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        amenity: json["amenity"] == null ? null : json["amenity"],
        wheelchair: json["wheelchair"] == null
            ? null
            : insuranceHealthValues.map[json["wheelchair"]],
        healthcare: json["healthcare"] == null
            ? null
            : amenityValues.map[json["healthcare"]],
        name: json["name"] == null ? null : json["name"],
        addrHousenumber:
            json["addr:housenumber"] == null ? null : json["addr:housenumber"],
        addrStreet: json["addr:street"] == null ? null : json["addr:street"],
        nameMn: json["name:mn"] == null ? null : json["name:mn"],
        nameEn: json["name:en"] == null ? null : json["name:en"],
        toiletsWheelchair: json["toilets:wheelchair"] == null
            ? null
            : insuranceHealthValues.map[json["toilets:wheelchair"]],
        wheelchairDescription: json["wheelchair:description"] == null
            ? null
            : json["wheelchair:description"],
        addrCity: json["addr:city"] == null ? null : json["addr:city"],
        internetAccess: json["internet_access"] == null
            ? null
            : internetAccessValues.map[json["internet_access"]],
        openingHours:
            json["opening_hours"] == null ? null : json["opening_hours"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        addrCountry: json["addr:country"] == null ? null : json["addr:country"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        addrPostcode:
            json["addr:postcode"] == null ? null : json["addr:postcode"],
        addrDistrict:
            json["addr:district"] == null ? null : json["addr:district"],
        addrState: json["addr:state"] == null ? null : json["addr:state"],
        addrSubdistrict:
            json["addr:subdistrict"] == null ? null : json["addr:subdistrict"],
        healthFacilityType: json["health_facility:type"] == null
            ? null
            : amenityValues.map[json["health_facility:type"]],
        healthcareSpeciality: json["healthcare:speciality"] == null
            ? null
            : json["healthcare:speciality"],
        insuranceHealth: json["insurance:health"] == null
            ? null
            : insuranceHealthValues.map[json["insurance:health"]],
        operatorType:
            json["operator:type"] == null ? null : json["operator:type"],
        tagsOperator: json["operator"] == null ? null : json["operator"],
        contactEmail:
            json["contact:email"] == null ? null : json["contact:email"],
        contactFacebook:
            json["contact:facebook"] == null ? null : json["contact:facebook"],
        contactPhone:
            json["contact:phone"] == null ? null : json["contact:phone"],
        website: json["website"] == null ? null : json["website"],
        openingHoursCovid19: json["opening_hours:covid19"] == null
            ? null
            : json["opening_hours:covid19"],
        emergency: json["emergency"] == null ? null : json["emergency"],
        level: json["level"] == null ? null : json["level"],
        description: json["description"] == null ? null : json["description"],
        internetAccessSsid: json["internet_access:ssid"] == null
            ? null
            : json["internet_access:ssid"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        nameRu: json["name:ru"] == null ? null : json["name:ru"],
        socialFacility:
            json["social_facility"] == null ? null : json["social_facility"],
        socialFacilityFor: json["social_facility:for"] == null
            ? null
            : json["social_facility:for"],
        towerType: json["tower:type"] == null ? null : json["tower:type"],
        dispensing: json["dispensing"] == null ? null : json["dispensing"],
        brand: json["brand"] == null ? null : json["brand"],
        brandWikidata:
            json["brand:wikidata"] == null ? null : json["brand:wikidata"],
        brandWikipedia:
            json["brand:wikipedia"] == null ? null : json["brand:wikipedia"],
        shop: json["shop"] == null ? null : json["shop"],
        driveThrough: json["drive_through"] == null
            ? null
            : json["drive_through"],
        ele: json["ele"] == null ? null : json["ele"],
      );

  Map<String, dynamic> toJson() => {
        "amenity": amenity == null ? null : amenity,
        "wheelchair": wheelchair == null
            ? null
            : insuranceHealthValues.reverse[wheelchair],
        "healthcare":
            healthcare == null ? null : amenityValues.reverse[healthcare],
        "name": name == null ? null : name,
        "addr:housenumber": addrHousenumber == null ? null : addrHousenumber,
        "addr:street": addrStreet == null ? null : addrStreet,
        "name:mn": nameMn == null ? null : nameMn,
        "name:en": nameEn == null ? null : nameEn,
        "toilets:wheelchair": toiletsWheelchair == null
            ? null
            : insuranceHealthValues.reverse[toiletsWheelchair],
        "wheelchair:description":
            wheelchairDescription == null ? null : wheelchairDescription,
        "addr:city": addrCity == null ? null : addrCity,
        "internet_access": internetAccess == null
            ? null
            : internetAccessValues.reverse[internetAccess],
        "opening_hours": openingHours == null ? null : openingHours,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "addr:country": addrCountry == null ? null : addrCountry,
        "facebook": facebook == null ? null : facebook,
        "addr:postcode": addrPostcode == null ? null : addrPostcode,
        "addr:district": addrDistrict == null ? null : addrDistrict,
        "addr:state": addrState == null ? null : addrState,
        "addr:subdistrict": addrSubdistrict == null ? null : addrSubdistrict,
        "health_facility:type": healthFacilityType == null
            ? null
            : amenityValues.reverse[healthFacilityType],
        "healthcare:speciality":
            healthcareSpeciality == null ? null : healthcareSpeciality,
        "insurance:health": insuranceHealth == null
            ? null
            : insuranceHealthValues.reverse[insuranceHealth],
        "operator:type": operatorType == null ? null : operatorType,
        "operator": tagsOperator == null ? null : tagsOperator,
        "contact:email": contactEmail == null ? null : contactEmail,
        "contact:facebook": contactFacebook == null ? null : contactFacebook,
        "contact:phone": contactPhone == null ? null : contactPhone,
        "website": website == null ? null : website,
        "opening_hours:covid19":
            openingHoursCovid19 == null ? null : openingHoursCovid19,
        "emergency": emergency == null ? null : emergency,
        "level": level == null ? null : level,
        "description": description == null ? null : description,
        "internet_access:ssid":
            internetAccessSsid == null ? null : internetAccessSsid,
        "start_date": startDate == null ? null : startDate,
        "name:ru": nameRu == null ? null : nameRu,
        "social_facility": socialFacility == null ? null : socialFacility,
        "social_facility:for":
            socialFacilityFor == null ? null : socialFacilityFor,
        "tower:type": towerType == null ? null : towerType,
        "dispensing": dispensing == null ? null : dispensing,
        "brand": brand == null ? null : brand,
        "brand:wikidata": brandWikidata == null ? null : brandWikidata,
        "brand:wikipedia": brandWikipedia == null ? null : brandWikipedia,
        "shop": shop == null ? null : shop,
        "drive_through": driveThrough == null
            ? null
            : driveThrough,
        "ele": ele == null ? null : ele,
      };
}

class Meta {
  // Meta({});

  Meta.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
