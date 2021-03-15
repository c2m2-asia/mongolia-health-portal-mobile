import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/models/admin_boundary.dart' as admin_boundary;
import 'package:c2m2_mongolia/models/bookmark_model.dart';
import 'package:c2m2_mongolia/models/feature_filter_tags.dart';
import 'package:c2m2_mongolia/models/feature_request.dart';
import 'package:c2m2_mongolia/models/feature_review.dart';
import 'package:c2m2_mongolia/models/feature_tags.dart' as feature_tags;
import 'package:c2m2_mongolia/models/resources_response.dart';
import 'package:c2m2_mongolia/models/search_response.dart';
import 'package:c2m2_mongolia/resources/api_provider.dart';
import 'package:c2m2_mongolia/screens/filter_page.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final apiService = Provider((ref) => APIProvider());

//feature notifiers
final featureTypeProvider =
    ChangeNotifierProvider((ref) => FeatureTypeNotifier(ref));

//filter notifiers
final filterTagsProvider = ChangeNotifierProvider<FilterTagsNotifier>(
    (ref) => FilterTagsNotifier(ref));
final filterResponseProvider = ChangeNotifierProvider<FilterResponseNotifier>(
    (ref) => FilterResponseNotifier(ref));
final filterRequestProvider = ChangeNotifierProvider<FilterRequestNotifier>(
    (ref) => FilterRequestNotifier(ref));
final filterAdminBoundaryProvider =
    ChangeNotifierProvider<FilterByAdminBoundaryNotifier>(
        (ref) => FilterByAdminBoundaryNotifier(ref));
final filterTypesProvider =
    ChangeNotifierProvider((ref) => FilterByTypesNotifier());
final filterByCategoryProvider =
    ChangeNotifierProvider((ref) => FilterByCategoryNotifier());
final wheelchairVisibilityProvider =
    ChangeNotifierProvider((ref) => WheelChairVisibilityNotifier());
final wheelchairProvider =
    ChangeNotifierProvider((ref) => WheelChairNotifier());
final openingHoursVisibilityProvider =
    ChangeNotifierProvider((ref) => OpeningHoursVisibilityNotifier());
final openingHoursProvider =
    ChangeNotifierProvider((ref) => OpeningHoursNotifier());
final operatorStatusVisibilityProvider =
    ChangeNotifierProvider((ref) => OperatorStatusVisibilityNotifier());
final operatorStatusProvider =
    ChangeNotifierProvider((ref) => OperatorStatusNotifier());

//search notifiers
final searchResponseProvider = ChangeNotifierProvider<SearchResponseNotifier>(
    (ref) => SearchResponseNotifier(ref));
final selectedSearchFeatureProvider =
    ChangeNotifierProvider((ref) => SelectedFeatureNotifier(ref));

//bookmark notifiers
final detailShownFeatureProvider =
    ChangeNotifierProvider((ref) => DetailShownFeatureNotifier(ref));
final selectedBookmarkFeatureProvider =
    ChangeNotifierProvider((ref) => SelectedBookmarkNotifier(ref));

//review notifiers
final reviewProvider =
    ChangeNotifierProvider<ReviewNotifier>((ref) => ReviewNotifier(ref));
final reviewPublisher =
    ChangeNotifierProvider<ReviewPublisher>((ref) => ReviewPublisher(ref));
final reviewScrollNotifier =
    ChangeNotifierProvider((ref) => ReviewScrollNotifier());

//Tags notifier
final tagProvider =
    ChangeNotifierProvider<TagsNotifier>((ref) => TagsNotifier(ref));

//Resources notifier
final resourceProvider = ChangeNotifierProvider<ResourceResponseNotifier>(
    (ref) => ResourceResponseNotifier(ref));

class FeatureTypeNotifier extends ChangeNotifier {
  String _value = Strings.featureHealthServices;

  String get value => _value;

  ProviderReference ref;

  FeatureTypeNotifier(this.ref);

  void toggle(DrawerSelection selectedValue) {
    if (selectedValue == (DrawerSelection.health))
      _value = Strings.featureHealthServices;
    else if (selectedValue == (DrawerSelection.pharmacy))
      _value = Strings.featurePharmacy;

    //reset filters if on feature type change
    // resetFilters();
    //for dynamic filters API
    ref.read(filterRequestProvider).resetFilters();
    notifyListeners();
  }

