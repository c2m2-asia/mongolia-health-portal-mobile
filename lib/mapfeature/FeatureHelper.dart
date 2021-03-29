import 'package:c2m2_mongolia/localizations/app_icons.dart';
import 'package:c2m2_mongolia/models/feature_response.dart' as filter;
import 'package:c2m2_mongolia/models/feature_response_health.dart';
import 'package:c2m2_mongolia/models/search_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong/latlong.dart';

enum MarkerIcon {
  baby_hatch,
  clinic,
  dentist,
  doctors,
  health_post,
  hospital,
  nursing,
  pharmacy,
  social
}

extension MarkerExtension on MarkerIcon {
  String get blue {
    return 'assets/markericons/${this.toString().split(".").last}.png';
  }

  String get red {
    return 'assets/markericons/${this.toString().split(".").last}_red.png';
  }
}

class FeatureHelper {
  static String getIconAsset(Amenity amenity) {
    // DENTIST, CLINIC, DOCTORS, HOSPITAL, NURSING_HOME, SOCIAL_FACILITY, DOCTOR,PHARMACY
    switch (amenity) {
      case Amenity.DENTIST:
        return MarkerIcon.dentist.red;
      case Amenity.CLINIC:
        return MarkerIcon.clinic.red;
      case Amenity.DOCTORS:
        return MarkerIcon.doctors.red;
      case Amenity.HOSPITAL:
        return MarkerIcon.hospital.red;
      case Amenity.NURSING_HOME:
        return MarkerIcon.nursing.red;
      case Amenity.SOCIAL_FACILITY:
        return MarkerIcon.social.red;
      case Amenity.PHARMACY:
        return MarkerIcon.pharmacy.red;
      case Amenity.BABY_HATCH:
        return MarkerIcon.baby_hatch.red;
      case Amenity.DOCTOR:
        return MarkerIcon.doctors.red;
        break;
    }
  }

  static String getIconAssetBlue(Amenity amenity) {
    // DENTIST, CLINIC, DOCTORS, HOSPITAL, NURSING_HOME, SOCIAL_FACILITY, DOCTOR,PHARMACY
    switch (amenity) {
      case Amenity.DENTIST:
        return MarkerIcon.dentist.blue;
      case Amenity.CLINIC:
        return MarkerIcon.clinic.blue;
      case Amenity.DOCTORS:
        return MarkerIcon.doctors.blue;
      case Amenity.HOSPITAL:
        return MarkerIcon.hospital.blue;
      case Amenity.NURSING_HOME:
        return MarkerIcon.nursing.blue;
      case Amenity.SOCIAL_FACILITY:
        return MarkerIcon.social.blue;
      case Amenity.PHARMACY:
        return MarkerIcon.pharmacy.blue;
      case Amenity.BABY_HATCH:
        return MarkerIcon.baby_hatch.blue;
      case Amenity.DOCTOR:
        return MarkerIcon.doctors.blue;
        break;
    }
  }

  static List<Marker> listMarker(FeatureResponseHealth geoFeatures) {
    List<Marker> markers = [];

    List<Feature> features = geoFeatures.geometries.features;
    for (Feature pois in features) {
      final type = pois.properties.tags.amenity;

      Marker marker = new Marker(
        width: 30.0,
        height: 30.0,
        point:
            LatLng(pois.geometry.coordinates[1], pois.geometry.coordinates[0]),
        builder: (_) =>
            // Icon(AppIcons.hospital, size: 30.0, color: Colors.red,),
            Image.asset(
          getIconAsset(type),
        ),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      );
      markers.add(marker);
    }
    return markers;
  }

  static Feature getPois(Marker marker, FeatureResponseHealth geoFeatures) {
    List<Feature> features = geoFeatures.geometries.features;
//    List<Feature> featureList  = features.nursingHome.features + features.babyHatch.features + features.clinic.features +
//        features.dentist.features + features.clinic.features + features.doctors.features + features.hospital.features;
//    return null;
    for (Feature pois in features) {
      if (marker.point.latitude == pois.geometry.coordinates[1] &&
          marker.point.longitude == pois.geometry.coordinates[0]) {
        return pois;
      }
    }
  }

