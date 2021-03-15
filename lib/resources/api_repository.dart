import 'package:c2m2_mongolia/models/feature_request.dart';
import 'package:c2m2_mongolia/models/feature_response_health.dart';

import 'api_provider.dart';

class APIRepository {
  final apiProvider = APIProvider();

  Future<dynamic> filterData(FeatureRequest featureRequest) =>
      apiProvider.filterData(featureRequest);

  Future<FeatureResponseHealth> healthData(FeatureRequest featureRequest) =>
      apiProvider.healthData(featureRequest);

  Future<FeatureResponseHealth> pharmacyData(FeatureRequest featureRequest) =>
      apiProvider.pharmacyData(featureRequest);
}
