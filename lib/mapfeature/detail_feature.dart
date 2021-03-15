import 'package:c2m2_mongolia/main.dart';
import 'package:hive/hive.dart';

part '../hive/detail_feature.g.dart';

@HiveType(typeId: 4)
class FeaturePair {
  @HiveField(0)
  String key;
  @HiveField(1)
  dynamic value;

  FeaturePair(this.key, this.value);
}

@HiveType(typeId: 1)
class TitleDetail {
  @HiveField(0)
  String title;
  @HiveField(1)
  String subTitle;
  @HiveField(2)
  String rating;
  @HiveField(3)
  FeatureType featureType;
  @HiveField(4)
  int raters = 0;

  TitleDetail(String title, String subTitle, String rating, int raters,
      FeatureType featureType) {
    this.title = title;
    this.subTitle = subTitle;
    this.rating = rating;
    this.raters = raters;
    this.featureType = featureType;
  }

  String formatedSub() {
    subTitle = this.subTitle.replaceAll("_", " ");
    subTitle = subTitle[0].toUpperCase() + subTitle.substring(1).toLowerCase();
    return subTitle;
  }

  double formatedRating() {
    try {
      double ratings = double.parse(rating);
      if (ratings.isNaN) throw FormatException();
      return ratings;
    } on FormatException {
      return 0;
    }
  }
}

@HiveType(typeId: 2)
class InfoDetail {
  @HiveField(0)
  List<String> phone;
  @HiveField(1)
  List<double> coordinates;
  @HiveField(2)
  String name;
  @HiveField(3)
  String serviceId;
  @HiveField(4)
  String osmID;
  @HiveField(5)
  String type;

  InfoDetail(this.phone, this.coordinates, this.serviceId, this.type, this.name,
      this.osmID);
}

class ReviewsRequest {
  ReviewsRequest({
    this.osmUsername,
    this.rating,
    this.comments,
    this.serviceId,
    this.service,
    this.healthExpertise,
  });

  String osmUsername;
  int rating;
  String comments;
  String serviceId;
  String service;
  String healthExpertise;

  Map<String, dynamic> toJson() => {
        "osm_username": osmUsername,
        "rating": rating,
        "comments": comments,
        "service_id": serviceId,
        "service": service,
        "health_expertise": healthExpertise,
      };
}
