import 'dart:async';

import 'package:c2m2_mongolia/mapfeature/FeatureHelper.dart';
import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/DetailCenter.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/DetailTop.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/EditButton.dart';
import 'package:c2m2_mongolia/mapfeature/osm_oauth2.dart';
import 'package:c2m2_mongolia/models/feature_review.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final TitleDetail titleDetail;
  final InfoDetail infoDetail;
  final List<FeaturePair> list;
  final LatLng myPosition;
  double offset;
  bool isLoggedIn;
  Function(OSMUser) fromEdit;

  DetailPage(this.titleDetail, this.infoDetail, this.list, this.fromEdit,
      this.myPosition,
      {this.offset, this.isLoggedIn});

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  bool isLoading = false;
  String queryText = "";
  final queryHolder = TextEditingController();
  int _rating = 2;
  List<Result> reviews = [];
  bool isScrollable = false;
  ScrollController controller = new ScrollController();
  GlobalKey globalKey = new GlobalKey();

  clearTextInput() {
    queryHolder.clear();
    queryText = "";
  }

  AppBar appBar = AppBar(
    title: Text("Detail"),
    elevation: 0.0,
  );

  _afterLayout() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final RenderBox box = globalKey.currentContext.findRenderObject();
      var position = box.localToGlobal(Offset(
          0,
          -(8 +
              widget.offset +
              appBar.preferredSize.height +
              MediaQuery.of(context).padding.top)));
      controller.animateTo(position.dy,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var provider = watch(reviewProvider);
      if (provider.response != null) {
        reviews.clear();
        reviews.addAll(provider.response.result);
      }

      if (watch(reviewScrollNotifier).value == true) {
        //find scroll index
        isScrollable = true;
        _afterLayout();
        // Timer(Duration(seconds: 1), ()=> _afterLayout());
        context.read(reviewScrollNotifier).toggle(false);
      }
      return Scaffold(
          appBar: appBar,
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(bottom: 10),
            color: AppColors.background,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DetailTop(widget.titleDetail, widget.infoDetail, widget.list,
                    false, widget.fromEdit, widget.myPosition),
                Expanded(
                  child: CustomScrollView(
                    controller: controller,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          child: Text(
                            "Features",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          margin: EdgeInsets.only(
                              left: 12, top: 12, right: 0, bottom: 12),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                            List<Widget>.generate(widget.list.length, (int i) {
                          final item = widget.list[i];
                          return itemHolder(item);
                        })),
                      ),
                      SliverToBoxAdapter(
                          child: Container(
                        child: EditButton(widget.titleDetail, widget.infoDetail,
                            widget.list, widget.fromEdit, widget.myPosition,
                            isLoggedIn: widget.isLoggedIn),
                      )),
                      SliverToBoxAdapter(
                        child: Divider(
                          key: globalKey,
                          color: Colors.black45,
                        ),
                      ),
                      if (reviews.length > 0)
                        SliverToBoxAdapter(
                          child: Container(
                            child: Text(
                              "Reviews",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            margin: EdgeInsets.only(
                                left: 16, top: 12, right: 0, bottom: 12),
                          ),
                        ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                            List<Widget>.generate(reviews.length, (int i) {
                          final item = reviews[reviews.length - 1 - i];
                          return feedbackHolder(item);
                        })),
                      ),
                    ],
                  ),
                ),
                DetailCenter(widget.infoDetail, widget.myPosition),
              ],
            ),
          ));
    });
  }

  Widget itemHolder(FeaturePair featurePair) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      padding: EdgeInsets.all(12.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            featurePair.key,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 5.0),
          Linkify(
            onOpen: _onOpen,
            text: featurePair.value,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget feedbackHolder(Result review) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.brown.shade500,
            child: Text(review.osmUsername.split('')[0].toUpperCase()),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    review.osmUsername,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FeatureHelper.buildRatingStar(review.rating * 1.0),
                      review.createdAt != null
                          ? Text(
                              formatter.format(review.createdAt),
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0),
                            )
                          : null,
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  if (review.comments != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(review.comments,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w400)),
                    ),
                  if (review.service != null)
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Wrap(
                          children: [
                            Text("Service: ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.textSecondary)),
                            Text(review.service,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14.0, color: AppColors.accent)),
                          ],
                        )),
                  SizedBox(
                    height: 4.0,
                  ),
                  Divider(
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
