//import 'dart:collection';
//import 'dart:html';

//For JSON convert
import 'dart:async';
import 'dart:convert';

import 'package:c2m2_mongolia/blocs/feature_bloc.dart';
import 'package:c2m2_mongolia/mapfeature/FeatureHelper.dart';
import 'package:c2m2_mongolia/mapfeature/GeoFeatures.dart';
import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/DetailCenter.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/DetailTop.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/LoadMoreButton.dart';
import 'package:c2m2_mongolia/models/bookmark_model.dart';
import 'package:c2m2_mongolia/models/feature_response.dart';
import 'package:c2m2_mongolia/models/feature_response_health.dart' as health;
import 'package:c2m2_mongolia/models/search_response.dart';
import 'package:c2m2_mongolia/screens/about_page.dart';
import 'package:c2m2_mongolia/screens/bookmarks_page.dart';
import 'package:c2m2_mongolia/screens/filter_page_dynamic.dart';
import 'package:c2m2_mongolia/screens/language_settings_page.dart';
import 'package:c2m2_mongolia/screens/resources_page.dart';
import 'package:c2m2_mongolia/screens/search_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/state/application.dart';
import 'package:c2m2_mongolia/ui/app_theme.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:user_location/user_location.dart';

import 'localizations/translations.dart';
import 'mapfeature/osm_oauth2.dart';

part 'hive/main.g.dart';

Future<String> getJson() {
  return rootBundle.loadString('assets/pokharafeature.json');
}

Future<String> getcJson() {
  return rootBundle.loadString('assets/mongoliahealth.json');
}

Future<health.FeatureResponseHealth> loadcFeatures() async {
  String jsonString = await getcJson();
  final jsonResponse = json.decode(jsonString);
  final hFeatures = health.FeatureResponseHealth.fromJson(jsonResponse);
  print(hFeatures.message);
  return hFeatures;
}

Future<GeoFeatures> loadFeatures() async {
  String jsonString = await getJson();
  final jsonResponse = json.decode(jsonString);
  return new GeoFeatures.fromJson(jsonResponse);
}

@HiveType(typeId: 3)
enum FeatureType {
  @HiveField(0)
  HEALTH_SERVICES,
  @HiveField(1)
  PHARMACY
}

ProviderReference ref;

Future<void> main() async {
  //Load JSON
  WidgetsFlutterBinding.ensureInitialized();
  initializeHiveDb();
  // await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

Future<void> initializeHiveDb() async {
  await Hive.initFlutter();
  Hive.registerAdapter<InfoDetail>(InfoDetailAdapter());
  Hive.registerAdapter<TitleDetail>(TitleDetailAdapter());
  Hive.registerAdapter<BookmarkItem>(BookmarkItemAdapter());
  Hive.registerAdapter<FeatureType>(FeatureTypeAdapter());
  Hive.registerAdapter<FeaturePair>(FeaturePairAdapter());
  await Hive.openBox(Strings.BOOKMARKS_BOX);
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();

    /// Initialize a new Localization Delegate with which you can force a new Translations when the user selects a new working language.
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);

    /// Save the pointer to this method. When the user changes the language, we can call applic.onLocaleChanged(new Locale('en',''));, through SetState() we can force the app to refresh.
    application.onLocaleChanged = onLocaleChange;
  }

  /// The application refresh core when changing the language. Each time a new language is selected, a new SpecificLocalizationDelegate instance is created, forcing the Translations class to refresh.
  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.appName,
      theme: AppThemeDataFactory.prepareThemeData(),
      home: MyHomePage(title: Strings.appName),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        _localeOverrideDelegate, // register a new delegate
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),
      // We have a global APPLICATION class to hold the settings
    );
  }
}

