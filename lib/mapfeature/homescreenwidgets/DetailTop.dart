import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/mapfeature/osm_oauth2.dart';
import 'package:c2m2_mongolia/screens/detail_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:latlong/latlong.dart';

class DetailTop extends StatefulWidget {
  final TitleDetail titleDetail;
  final InfoDetail infoDetail;
  final List<FeaturePair> list;
  final bool onTapEnabled;
  final LatLng myPosition;
  bool isLoggedIn;
  Function(OSMUser) fromEdit;

  DetailTop(this.titleDetail, this.infoDetail, this.list, this.onTapEnabled,
      this.fromEdit, this.myPosition,
      {this.isLoggedIn});

  _DetailTop createState() => _DetailTop();
}

class _DetailTop extends State<DetailTop> {
  GlobalKey globalOffset = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var provider = watch(reviewProvider);
      if (provider.response != null) {
        widget.titleDetail.rating = provider.response.averageRating;
        widget.titleDetail.raters = provider.response.result.length;
      }

      return Align(
        alignment: AlignmentDirectional.topCenter,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          color: Colors.grey.shade50,
          child: Row(
            key: globalOffset,
            children: [
              Expanded(
                /*1*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${widget.titleDetail.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.titleDetail.formatedSub()}',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              /*3*/
              GestureDetector(
                onTap: () async {
                  if (widget.onTapEnabled) {
                    context.read(reviewScrollNotifier).toggle(true);
                    final RenderBox box =
                        globalOffset.currentContext.findRenderObject();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                widget.titleDetail,
                                widget.infoDetail,
                                widget.list,
                                widget.fromEdit,
                                widget.myPosition,
                                offset: box.size.height,
                                isLoggedIn: widget.isLoggedIn)));
                  }
                },
                child: Container(
                  child: Column(
                    children: [
                      _buildRatingStar(widget.titleDetail.formatedRating()),
                      Text('${widget.titleDetail.raters}' + " "+Translations.of(context).text("reviews")),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRatingStar(double rates) {
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
