import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/mapfeature/osm_oauth2.dart';
import 'package:c2m2_mongolia/screens/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../detail_feature.dart';
import 'package:latlong/latlong.dart';

class LoadMoreButton extends StatefulWidget {
  final TitleDetail titleDetail;
  final InfoDetail infoDetail;
  final List<FeaturePair> list;
  final LatLng myPosition;
  bool isLoggedIn;
  Function(OSMUser) fromEdit;
  LoadMoreButton(this.titleDetail, this.infoDetail, this.list, this.fromEdit,this.myPosition, {this.isLoggedIn});
  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<LoadMoreButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 56,
        margin: EdgeInsets.only(
            left: 12.0, right: 12.0, bottom: 12.0, top: 8.0),
        child: RaisedButton.icon(
          color: Theme
              .of(context)
              .primaryColor,
          onPressed: () async {
            // loginAction();
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DetailPage(
                    widget.titleDetail, widget.infoDetail, widget.list, widget.fromEdit, widget.myPosition, isLoggedIn: widget.isLoggedIn)));
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(4.0),
          ),
          label: Text(Translations.of(context).text("load_more")),
          textColor: Colors.white,
          icon: Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
        ));
  }
}