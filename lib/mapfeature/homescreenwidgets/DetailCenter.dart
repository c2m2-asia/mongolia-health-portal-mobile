import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/models/bookmark_model.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:c2m2_mongolia/widgets/feature_review.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCenter extends StatefulWidget {
  final InfoDetail infoDetail;
  final LatLng myPosition;

  DetailCenter(this.infoDetail, this.myPosition);

  _DetailCenter createState() => _DetailCenter();
}

class _DetailCenter extends State<DetailCenter> {
  Box bookmarksBox;
  MapBoxNavigation _directions;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    bookmarksBox = Hive.box(Strings.BOOKMARKS_BOX);
  }

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.primaryButtons;
    bool buildCall = false;
    if (widget.infoDetail.phone != null && widget.infoDetail.phone.length > 0) {
      buildCall = true;
    }
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (buildCall)
            GestureDetector(
              onTap: () {
                String url = "tel:" + widget.infoDetail.phone.first;
                _onCall(url.replaceAll(RegExp(' '), ''));
              },
              child: _buildButtonColumn(color, Icons.call, 'CALL'),
            ),
          GestureDetector(
            onTap: () {
              if (widget.myPosition == null) {
                showToast(
                    "Unable to locate.\nPlease check location permission in setting.");
              } else {
                final latLngBounds = getBounds();
                final origin = WayPoint(
                    name: "Starting point",
                    latitude: widget.myPosition.latitude,
                    longitude: widget.myPosition.longitude);
                if (latLngBounds
                    .contains(LatLng(origin.latitude, origin.longitude))) {
                  final destination = WayPoint(
                      name: "Destination point",
                      latitude: widget.infoDetail.coordinates[1],
                      longitude: widget.infoDetail.coordinates[0]);

                  _showToast(
                      "Please wait, obtaining route", Duration(seconds: 12));
                  initializeNavigation(origin, destination);
                } else {
                  showToast("Oops! Routing is only available inside Mongolia.");
                }
              }
            },
            child: _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          ),
          GestureDetector(
            onTap: () {
              _onShare(context);
            },
            child: _buildButtonColumn(color, Icons.share, 'SHARE'),
          ),
          ValueListenableBuilder(
              valueListenable: bookmarksBox.listenable(),
              builder: (context, box, child) {
                return Consumer(builder: (context, watch, child) {
                  BookmarkItem item =
                      context.read(detailShownFeatureProvider).value;
                  String key = item.infoDetail.osmID;
                  bool isAlreadyBookmarked = bookmarksBox.containsKey(key);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      isAlreadyBookmarked
                          ? bookmarksBox.delete(key)
                          : bookmarksBox.put(key, item);
                    },
                    child: _buildButtonColumn(
                        color,
                        isAlreadyBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        isAlreadyBookmarked ? 'SAVED' : 'SAVE'),
                  );
                });
              }),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FeatureReview(
                      serviceId: widget.infoDetail.serviceId,
                    );
                  });
            },
            child: _buildButtonColumn(color, Icons.star, 'ADD REVIEW'),
          ),
        ],
      ),
    );
  }

  Future<void> _onCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("invalid");
    }
  }

  _onShare(BuildContext context) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://c2m2mongolia.page.link',
      link: Uri.parse(
          'https://c2m2mongolia.page.link/open?service_id=${widget.infoDetail.serviceId}&type=${widget.infoDetail.type}'),
      androidParameters: AndroidParameters(
        packageName: 'kll.c2m2.c2m2_mongolia',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'kll.c2m2mongolia',
        minimumVersion: '1',
        appStoreId: '1551277991',
      ),
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await DynamicLinkParameters.shortenUrl(
            link,
            DynamicLinkParametersOptions(
                shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short));
    await Share.share(
        "Here's the location of ${widget.infoDetail.name}: ${shortDynamicLink.shortUrl}");
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void showToast(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"
        );
  }

  _showToast(String title, Duration time) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(title),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: time,
    );
  }

  //Navigation
  Future<void> initializeNavigation(
      WayPoint origin, WayPoint destination) async {
    if (!mounted) return;

    _directions = MapBoxNavigation();
    var wayPoints = <WayPoint>[];
    wayPoints.add(origin);
    wayPoints.add(destination);
    _directions
        .startNavigation(
          wayPoints: wayPoints,
          options: MapBoxOptions(
              mode: MapBoxNavigationMode.drivingWithTraffic,
              simulateRoute: false,
              voiceInstructionsEnabled: true,
              bannerInstructionsEnabled: true,
              language: "mn",
              units: VoiceUnits.metric),
        )
        .timeout(Duration(seconds: 12), onTimeout: () {})
        .then(
            (value) => {
                  _showToast(
                      "Something went wrong. \n Check internet connection.",
                      Duration(seconds: 2))
                }, onError: (error) {
      _showToast("Error obtaining route.", Duration(seconds: 2));
    }).whenComplete(() {
      if (fToast != null) fToast.removeCustomToast();
    });
  }

  Future<void> _onRouteEvent(e) async {
    print(e.eventType.toString());
    switch (e.eventType) {
      case MapBoxEvent.navigation_running:
        fToast.removeCustomToast();
        break;
      case MapBoxEvent.navigation_finished:
        if (fToast != null) fToast.removeCustomToast();
        break;
      case MapBoxEvent.route_build_failed:
        // _showToast("Something went wrong. \n Check internet connection.", Duration(seconds: 2));
        break;
      default:
        break;
    }
  }

  LatLngBounds getBounds() {
    final coordinates = [
      [88.154296875, 49.5822260446217],
      [87.71484375000007, 49.167338606291075],
      [87.51708984375, 48.69096039092549],
      [90.30761718750007, 47.204642388766906],
      [90.52734375000009, 45.22848059584357],
      [93.09814453125, 44.5278427984555],
      [94.68017578125, 43.99281450048989],
      [96.3281250000001, 42.56926437219379],
      [100.28320312500006, 42.374778361114174],
      [103.97460937500007, 41.590796851056005],
      [105.07324218750001, 41.50857729743935],
      [106.39160156250007, 41.55792157780418],
      [107.2265625000001, 42.0166518355682],
      [108.63281250000006, 41.918628865183045],
      [110.34667968750009, 42.439674178149396],
      [111.44531250000007, 43.40504748787038],
      [113.24707031250007, 44.19795903948531],
      [116.58691406250004, 45.66012730272192],
      [117.94921875000006, 45.99696161820381],
      [120.05859375000006, 46.5739667965278],
      [120.41015625000007, 46.99524110694593],
      [118.47656250000007, 48.29781249243719],
      [117.46582031250006, 47.916342040161126],
      [116.49902343750006, 48.03401915864286],
      [116.19140625000006, 48.4729212724878],
      [116.98242187500006, 49.908787000867136],
      [116.49902343750006, 50.19096776558563],
      [115.75195312500006, 50.13466432216689],
      [114.34570312500009, 50.583236614805884],
      [112.76367187500007, 49.85215166776998],
      [109.95117187500007, 49.453842594330766],
      [108.45703125000007, 49.908787000867136],
      [105.73242187500006, 50.75035931136966],
      [103.18359375000006, 50.41551870402678],
      [102.56835937500007, 51.358061573190916],
      [101.38183593750007, 51.84935276370608],
      [100.06347656250009, 51.957807388715544],
      [99.00878906250009, 52.308478623663355],
      [98.12988281250009, 52.119998657638185],
      [97.47070312500006, 50.41551870402678],
      [97.20703125000007, 50.0782945473894],
      [95.62500000000007, 50.359480346298696],
      [93.95507812500009, 50.77815527465922],
      [92.28515625000007, 50.972264889367516],
      [90.17578125000009, 50.24720490139265],
      [88.154296875, 49.5822260446217]
    ];
    List<LatLng> latLngList = [];
    coordinates.forEach((element) {
      latLngList.add(new LatLng(element[1], element[0]));
    });
    return LatLngBounds.fromPoints(latLngList);
  }
}
