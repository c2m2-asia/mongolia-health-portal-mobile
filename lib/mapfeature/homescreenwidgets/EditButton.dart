import 'dart:io';

import 'package:c2m2_mongolia/mapfeature/osm_oauth2.dart';
import 'package:c2m2_mongolia/screens/edit_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import '../detail_feature.dart';
import 'package:latlong/latlong.dart';


class EditButton extends StatefulWidget {
  final TitleDetail titleDetail;
  final InfoDetail infoDetail;
  final List<FeaturePair> list;
  bool isLoggedIn;
  final LatLng myPosition;
  Function(OSMUser) fromEdit;
  EditButton(this.titleDetail, this.infoDetail, this.list,this.fromEdit,this.myPosition, {this.isLoggedIn});
  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<EditButton> with WidgetsBindingObserver{
  bool isLoggedIn;
  // AppLifecycleState _notification;
  FlutterWebviewPlugin _flutterWebviewPlugin;
  oauth1.AuthorizationResponse _authorizationResponse;
  OSMClient osmClient = new OSMClient();


  @override
  initState() {
    super.initState();
    if(widget.isLoggedIn != null) {
      isLoggedIn = widget.isLoggedIn;
    }
    _flutterWebviewPlugin = FlutterWebviewPlugin()..onUrlChanged.listen((url) {
      final uri = Uri.parse(url);
      print(uri.host);
      if (uri.host == "login-callback") {
        final verifier = uri.queryParameters["oauth_verifier"];

        _flutterWebviewPlugin.close();
        var auth = new oauth1.Authorization(clientCredentials, platform);
        auth.requestTokenCredentials(_authorizationResponse.credentials, verifier).then((res) async {
          final userDetail = await osmClient.saveCred(res, clientCredentials);
          if (userDetail != null) {
            setState(() {
              isLoggedIn = true;
              widget.fromEdit(userDetail);
            });
          }
        });
      }

    });
    WidgetsBinding.instance.addObserver(this);
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  loadTags() async {
    var tags = context.read(tagProvider);
    await tags.getEditTags();
    if (tags.error != null) {
      // show error
      print(tags.error);
    } else {
      print(tags.response.message);
    }
  }
  @override
  Widget build(BuildContext context) {
      return Container(
        // width: 250,
          height: 56,
          alignment: Alignment.center,
          // margin: EdgeInsets.only(left:12.0,right: 12.0,bottom: 12.0,top: 8.0),
          child: RaisedButton.icon(
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () async {
              // String value = await secureStorage.read(key: "token");
              //
              // if (value == null) {
               if(!isLoggedIn) {_authorizationResponse =
                await osmClient.loginAction(_flutterWebviewPlugin);
              } else {
                 loadTags();
                 Navigator.push(context, MaterialPageRoute(builder: (context) =>
                EditPage(widget.titleDetail, widget.infoDetail, widget.list, widget.fromEdit, widget.myPosition)));
                // osmClient.loadOsmFeature(widget.infoDetail.osmID);
              }
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(widget.titleDetail, widget.infoDetail, widget.list)));
            },
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4.0),
            ),
            label: isLoggedIn ? Text("Suggest An Edit") : Text("Login To Edit"),
            textColor: Colors.white,
            icon: isLoggedIn ? Icon(
              Icons.edit,
              color: Colors.white,
            ) : Icon(
              Icons.login,
              color: Colors.white,
            ),
          ));
  }
//   Future<void> loginAction() async {
//     // request temporary credentials (request tokens)
//     // https://www.openstreetmap.org/api/0.6/user/details
//     var clientCredentials = new oauth1.ClientCredentials(OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET);
// // create Authorization object with client credentials and platform definition
//     var auth = new oauth1.Authorization(clientCredentials, platform);
//     auth.requestTemporaryCredentials('oob').then((res) {
//       // redirect to authorization page
//       final url = auth.getResourceOwnerAuthorizationURI(res.credentials.token);
//       _authorizationResponse = res;
//       _flutterWebviewPlugin.launch(url);
//     });
//   }

}