class FeatureRequest {
  String type,city,district,khoroo;
  List<Filters> filters;

  FeatureRequest({this.type, this.filters,this.city,this.district,this.khoroo});

  FeatureRequest.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    district = json['district'];
    khoroo = json['khoroo'];
    if (json['filters'] != null) {
      filters = new List<Filters>();
      json['filters'].forEach((v) {
        filters.add(new Filters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['district'] = this.district;
    data['khoroo'] = this.khoroo;
    data['city'] = 'Ulaanbaatar';
    if (this.filters != null) {
      data['filters'] = this.filters.map((v) => v.toJson()).toList();
    }
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }

  @override
  String toString() {
    return 'FeatureRequest{type: $type, city: $city, district: $district, khoroo: $khoroo, filters: $filters}';
  }
}

class Filters {
  String osmTag;
  List<String> osmValue;

  Filters({this.osmTag, this.osmValue});

  Filters.fromJson(Map<String, dynamic> json) {
    osmTag = json['osmTag'];
    osmValue = json['osmValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['osmTag'] = this.osmTag.toLowerCase();
    data['osmValue'] = this.osmValue;
    return data;
  }

  @override
  String toString() {
    return 'Filters{osmTag: $osmTag, osmValue: $osmValue}';
  }
}