enum DrawerSelection { health, pharmacy, language, bookmark, about }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController;
  DrawerSelection _drawerSelection = DrawerSelection.health;
  UserLocationOptions userLocationOptions;
  FeatureType featureType;

  // ADD THIS
  List<Marker> markers = [];
  List<Marker> markercluster = [];
  Marker marker = new Marker(
    width: 40.0,
    height: 40.0,
    point: LatLng(47.918415, 106.871712),
    builder: (_) => Icon(Icons.location_on, size: 40.0),
    anchorPos: AnchorPos.align(AnchorAlign.top),
  );
  final PopupController _popupController = PopupController();
  Marker pastMarker;

  health.FeatureResponseHealth pFeature;
  health.FeatureResponseHealth gFeatures;
  LatLngBounds latLngBounds;
  bool fromSearch, bottomOpen;
  SearchItem searchResponse;
  BookmarkItem bookmarkItem;
  List<List<List<List<double>>>> multiCoordinates = [];

  //login
  FlutterWebviewPlugin _flutterWebviewPlugin;
  oauth1.AuthorizationResponse _authorizationResponse;
  OSMClient osmClient = new OSMClient();
  String userLog = "Login";
  String user = "Mongolia Health Portal";
  String userId = "";
  LatLng myPosition;
  final topBound =
      LatLngBounds(LatLng(48.7385, 105.4064), LatLng(47.1416, 108.6748));

  @override
  initState() {
    mapController = MapController();
    featureType = FeatureType.HEALTH_SERVICES;
    latLngBounds = topBound;
    fromSearch = false;
    bottomOpen = false;
    checkLog();
    initDynamicLinks();

    //from login
    _flutterWebviewPlugin = FlutterWebviewPlugin()
      ..onUrlChanged.listen((url) {
        final uri = Uri.parse(url);
        if (uri.host == "login-callback") {
          final verifier = uri.queryParameters["oauth_verifier"];
          _flutterWebviewPlugin.close();
          var auth = new oauth1.Authorization(clientCredentials, platform);
          auth
              .requestTokenCredentials(
                  _authorizationResponse.credentials, verifier)
              .then((res) async {
            final userDetail = await osmClient.saveCred(res, clientCredentials);
            if (userDetail != null)
              setState(() {
                userLog = "Logout";
                user = userDetail.userName;
                userId = userDetail.userId;
              });
          });
        }
      });
    super.initState();
  }

  fromEdit(OSMUser osmUser) {
    setState(() {
      userLog = "Logout";
      user = osmUser.userName;
      userId = osmUser.userId;
    });
  }

  Future<void> checkLog() async {
    String value = await secureStorage.read(key: "token");
    if (value == null) {
      setState(() {
        userLog = "Login";
        this.user = "Mongolia Health Portal";
        this.userId = "";
      });
    } else {
      String user = await secureStorage.read(key: "userName");
      String userId = await secureStorage.read(key: "userId");
      setState(() {
        userLog = "Logout";
        this.user = user;
        this.userId = userId;
        print(value);
      });
    }
  }

  clearLog() async {
    String value = await secureStorage.read(key: "token");
    if (value != null) {
      await secureStorage.delete(key: "token");
      await secureStorage.delete(key: "tokenSecret");
      await secureStorage.delete(key: "userId");
      await secureStorage.delete(key: "userName");
    }
    showToast("Logout successful");
    setState(() {
      userLog = "Login";
      this.user = "Mongolia Health Portal";
      this.userId = "";
    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        loadPreferred(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      loadPreferred(deepLink);
    } else {
      loadHealth(false);
    }
  }

  loadPreferred(Uri deepLink) async {
    String linkType = deepLink.queryParameters['type'];
    final type = FeatureType.values
        .firstWhere((element) => element.toString() == linkType);
    final id = deepLink.queryParameters['service_id'];

    switch (type) {
      case FeatureType.HEALTH_SERVICES:
        context.read(featureTypeProvider).toggle(DrawerSelection.health);
        setState(() {
          _drawerSelection = DrawerSelection.health;
          featureType = type;
        });
        loadHealth(true, serviceId: id);
        break;
      case FeatureType.PHARMACY:
        context.read(featureTypeProvider).toggle(DrawerSelection.pharmacy);
        setState(() {
          _drawerSelection = DrawerSelection.pharmacy;
          featureType = type;
        });
        loadPharmacy(true, serviceId: id);
        break;
    }
  }

  Future<void> bookmarkContext(
      List<double> coordinates, String amenityType, FeatureType type) async {
    switch (type) {
      case FeatureType.HEALTH_SERVICES:
        context.read(featureTypeProvider).toggle(DrawerSelection.health);
        _drawerSelection = DrawerSelection.health;
        featureType = type;
        if (gFeatures == null) {
          gFeatures = await featureBloc.fetchHealthData();
        }
        var markerClusterA = FeatureHelper.listMarker(gFeatures);
        markercluster.clear();
        multiCoordinates.clear();
        resetBound(markerClusterA);
        markercluster = List.from(markerClusterA);
        multiCoordinates =
            List.from(gFeatures.boundary.features.first.geometry.coordinates);
        break;
      case FeatureType.PHARMACY:
        context.read(featureTypeProvider).toggle(DrawerSelection.pharmacy);
        _drawerSelection = DrawerSelection.pharmacy;
        featureType = type;
        if (pFeature == null) {
          pFeature = await featureBloc.fetchPharmacyData();
        }
        var markerClusterB = FeatureHelper.listMarker(pFeature);
        markercluster.clear();
        multiCoordinates.clear();
        resetBound(markerClusterB);
        markercluster = List.from(markerClusterB);
        multiCoordinates =
            List.from(pFeature.boundary.features.first.geometry.coordinates);
        break;
    }
    pastMarker = null;
    displayBookmark(
        bookmarkItem.infoDetail.coordinates, bookmarkItem.titleDetail.subTitle);
  }

  void buildBottomSheet(BuildContext context, Marker marker) {
    TitleDetail titleDetail;
    InfoDetail infoDetail;
    dynamic poisFeature;
    List<FeaturePair> list = [];

    if (!fromSearch) {
      switch (featureType) {
        case FeatureType.HEALTH_SERVICES:
          poisFeature = FeatureHelper.getPois(marker, gFeatures);
          infoDetail = getHealthInfo(poisFeature);
          break;
        case FeatureType.PHARMACY:
          poisFeature = FeatureHelper.getPois(marker, pFeature);
          infoDetail = getPharmacyInfo(poisFeature);
          break;
      }
    } else {
      poisFeature = searchResponse.geometries;
      infoDetail = getSearchInfo();
      fromSearch = false;
    }
    poisFeature.properties.tags.toJson().forEach((key, value) {
      if (value != null) {
        list.add(FeaturePair(key, value));
      }
    });

    //check if name is null
    String name = poisFeature.properties.tags.name;
    String nameMn = poisFeature.properties.tags.nameMn;
    String title = name != null
        ? name
        : nameMn != null
            ? nameMn
            : "N/A";
    titleDetail = TitleDetail(
        title,
        poisFeature.properties.tags.amenity.toString().split(".").last,
        "-",
        0,
        featureType);

    //add data to provider
    context.read(detailShownFeatureProvider).toggle(
          BookmarkItem(
              titleDetail: titleDetail,
              infoDetail: infoDetail,
              serviceId: poisFeature.properties.id.toString(),
              list: list),
        );
    loadReview(poisFeature.properties.id.toString());
    setState(() {
      bottomOpen = true;
    });
    displayBottomSheet(titleDetail, infoDetail, list);
  }

  void buildBottomSheetForBookmark(BuildContext context, Marker marker) {
    TitleDetail titleDetail = bookmarkItem.titleDetail;
    InfoDetail infoDetail = bookmarkItem.infoDetail;
    List<FeaturePair> list = bookmarkItem.list;

    //add data to provider
    context.read(detailShownFeatureProvider).toggle(
          BookmarkItem(
              titleDetail: titleDetail,
              infoDetail: infoDetail,
              serviceId: bookmarkItem.serviceId,
              list: list),
        );

    loadReview(bookmarkItem.serviceId);
    setState(() {
      bottomOpen = true;
    });
    displayBottomSheet(titleDetail, infoDetail, list);
  }

  InfoDetail getHealthInfo(health.Feature feature) {
    var coordinate = feature.geometry.coordinates;
    List<String> phones = [];
    feature.properties.tags.toJson().forEach((key, value) {
      if (key.contains("phone") && value != null) {
        print(value);
        phones.add(value);
      }
    });
    String name = feature.properties.tags.name;
    String nameMn = feature.properties.tags.nameMn;
    String title = name != null
        ? name
        : nameMn != null
            ? nameMn
            : "N/A";
    return (InfoDetail(phones, coordinate, feature.properties.id.toString(),
        featureType.toString(), title, feature.id));
  }

  InfoDetail getPharmacyInfo(health.Feature feature) {
    var coordinate = feature.geometry.coordinates;
    List<String> phones = [];
    feature.properties.tags.toJson().forEach((key, value) {
      if (key.contains("phone") && value != null) {
        phones.add(value);
      }
    });
    String name = feature.properties.tags.name;
    String nameMn = feature.properties.tags.nameMn;
    String title = name != null
        ? name
        : nameMn != null
            ? nameMn
            : "N/A";
    return (InfoDetail(phones, coordinate, feature.properties.id.toString(),
        featureType.toString(), title, feature.id));
  }

  InfoDetail getSearchInfo() {
    var coordinate = searchResponse.geometries.geometry.coordinates;
    List<String> phones = [];
    searchResponse.geometries.properties.tags.toJson().forEach((key, value) {
      print("keys: $value");
      if (key.contains("phone") && value != null) {
        phones.add(value);
      }
    });
    String name = searchResponse.geometries.properties.tags.name;
    String nameMn = searchResponse.geometries.properties.tags.nameMn;
    String title = name != null
        ? name
        : nameMn != null
            ? nameMn
            : "N/A";
    return (InfoDetail(
        phones,
        coordinate,
        searchResponse.geometries.properties.id,
        featureType.toString(),
        title,
        "${searchResponse.geometries.properties.type}/${searchResponse.geometries.properties.id}"));
  }

  onLocationChange(LatLng position) {
    myPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    // You can use the userLocationOptions object to change the properties
    // of UserLocationOptions in runtime
    //Get the current location of marker
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: markers,
        updateMapLocationOnPositionChange: false,
        showMoveToCurrentLocationFloatingActionButton: true,
        zoomToCurrentLocationOnLoad: false,
        fabBottom: 50,
        verbose: false,
        onLocationUpdate: onLocationChange,
        locationUpdateIntervalMs: 20000,
        onTapFAB: () async {
          if (myPosition == null) {
            showToast(
                "Unable to locate.\nPlease check location permission in setting.");
          }
        });
    return Consumer(builder: (context, watch, child) {
      var provider = watch(filterResponseProvider);
      var searchSelectedItemProvider = watch(selectedSearchFeatureProvider);
      var selectedBookmarkItemProvider = watch(selectedBookmarkFeatureProvider);
      if (searchSelectedItemProvider.value != null) {
        fromSearch = true;
        searchResponse = searchSelectedItemProvider.value;
        displaySearch(searchSelectedItemProvider);
        context.read(selectedSearchFeatureProvider).remove();
      }
      if (selectedBookmarkItemProvider.value != null) {
        bookmarkItem = selectedBookmarkItemProvider.value;
        if (bookmarkItem.titleDetail.featureType != featureType) {
          bookmarkContext(
              bookmarkItem.infoDetail.coordinates,
              bookmarkItem.titleDetail.subTitle,
              bookmarkItem.titleDetail.featureType);
        } else {
          displayBookmark(bookmarkItem.infoDetail.coordinates,
              bookmarkItem.titleDetail.subTitle);
        }
        selectedBookmarkItemProvider.remove();
      }
      if (provider.response != null) {
        if (provider.response.geometries != null) {
          var markerClusterB;
          multiCoordinates.clear();
          pastMarker = null;
          markercluster.clear();
          List<LatLng> pointList = [];
          if (provider.response is FeatureResponse) {
            markerClusterB =
                FeatureHelper.listFilteredMarker(provider.response);
            multiCoordinates
                .add(provider.response.boundary.geometry.coordinates);
            List<List<List<double>>> coord =
                provider.response.boundary.geometry.coordinates;
            for (List<double> dob in coord.first) {
              pointList.add(LatLng(dob[1], dob[0]));
            }
          } else {
            markerClusterB = FeatureHelper.listMarker(provider.response);
            health.FeatureResponseHealth responseHealth = provider.response;
            multiCoordinates =
                responseHealth.boundary.features.first.geometry.coordinates;
            for (Marker filterMark in markerClusterB) {
              pointList.add(filterMark.point);
            }
          }

          markercluster = List.from(markerClusterB);

          latLngBounds = LatLngBounds.fromPoints(pointList);
          FitBoundsOptions boundsOptions =
              FitBoundsOptions(padding: EdgeInsets.all(100.0));
          if (latLngBounds.isValid)
            this.mapController.fitBounds(latLngBounds, options: boundsOptions);
        } else {
          multiCoordinates =
              gFeatures.boundary.features.first.geometry.coordinates;
          markercluster = [];
        }
        context.read(filterResponseProvider).remove();
      } else {}
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_outlined),
              tooltip: 'Search here',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchData()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list_sharp),
              tooltip: 'Filter here',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DynamicFilterPage()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text('$user'),
                accountName: Text('$userId'),
              ),
              ListTile(
                selected: _drawerSelection == DrawerSelection.health,
                leading: Icon(Icons.local_hospital_outlined),
                title: Text('Health Services'),
                onTap: () {
                  if (featureType != FeatureType.HEALTH_SERVICES) {
                    pastMarker = null;
                  }
                  context
                      .read(featureTypeProvider)
                      .toggle(DrawerSelection.health);
                  onItemSelected(FeatureType.HEALTH_SERVICES);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: _drawerSelection == DrawerSelection.pharmacy,
                leading: Icon(Icons.local_pharmacy_outlined),
                title: Text('Pharmacy'),
                onTap: () {
                  if (featureType != FeatureType.PHARMACY) {
                    pastMarker = null;
                  }
                  context
                      .read(featureTypeProvider)
                      .toggle(DrawerSelection.pharmacy);
                  Navigator.pop(context);
                  onItemSelected(FeatureType.PHARMACY);
                },
              ),
              Divider(),
              ListTile(
                selected: _drawerSelection == DrawerSelection.bookmark,
                leading: Icon(Icons.bookmark_border),
                title: Text('Bookmarks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarksPage()),
                  );
                },
              ),
              ListTile(
                selected: _drawerSelection == DrawerSelection.language,
                leading: Icon(Icons.language),
                title: Text('Language Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageSettingsPage()),
                  );
                },
              ),
              ListTile(
                selected: _drawerSelection == DrawerSelection.about,
                leading: Icon(Icons.list),
                title: Text('Resources'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResourcesPage()),
                  );
                },
              ),
              ListTile(
                selected: _drawerSelection == DrawerSelection.about,
                leading: Icon(Icons.info_outline),
                title: Text('About Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            child: FlutterMap(
              options: new MapOptions(
                // center: new LatLng(47.912415, 106.871712),
                bounds: latLngBounds,
                boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
                // zoom: 13.0,
                plugins: [
                  // ADD THIS
                  UserLocationPlugin(),
                  MarkerClusterPlugin(),
                ],
                onTap: (_) => _popupController
                    .hidePopup(), // Hide popup when the map is tapped.
              ),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                if ((multiCoordinates != null && multiCoordinates.length > 0))
                  PolygonLayerOptions(
                      polygonCulling: false, polygons: multiPolygon()),
                new MarkerLayerOptions(markers: markers),
                userLocationOptions,
                MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  disableClusteringAtZoom: 16,
                  size: Size(40, 40),
                  anchor: AnchorPos.align(AnchorAlign.center),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markercluster,
                  polygonOptions: PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3),
                  onMarkerTap: _onMarkerTap,
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      heroTag: markers.first.point.hashCode,
                      onPressed: null,
                    );
                  },
                ),
              ],
              mapController: mapController,
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Container(
            height: 40.0,
            width: 40.0,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent[200],
              child: Icon(
                Icons.zoom_out_map_outlined,
              ),
              onPressed: () {
                FitBoundsOptions boundsOptions =
                    FitBoundsOptions(padding: EdgeInsets.all(100.0));
                if (latLngBounds.isValid)
                  this
                      .mapController
                      .fitBounds(latLngBounds, options: boundsOptions);
                // Add your onPressed code here!
              },
            ),
          ),
        ),
      );
    });
  }

  List<Polygon> multiPolygon() {
    List<Polygon> polygons = [];
    multiCoordinates.forEach((element) {
      polygons.add(Polygon(
        borderColor: Colors.blueAccent,
        color: Colors.black12,
        borderStrokeWidth: 3,
        isDotted: true,
        points: FeatureHelper.parseIntoLatlngPoints(element),
      ));
    });
    return polygons;
  }

  onItemSelected(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.HEALTH_SERVICES:
        setState(() {
          _drawerSelection = DrawerSelection.health;
        });
        loadHealth(false);
        break;
      case FeatureType.PHARMACY:
        setState(() {
          _drawerSelection = DrawerSelection.pharmacy;
        });
        loadPharmacy(false);
        break;
    }
  }

  displaySearch(SelectedFeatureNotifier searchResponse) async {
    Marker searchMarker = FeatureHelper.searchMarker(searchResponse.value);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.mapController.move(searchMarker.point, 17);
      _onMarkerTap(searchMarker);
    });
  }

  displayBookmark(List<double> coordinates, String amenityType) async {
    Marker searchMarker =
        FeatureHelper.searchMarkerByCoordinates(coordinates, amenityType);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.mapController.move(searchMarker.point, 17);
      _onMarkerTap(searchMarker);
    });
  }

  resetBound(List<Marker> markerCluster) {
    List<LatLng> pointList = [];
    for (Marker filterMark in markerCluster) {
      pointList.add(filterMark.point);
    }
    latLngBounds = LatLngBounds.fromPoints(pointList);
    FitBoundsOptions boundsOptions =
        FitBoundsOptions(padding: EdgeInsets.all(100.0));
    if (latLngBounds.isValid)
      this.mapController.fitBounds(latLngBounds, options: boundsOptions);
  }

  Future loadPharmacy(bool fromIntent, {String serviceId}) async {
    if (pFeature == null) {
      pFeature = await featureBloc.fetchPharmacyData();
    }
    var markerClusterB = FeatureHelper.listMarker(pFeature);
    markercluster.clear();
    multiCoordinates.clear();
    resetBound(markerClusterB);
    setState(() {
      markercluster = List.from(markerClusterB);
      featureType = FeatureType.PHARMACY;
      multiCoordinates =
          List.from(pFeature.boundary.features.first.geometry.coordinates);
    });

    if (fromIntent) {
      if (bottomOpen) Navigator.pop(context);
      var value = pFeature.geometries.features.firstWhere(
          (element) => element.properties.id.toString() == serviceId);
      Marker marker = returnMarker(value);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await this.mapController.move(marker.point, 17);
      });
      setState(() {
        pastMarker = null;
      });
      _onMarkerTap(marker);
    }
  }

  Future loadHealth(bool fromIntent, {String serviceId}) async {
    // var features;
    if (gFeatures == null) {
      gFeatures = await featureBloc.fetchHealthData();
    }
    var markerclusterA = FeatureHelper.listMarker(gFeatures);
    markercluster.clear();
    multiCoordinates.clear();
    resetBound(markerclusterA);
    setState(() {
      this.featureType = FeatureType.HEALTH_SERVICES;
      markercluster = List.from(markerclusterA);
      multiCoordinates =
          List.from(gFeatures.boundary.features.first.geometry.coordinates);
    });

    if (fromIntent) {
      if (bottomOpen) Navigator.pop(context);
      var value = gFeatures.geometries.features.firstWhere(
          (element) => element.properties.id.toString() == serviceId);
      Marker marker = returnMarker(value);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await this.mapController.move(marker.point, 17);
      });
      setState(() {
        pastMarker = null;
      });
      _onMarkerTap(marker);
    }
  }

  Marker returnMarker(final value) {
    return new Marker(
      width: 30.0,
      height: 30.0,
      point:
          LatLng(value.geometry.coordinates[1], value.geometry.coordinates[0]),
      builder: (_) =>
          Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
      anchorPos: AnchorPos.align(AnchorAlign.top),
    );
  }

  loadReview(String serviceId) async {
    var reviews = context.read(reviewProvider);
    await reviews.getReview(serviceId);
  }

  _onMarkerTap(Marker marker) {
    final feature = featureType == FeatureType.PHARMACY ? pFeature : gFeatures;
    final type = FeatureHelper.getPois(marker, feature).properties.tags.amenity;
    if (pastMarker == null) {
      pastMarker = marker;
    } else if (marker.point != pastMarker.point) {
      Marker mMarker = markercluster
              .where((element) => element.point == pastMarker.point)
              .isNotEmpty
          ? markercluster
              .where((element) => element.point == pastMarker.point)
              .first
          : null;

      final pastType =
          FeatureHelper.getPois(pastMarker, feature).properties.tags.amenity;
      Marker changeMarker = new Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(pastMarker.point.latitude, pastMarker.point.longitude),
        builder: (_) =>
            // Icon(Icons.add_location_rounded, size: 30.0, color: Colors.red),
            Image.asset(FeatureHelper.getIconAsset(pastType)),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      );

      if (mMarker != null) {
        markercluster.remove(mMarker);
        markercluster.add(changeMarker);
      }
      pastMarker = marker;
    }
    Marker marker1 = new Marker(
      width: 30.0,
      height: 30.0,
      point: LatLng(marker.point.latitude, marker.point.longitude),
      builder: (_) => Image.asset(FeatureHelper.getIconAssetBlue(type)),
      anchorPos: AnchorPos.align(AnchorAlign.top),
    );
    markercluster.remove(marker);
    markercluster.add(marker1);

    Marker temp = markercluster
                .where((element) => element.point == marker.point)
                .length >
            1
        ? markercluster.where((element) => element.point == marker.point).first
        : null;
    markercluster.remove(temp);
    if (bookmarkItem != null) {
      buildBottomSheetForBookmark(context, marker);
    } else
      buildBottomSheet(context, marker);
    setState(() {
      markercluster = List.from(markercluster);
    });
    // }
  }

  void showToast(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG // also possible "TOP" and "CENTER"
        );
  }

  void displayBottomSheet(
      TitleDetail titleDetail, InfoDetail infoDetail, List<FeaturePair> list) {
    showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            ),
            builder: (ctx) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DetailTop(titleDetail, infoDetail, list, true, fromEdit,
                        myPosition,
                        isLoggedIn: (userLog == "Logout") ? true : false),
                    DetailCenter(infoDetail, myPosition),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                          height: 1.0,
                          indent: 12.0,
                          endIndent: 12.0,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return ListTile(
                            title: Text(
                              '${item.key}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey.shade600),
                            ),
                            subtitle: Text(
                              '${item.value}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                    LoadMoreButton(
                        titleDetail, infoDetail, list, fromEdit, myPosition,
                        isLoggedIn: (userLog == "Logout") ? true : false),
                  ],
                ),
              );
            },
            isScrollControlled: true)
        .whenComplete(() => setState(() {
              bottomOpen = false;
              bookmarkItem = null;
            }));
  }
}