  void resetFilters() {
    ref.read(filterTypesProvider).removeAll();
    ref.read(filterByCategoryProvider).removeAll();
    ref.read(filterAdminBoundaryProvider).removeAll();
    ref.read(wheelchairVisibilityProvider).toggle(false);
    ref.read(openingHoursVisibilityProvider).toggle(false);
    ref.read(operatorStatusVisibilityProvider).toggle(false);
    ref.read(wheelchairProvider).toggle(0);
    ref.read(openingHoursProvider).toggle(0);
    ref.read(operatorStatusProvider).toggle(0);
  }
}

class WheelChairVisibilityNotifier extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void toggle(bool selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class WheelChairNotifier extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void toggle(int selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class OpeningHoursVisibilityNotifier extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void toggle(bool selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class OpeningHoursNotifier extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void toggle(int selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class OperatorStatusVisibilityNotifier extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void toggle(bool selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class OperatorStatusNotifier extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void toggle(int selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class FilterByAdminBoundaryNotifier extends ChangeNotifier {
  admin_boundary.AdminBoundary selectedKhoroo;
  List<admin_boundary.AdminBoundary> boundaryList = [];
  List<admin_boundary.AdminBoundary> khorooList = [];
  List<admin_boundary.Division> districtList = [];
  admin_boundary.Division selectedDistrict;
  bool isLoading = false;
  String error;
  admin_boundary.AdminBoundaryResponse response;
  ProviderReference ref;

  FilterByAdminBoundaryNotifier(this.ref);

  admin_boundary.Division get selectedDistrictValue => selectedDistrict;

  admin_boundary.AdminBoundary get selectedKhorooValue => selectedKhoroo;

  List<admin_boundary.AdminBoundary> get khoroos => khorooList;

  List<admin_boundary.Division> get districts => districtList;

  List<admin_boundary.AdminBoundary> get boundaries => boundaryList;

  fetchAdminBoundary() async {
    try {
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response = await ref.read(apiService).getAdminBoundaries();
      if (response != null) setAdminBoundaries(response.data);
    } catch (error) {
      this.error = error.toString();
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  void setAdminBoundaries(List<admin_boundary.AdminBoundary> type) {
    boundaryList = type;
    setDistrictList(type[0].divisions);
  }

  void setDistrictList(List<admin_boundary.Division> type) {
    districtList.clear();
    districtList.add(new admin_boundary.Division(
        label: admin_boundary.Label(mn: "All", en: "All"), divisions: []));
    districtList.addAll(type);
    selectedDistrict = districtList.first;
  }

  void toggleDistrict(admin_boundary.Division type) {
    selectedDistrict = type;
    khorooList.clear();
    if (type.label.en != "All" || type.label.mn != "All") {
      khorooList
          .add(new admin_boundary.AdminBoundary(label: "All", divisions: []));
      khorooList.addAll(type.divisions);
      selectedKhoroo = khorooList.first;
    }
    notifyListeners();
  }

  void toggleKhoroo(admin_boundary.AdminBoundary type) {
    selectedKhoroo = type;
    notifyListeners();
  }

  void removeAll() {
    print("remove all $boundaryList");
    if (boundaryList.isNotEmpty) selectedDistrict = districtList.first;
    khorooList.clear();
    notifyListeners();
  }
}

class FilterByTypesNotifier extends ChangeNotifier {
  List<FilterType> selectedChoices = getFilterTypes();
  String selectedService;

  List<FilterType> get value => selectedChoices;

  FilterType singleSelectedChoice;

  FilterType get singleSelectedValue => singleSelectedChoice;

  void toggle(FilterType type) {
    singleSelectedChoice = type;
    notifyListeners();
  }

  void setSelectedItems(List<String> type) {
    selectedService = "";
    for (String filterType in type)
      if (filterType == type.first)
        selectedService = selectedService + filterType;
      else
        selectedService = selectedService + ";" + filterType;
    notifyListeners();
  }

  void removeSelectedChoice() {
    singleSelectedChoice = null;
    notifyListeners();
  }

  void add(FilterType type) {
    type.isCheck = !type.isCheck;
    notifyListeners();
  }

  void removeAll() {
    selectedChoices = getFilterTypes();
    notifyListeners();
  }

  List<FilterType> getSelected() {
    return selectedChoices.where((element) => element.isCheck).toList();
  }

  static List<FilterType> getFilterTypes() {
    return <FilterType>[
      FilterType(title: "Maternity", isCheck: false, filterTag: "maternity"),
      FilterType(
          title: "Dermatology", isCheck: false, filterTag: "dermatology"),
      FilterType(
          title: "Plastic Surgery",
          isCheck: false,
          filterTag: "plastic_surgery"),
      FilterType(
          title: "Reconstructive surgery",
          isCheck: false,
          filterTag: "reconstructive_surgery"),
      FilterType(
          title: "Internal medicine",
          isCheck: false,
          filterTag: "internal_medicine"),
      FilterType(title: "Radiology", isCheck: false, filterTag: "radiology"),
      FilterType(title: "Neurology", isCheck: false, filterTag: "neurology"),
      FilterType(
          title: "Trauma & surgery",
          isCheck: false,
          filterTag: "trauma;surgery"),
      FilterType(
          title: "Ophthalmology", isCheck: false, filterTag: "ophthalmology"),
      FilterType(
          title: "Rehabilitation", isCheck: false, filterTag: "rehabilitation"),
      FilterType(title: "Psychiatry", isCheck: false, filterTag: "psychiatry"),
      FilterType(
          title: "Traditional", isCheck: false, filterTag: "traditional"),
      FilterType(title: "Urology", isCheck: false, filterTag: "urology"),
      FilterType(
          title: "Oncology & palliative",
          isCheck: false,
          filterTag: "oncology;palliative"),
      FilterType(
          title: "Infectious diseases",
          isCheck: false,
          filterTag: "infectious_disease"),
      FilterType(title: "Pediatric", isCheck: false, filterTag: "pediatric"),
      // FilterType(title: "Emergency 24 hour", isCheck: false),
      FilterType(title: "ENT", isCheck: false, filterTag: "ent"),
      FilterType(
          title: "Blood donation center",
          isCheck: false,
          filterTag: "blood_donation_center"),
      FilterType(title: "Laboratory", isCheck: false, filterTag: "laboratory"),
      FilterType(title: "Dental", isCheck: false, filterTag: "dentist"),
      FilterType(
          title: "Intensive care", isCheck: false, filterTag: "intensive_care"),
      FilterType(
          title: "Obstetrics & gynocology",
          isCheck: false,
          filterTag: "obstetrics;gynaecology"),
      FilterType(title: "Andrology", isCheck: false, filterTag: "andrology"),
      FilterType(title: "Veterinary", isCheck: false, filterTag: "veterinary"),
      FilterType(
          title: "Primary care", isCheck: false, filterTag: "primary_care"),
      FilterType(
          title: "Reproductive health",
          isCheck: false,
          filterTag: "reproductive_health"),
      FilterType(
          title: "Gerontology", isCheck: false, filterTag: "gerontology"),
      FilterType(title: "Other", isCheck: false, filterTag: "general"),
    ];
  }
}

class FilterByCategoryNotifier extends ChangeNotifier {
  FilterType selectedChoices = getFilterCategories().first;

  FilterType get selectedCategoryValue => selectedChoices;

  List<FilterType> get value => getFilterCategories();

  void toggle(FilterType type) {
    selectedChoices = type;
    notifyListeners();
  }

  void removeAll() {
    selectedChoices = value.first;
    notifyListeners();
  }

  static List<FilterType> getFilterCategories() {
    return <FilterType>[
      FilterType(title: "Any", filterTag: "any"),
      FilterType(title: "Family clinic", filterTag: "family_clinic"),
      FilterType(
          title: "Soum, town family clinic",
          filterTag: "Soum_town_family_clinic"),
      FilterType(title: "Palliative care", filterTag: "palliative_care"),
      FilterType(title: "Clinic", filterTag: "clinic"),
      FilterType(title: "Maternity center", filterTag: "maternity_center"),
      FilterType(
          title: "Public health center", filterTag: "public_health_center"),
      FilterType(
          title: "Integrated hospital	", filterTag: "integrated_hospital"),
      FilterType(
          title: "Health & wellness resort",
          filterTag: "health_and_wellness_resort"),
      FilterType(title: "Emergency center", filterTag: "emergency_center"),
      FilterType(
          title: "Rehabilitation center", filterTag: "rehabilitation_center"),
      FilterType(title: "Special hospital", filterTag: "special_hospital"),
      FilterType(title: "Specialist center", filterTag: "specialist_center"),
      FilterType(
          title: "Multi-specialist hospital",
          filterTag: "multi-specialist_hospital"),
      FilterType(title: "Nursing home", filterTag: "nursing_home"),
      FilterType(
          title: "Traditional medicine integrated hospital",
          filterTag: "traditional_medicine_integrated_hospital"),
    ];
  }
}

class FilterRequestNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  Map<String, List<feature_tags.Selector>> multiTypeSelectedFilters;
  Map<String, feature_tags.Selector> singleTypeSelectedFilters;
  List<feature_tags.Selector> values;

  FilterRequestNotifier(this.ref);

  addMultiSelectableFilter(String osmTag, feature_tags.Selector selector) {
    if (multiTypeSelectedFilters == null) multiTypeSelectedFilters = Map();
    values = multiTypeSelectedFilters[osmTag];
    if (values == null) values = [];
    if (values.contains(selector))
      values.remove(selector);
    else
      values.add(selector);

    multiTypeSelectedFilters.update(osmTag, (value) => values,
        ifAbsent: () => values);
    notifyListeners();
  }

  addSingleSelectableFilter(String osmTag, feature_tags.Selector selector) {
    if (singleTypeSelectedFilters == null) singleTypeSelectedFilters = Map();
    singleTypeSelectedFilters.update(osmTag, (value) => selector,
        ifAbsent: () => selector);
    notifyListeners();
  }

  setInitialValue(String osmTag, feature_tags.Selector selectedItem) {
    if (singleTypeSelectedFilters == null) singleTypeSelectedFilters = Map();
    singleTypeSelectedFilters.putIfAbsent(osmTag, () => selectedItem);
    notifyListeners();
  }

  bool checkIfTheSingleSelectableFiltersAreEmpty() {
    bool isEmpty = true;
    if (singleTypeSelectedFilters == null || singleTypeSelectedFilters.isEmpty)
      isEmpty = true;
    else {
      singleTypeSelectedFilters.values.forEach((element) {
        if (element != null && element.osmValue != null) isEmpty = false;
        return;
      });
    }
    return isEmpty;
  }

  bool checkIfTheMultiSelectableFiltersAreEmpty() {
    bool isEmpty = true;
    if (multiTypeSelectedFilters == null || multiTypeSelectedFilters.isEmpty)
      isEmpty = true;
    else {
      multiTypeSelectedFilters.values.forEach((element) {
        if (element != null && element.isNotEmpty) isEmpty = false;
        return;
      });
    }
    return isEmpty;
  }

  resetFilters() {
    singleTypeSelectedFilters = Map();
    multiTypeSelectedFilters = Map();
    ref.read(filterAdminBoundaryProvider).removeAll();
    FilterTags filterTags = ref.read(filterTagsProvider).response;
    if (filterTags != null)
      for (Datum datum in filterTags.data) {
        String value =
            Strings.filterFeatures[ref.read(featureTypeProvider).value];
        if (value == datum.value) {
          for (feature_tags.EditTag editTag in datum.filterTags)
            if (editTag.type == feature_tags.Type.MULTI_SELECT)
              editTag.selectors.forEach((element) {
                element.isChecked = false;
              });
        }
      }
    notifyListeners();
  }
}

class FilterResponseNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  dynamic response;

  FilterResponseNotifier(this.ref);

  addFilter() async {
    try {
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response =
          await ref.read(apiService).filterData(getDynamicFilterRequest());
    } catch (error) {
      this.error = error.toString();
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  FeatureRequest getDynamicFilterRequest() {
    FeatureRequest request = new FeatureRequest();
    String featureType = ref.read(featureTypeProvider).value;
    request.type = featureType;
    request.city = Strings.ulaanbaatarCity;

    List<Filters> filters = [];

    //filter by admin boundary
    admin_boundary.Division district =
        ref.read(filterAdminBoundaryProvider).selectedDistrict;
    admin_boundary.AdminBoundary khoroo =
        ref.read(filterAdminBoundaryProvider).selectedKhoroo;
    if (district != null && district.label != "All") {
      request.district = district.id;
    }
    if (khoroo != null && khoroo.label != "All") {
      request.khoroo = khoroo.id;
    }

    //single selectable views
    if (!ref
        .read(filterRequestProvider)
        .checkIfTheSingleSelectableFiltersAreEmpty()) {
      ref
          .read(filterRequestProvider)
          .singleTypeSelectedFilters
          .forEach((key, value) {
        List<String> values = [];
        if (value.osmValue != null) {
          values.add(value.osmValue);
          filters.add(Filters(osmTag: key, osmValue: values));
        }
      });
    }

    //multi selectable views
    if (!ref
        .read(filterRequestProvider)
        .checkIfTheMultiSelectableFiltersAreEmpty()) {
      ref
          .read(filterRequestProvider)
          .multiTypeSelectedFilters
          .forEach((key, value) {
        List<String> values = [];
        if (value != null || value.isNotEmpty) {
          for (feature_tags.Selector selector in value)
            values.add(selector.osmValue);
          filters.add(Filters(osmTag: key, osmValue: values));
        }
      });
    }

    if (filters.isNotEmpty) request.filters = filters;
    return request;
  }

  FeatureRequest getFilterRequest() {
    FeatureRequest request = new FeatureRequest();
    String featureType = ref.read(featureTypeProvider).value;
    request.type = featureType;
    request.city = Strings.ulaanbaatarCity;

    List<Filters> filters = [];
    //filter by type
    if (ref.read(filterTypesProvider).getSelected().isNotEmpty) {
      List<String> selectedHealthCare = [];
      for (FilterType type in ref.read(filterTypesProvider).getSelected())
        selectedHealthCare.add(type.filterTag);
      filters.add(
          Filters(osmTag: Strings.filterByType, osmValue: selectedHealthCare));
    }

    //filter by admin boundary
    admin_boundary.Division district =
        ref.read(filterAdminBoundaryProvider).selectedDistrict;
    admin_boundary.AdminBoundary khoroo =
        ref.read(filterAdminBoundaryProvider).selectedKhoroo;
    if (district != null && district.label != "All") {
      request.district = district.id;
    }
    if (khoroo != null && khoroo.label != "All") {
      request.khoroo = khoroo.id;
    }

    //filter by category
    if (ref.read(filterByCategoryProvider).selectedChoices.title != "Any") {
      List<String> selectedCategories = [];
      selectedCategories
          .add(ref.read(filterByCategoryProvider).selectedChoices.filterTag);
      filters.add(Filters(
          osmTag: Strings.filterByCategory, osmValue: selectedCategories));
    }

    //filter by wheelchair accessibility
    if (ref.read(wheelchairVisibilityProvider).value) {
      List<String> selectedWheelChair = [];
      ref.read(wheelchairProvider).value == 0
          ? selectedWheelChair.add("yes")
          : selectedWheelChair.add("no");
      filters.add(Filters(
          osmTag: Strings.filterByWheelChair, osmValue: selectedWheelChair));
    }

    //filter by operator type
    if (ref.read(operatorStatusVisibilityProvider).value) {
      List<String> selectedOperatorStatus = [];
      ref.read(operatorStatusProvider).value == 0
          ? selectedOperatorStatus.add("public")
          : ref.read(operatorStatusProvider).value == 1
              ? selectedOperatorStatus.add("private")
              : selectedOperatorStatus.add("public owned, private operated");
      filters.add(Filters(
          osmTag: Strings.filterByOperatorType,
          osmValue: selectedOperatorStatus));
    }
    //filter by opening 24 hours
    if (ref.read(openingHoursVisibilityProvider).value) {
      List<String> selectedOpeningHours = [];
      ref.read(openingHoursProvider).value == 0
          ? selectedOpeningHours.add("24/7")
          : selectedOpeningHours.add("no");
      filters.add(Filters(
          osmTag: Strings.filterByOpeningHours,
          osmValue: selectedOpeningHours));
    }

    if (filters.isNotEmpty) request.filters = filters;
    return request;
  }

  void remove() {
    response = null;
    notifyListeners();
  }
}

class SearchResponseNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  List<SearchItem> response = [];
  SearchResponse searchResponse;

  SearchResponseNotifier(this.ref);

  searchData(String query) async {
    try {
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      String featureType = ref.read(featureTypeProvider).value;
      response = await ref.read(apiService).searchData(query, featureType);
    } catch (error) {
      this.error = error.toString();
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  void clearAll() {
    if (response != null) response.clear();
    notifyListeners();
  }

  bool get isRequestLoading => isLoading;
}

class ResourceResponseNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  ResourcesResponse response;
  Resource resource;

  ResourceResponseNotifier(this.ref);

  fetchResource() async {
    print("fetch resource");
    try {
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response = await ref.read(apiService).getResourceData();
    } catch (error) {
      this.error = error.toString();
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  bool get isRequestLoading => isLoading;
}

class SelectedFeatureNotifier extends ChangeNotifier {
  SearchItem _value;
  ProviderReference ref;

  SearchItem get value => _value;

  SelectedFeatureNotifier(this.ref);

  void toggle(SearchItem selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }

  void remove() {
    _value = null;
    notifyListeners();
  }
}

class DetailShownFeatureNotifier extends ChangeNotifier {
  BookmarkItem _value;
  ProviderReference ref;

  BookmarkItem get value => _value;

  DetailShownFeatureNotifier(this.ref);

  void toggle(BookmarkItem selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }

  void remove() {
    _value = null;
    notifyListeners();
  }
}

class SelectedBookmarkNotifier extends ChangeNotifier {
  BookmarkItem _value;
  ProviderReference ref;

  BookmarkItem get value => _value;

  SelectedBookmarkNotifier(this.ref);

  void toggle(BookmarkItem selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }

  void remove() {
    _value = null;
    notifyListeners();
  }
}

class ReviewPublisher extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  PostReview postReviewResponse;
  Result response;

  ReviewPublisher(this.ref);

  publishReview(ReviewsRequest request) async {
    try {
      error = null;
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      postReviewResponse = await ref.read(apiService).postReview(request);
      if (postReviewResponse != null) response = postReviewResponse.data;
    } catch (error) {
      this.isLoading = false;
      this.error = error.toString();
      print("review error response $error");
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  bool get isRequestLoading => isLoading;
}

class ReviewNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  Reviews response;

  ReviewNotifier(this.ref);

  getReview(String serviceId) async {
    try {
      error = null;
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response = await ref.read(apiService).featureReview(serviceId);
    } catch (error) {
      this.error = error.toString();
      this.isLoading = false;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  bool get isRequestLoading => isLoading;
}

class ReviewScrollNotifier extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  void toggle(bool selectedValue) {
    _value = selectedValue;
    notifyListeners();
  }
}

class TagsNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  feature_tags.OsmTags response;

  TagsNotifier(this.ref);

  getEditTags() async {
    try {
      error = null;
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response = await ref.read(apiService).getEditTags();
    } catch (error) {
      this.error = error.toString();
      this.isLoading = false;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  bool get isRequestLoading => isLoading;
}

class FilterTagsNotifier extends ChangeNotifier {
  bool isLoading = false;
  String error;
  ProviderReference ref;
  FilterTags response;

  FilterTagsNotifier(this.ref);

  getFilterTags() async {
    try {
      error = null;
      this.isLoading = true;
      notifyListeners();
      //finally sending data to API
      response = await ref.read(apiService).getFilterTags();
      if (response == null) error = "Some error occurred";
    } catch (error) {
      this.error = error.toString();
      this.isLoading = false;
      notifyListeners();
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  bool get isRequestLoading => isLoading;
}
