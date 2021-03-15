import 'package:c2m2_mongolia/models/feature_request.dart';
import 'package:c2m2_mongolia/models/feature_response.dart';
import 'package:c2m2_mongolia/models/feature_response_health.dart';
import 'package:c2m2_mongolia/resources/api_repository.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:rxdart/rxdart.dart';

class FeatureBloc {
  final _repository = APIRepository();
  final _filterResultsFetcher = PublishSubject<FeatureResponse>();
  final _healthResultsFetcher = PublishSubject<FeatureResponseHealth>();
  Stream<FeatureResponse> get allFilteredData => _filterResultsFetcher.stream;
  Stream<FeatureResponseHealth> get allHealthData =>
      _healthResultsFetcher.stream;

  fetchFilteredData(FeatureRequest request) async {
    FeatureResponse featureResponse = await _repository.filterData(request);
    _filterResultsFetcher.sink.add(featureResponse);
  }

  Future<FeatureResponseHealth> fetchHealthData() async {
    FeatureResponseHealth featureResponse = await _repository
        .healthData(new FeatureRequest(type: Strings.featureHealthServices));
    return featureResponse;
  }

  Future<FeatureResponseHealth> fetchPharmacyData() async {
    FeatureResponseHealth featureResponse = await _repository
        .pharmacyData(new FeatureRequest(type: Strings.featurePharmacy));
    return featureResponse;
  }

  dispose() {
    _filterResultsFetcher.close();
    _healthResultsFetcher.close();
  }
}

final featureBloc = FeatureBloc();
