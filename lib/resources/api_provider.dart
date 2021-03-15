import 'dart:async';
import 'dart:convert';

import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/models/admin_boundary.dart';
import 'package:c2m2_mongolia/models/feature_filter_tags.dart';
import 'package:c2m2_mongolia/models/feature_request.dart';
import 'package:c2m2_mongolia/models/feature_response.dart';
import 'package:c2m2_mongolia/models/feature_response_health.dart';
import 'package:c2m2_mongolia/models/feature_review.dart';
import 'package:c2m2_mongolia/models/feature_tags.dart';
import 'package:c2m2_mongolia/models/resources_response.dart';
import 'package:c2m2_mongolia/models/search_response.dart';
import 'package:c2m2_mongolia/requests/api_request_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class APIProvider {
  Dio dio;
  Response response;

  APIProvider() {
    dio = APIRequestHandler().createDio();
    if (kDebugMode) APIRequestHandler().addInterceptors(dio);
  }

  Future<dynamic> filterData(FeatureRequest featureRequest) async {
    try {
      final response =
          await dio.post("features", data: jsonEncode(featureRequest));
      dynamic responseToBeSent;
      if (response.statusCode == 200) {
        try {
          responseToBeSent =
              FeatureResponse.fromJson(json.decode(response.data));
        } catch (exception) {
          responseToBeSent =
              FeatureResponseHealth.fromJson(json.decode(response.data));
        }
        return responseToBeSent;
      }
    } on DioError catch (e) {}
  }

  Future<FeatureResponseHealth> healthData(
      FeatureRequest featureRequest) async {
    try {
      final response =
          await dio.post("features", data: jsonEncode(featureRequest));
      if (response.statusCode == 200) {
        return new FeatureResponseHealth.fromJson(json.decode(response.data));
      }
    } on DioError catch (e) {}
  }

  Future<FeatureResponseHealth> pharmacyData(
      FeatureRequest featureRequest) async {
    try {
      final response =
          await dio.post("features", data: jsonEncode(featureRequest));
      if (response.statusCode == 200) {
        return new FeatureResponseHealth.fromJson(json.decode(response.data));
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }

  Future<Reviews> featureReview(String serviceId) async {
    try {
      final response = await dio.get("review/service/$serviceId");
      return Reviews.fromJson(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }

  Future<PostReview> postReview(ReviewsRequest request) async {
    try {
      final response =
          await dio.post("review", data: jsonEncode(request.toJson()));
      if (response.statusCode == 200) return PostReview.fromMap(response.data);
    } on DioError catch (e) {}
  }

  Future<List<SearchItem>> searchData(String query, String type) async {
    List<SearchItem> searchResponses = <SearchItem>[];
    var queryMap = {"type": type};
    try {
      final response =
          await dio.get("search/$query", queryParameters: queryMap);
      searchResponses =
          (SearchResponse.fromMap(response.data).result).map((x) => x).toList();
    } on DioError catch (e) {}
    return searchResponses;
  }

  Future<ResourcesResponse> getResourceData() async {
    try {
      final response = await dio.get("resource");
      print("success $response");
      return ResourcesResponse.fromMap(response.data);
    } on DioError catch (e) {
      print("resoucre error $e");
    }
  }

  Future<OsmTags> getEditTags() async {
    try {
      final response = await dio.get("amenities/tags?tags=edit");
      return OsmTags.fromJson(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }

  Future<FilterTags> getFilterTags() async {
    try {
      final response = await dio.get("amenities/tags?tags=filter");
      return FilterTags.fromJson(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }

  Future<AdminBoundaryResponse> getAdminBoundaries() async {
    try {
      final response = await dio.get("location");
      // if (response.statusCode == 200) {
      return AdminBoundaryResponse.fromMap(response.data);
      // }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
    }
  }
}