  static List<Marker> listFilteredMarker(filter.FeatureResponse geoFeatures) {
    List<Marker> markers = [];
    List<filter.Features> features = geoFeatures.geometries.features;
    for (filter.Features pois in features) {
      // final type = pois.properties.tags.amenity;
      final type = Amenity.values.firstWhere((e) =>
          e.toString().toLowerCase().split(".")[1] ==
          pois.properties.tags.amenity);
      Marker marker = new Marker(
        width: 30.0,
        height: 30.0,
        point:
            LatLng(pois.geometry.coordinates[1], pois.geometry.coordinates[0]),
        builder: (_) =>
            // Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
            Image.asset(
          getIconAsset(type),
        ),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      );
      markers.add(marker);
    }
    return markers;
  }

  static filter.Features getfilteredPois(
      Marker marker, filter.FeatureResponse geoFeatures) {
    print(marker.point);
    List<filter.Features> features = geoFeatures.geometries.features;
    for (filter.Features pois in features) {
      if (marker.point.latitude == pois.geometry.coordinates[1] &&
          marker.point.longitude == pois.geometry.coordinates[0]) {
        return pois;
      }
    }
  }

  // static List<Marker> listPharmacyMarker(
  //     pharmacy.FeatureResponsePharmacy geoFeatures) {
  //   List<Marker> markers = [];
  //   List<pharmacy.Feature> features = geoFeatures.geometries.features;
  //   for (pharmacy.Feature pois in features) {
  //     Marker marker = new Marker(
  //       width: 30.0,
  //       height: 30.0,
  //       point:
  //           LatLng(pois.geometry.coordinates[1], pois.geometry.coordinates[0]),
  //       builder: (_) =>
  //           Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
  //       anchorPos: AnchorPos.align(AnchorAlign.top),
  //     );
  //     markers.add(marker);
  //   }
  //   return markers;
  // }
  //
  // static pharmacy.Feature getPharmacyPois(
  //     Marker marker, pharmacy.FeatureResponsePharmacy geoFeatures) {
  //   print(marker.point);
  //   List<pharmacy.Feature> features = geoFeatures.geometries.features;
  //   for (pharmacy.Feature pois in features) {
  //     if (marker.point.latitude == pois.geometry.coordinates[1] &&
  //         marker.point.longitude == pois.geometry.coordinates[0]) {
  //       return pois;
  //     }
  //   }
  // }

  static Marker searchMarker(SearchItem searchResponse) {
    final type = Amenity.values.firstWhere((e) =>
        e.toString().toLowerCase().split(".")[1] ==
        searchResponse.geometries.properties.tags.amenity);
    return new Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(searchResponse.geometries.geometry.coordinates[1],
          searchResponse.geometries.geometry.coordinates[0]),
      builder: (_) =>
          // Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
          Image.asset(getIconAsset(type)),
      anchorPos: AnchorPos.align(AnchorAlign.top),
    );
  }

  static Marker searchMarkerByCoordinates(
      List<double> coordinates, String amenityType) {
    print(amenityType);
    final type = Amenity.values.firstWhere((e) =>
        e.toString().toLowerCase().split(".")[1] == amenityType.toLowerCase());
    return new Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(coordinates[1], coordinates[0]),
      builder: (_) =>
          // Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
          Image.asset(getIconAsset(type)),
      anchorPos: AnchorPos.align(AnchorAlign.top),
    );
  }

  static Widget _buildRatingStar(double rates) {
    return RatingBar.builder(
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.grey.withAlpha(50),
      itemCount: 5,
      initialRating: rates,
      itemSize: 20.0,
      // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      // onRatingUpdate: (rating) {
      //   print("rate");
      //   print(rating);
      // },
      updateOnDrag: false,
      onRatingUpdate: (double value) {},
    );
  }

  static List<LatLng> parseIntoLatlngPoints(
      List<List<List<double>>> coordinates) {
    List<LatLng> items = [];
    if (coordinates.isNotEmpty) {
      List<List<double>> list1 = coordinates.first;
      if (list1.isNotEmpty) {
        for (List<double> item in list1)
          if (item.length >= 2) items.add(LatLng(item[1], item[0]));
      }
    }
    return items;
  }

  static TextInputType getInputTextType(String tag) {
    if (tag.contains("phone"))
      return TextInputType.phone;
    else if (tag.contains("web") || tag.contains("facebook"))
      return TextInputType.url;
    if (tag.contains("email"))
      return TextInputType.emailAddress;
    else
      return TextInputType.text;
  }

  static Widget buildRatingStar(double rates) {
    return RatingBar.builder(
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.grey.withAlpha(50),
      itemCount: 5,
      initialRating: rates,
      itemSize: 20.0,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      updateOnDrag: false,
    );
  }
}
