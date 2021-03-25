class Strings {
  static String API_BASE_URL = "https://c2m2mongolia.klldev.org/api/v1/";
  static String appName = "Mongolia Health Portal";
  static String filterHealthServicesDescription =
      "To apply filter to the health services, please choose from the given set of filters. Filters will be applied once you click the filter button";
  static String filterPharmacyDescription =
      "To apply filter to the pharmacies, please choose from the given set of filters. Filters will be applied once you click the filter button";
  static String ulaanbaatarCity = "Ulaanbaatar";
  static String filterByType = "healthcare:speciality";
  static String filterByCategory = "Healthcare_facility:type";
  static String filterByOperatorType = "operator:type";
  static String filterByWheelChair = "wheelchair";
  static String filterByOpeningHours = "opening_hours";
  static String filterByDistrict = "All";
  static String filterByKhoroo = "khoroo";

  static const String featureHealthServices = "healthServices";
  static const String featurePharmacy = "pharmacies";

  static var filterFeatures = {'healthServices':'healthService','pharmacies':'pharmacy'};

  static String aboutSubtitle =
      "Accumulating health services data with OpenStreetMap";
  static String aboutDescription =
      "Public Lab Mongolia, the local partner of C2M2 Mongolia project, with help from Kathmandu Living Labs, has been spearheading the ground effort to produce robust geospatial data for Mongolia following the COVID-19 impact. It is hoped that the critical infrastructure information made open here plays an integral part in keeping both yourself and your neighbors healthy.";
  static String aboutPLM =
      "Public Lab Mongolia \nMargad Center - 301, khoroo 8 \n"
      "Sukhbaatar district, Ulaanbaatar, Mongolia";

  static String aboutKLL = "Kathmandu Living Labs \n"
      "1474, Lamtangin Marga \n"
      "Chundevi, Kathmandu, Nepal";

  static String websitePLM = "https://www.publiclabmongolia.org/";
  static String websiteKLL = "http://kathmandulivinglabs.org/";
  static String emailPLM = "info@publiclabmongolia.org";
  static String emailKLL = "contact@kathmandulivinglabs.org";

  static String availableSoon = "Will be available soon!";

  static const String BOOKMARKS_BOX = "bookmarksBox";
  static const String LANGUAGE_BOX = "languageBox";
  static const String SELECTED_LANGUAGE = "selectedLanguage";

  //translations
  static const String APP_NAME = "app_name";
  static const String SEARCH_PAGE_TITLE = "search_page_title";

  static const String FILTER_PAGE_TITLE = "filter_page_title";
  static const String FILTER_BY_CATEGORY_TITLE = "filter_by_category_title";
  static const String FILTER_PAGE_RESET_BUTTON = "filter_page_reset_title";
}
