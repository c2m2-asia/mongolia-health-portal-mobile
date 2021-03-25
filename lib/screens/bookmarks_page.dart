import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/mapfeature/FeatureHelper.dart';
import 'package:c2m2_mongolia/models/bookmark_model.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).text("bookmarks_page_title")),
          elevation: 0.0,
        ),
        body: buildListView());
  }

  buildListView() {
    List _inventoryList = <BookmarkItem>[];
    return ValueListenableBuilder(
        valueListenable: Hive.box(Strings.BOOKMARKS_BOX).listenable(),
        builder: (context, box, _) {
          _inventoryList = box.values.toList();
          if (_inventoryList.isEmpty)
            return Center(
              child: Text(Translations.of(context).text("no_bookmarks_added")),
            );
          return Consumer(builder: (context, watch, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: _inventoryList.length,
                itemBuilder: (context, index) {
                  BookmarkItem item = _inventoryList[index];
                  String name = item.titleDetail.title;
                  double rating = item.titleDetail.formatedRating();
                  return GestureDetector(
                    onTap: () {
                      context
                          .read(selectedBookmarkFeatureProvider)
                          .toggle(item);
                      Navigator.pop(context);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5.0),
                                    Text(name),
                                    SizedBox(height: 4.0),
                                    FeatureHelper.buildRatingStar(rating),
                                    buildTypeChip(item.titleDetail.subTitle),
                                  ],
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.black12, // button color
                                  child: InkWell(
                                    splashColor: Colors.red,
                                    // inkwell color
                                    child: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    onTap: () {
                                      showAlertDialog(
                                          context, item.infoDetail.osmID, box);
                                    },
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  );
                },
              ),
            );
          });
        });
  }

  showAlertDialog(BuildContext context, String osmID, box) {
    // Create button
    Widget cancelButton = FlatButton(
      child: Text(Translations.of(context).text("cancel")),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text(Translations.of(context).text("ok")),
      onPressed: () {
        box.delete(osmID);
        Navigator.pop(context);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(Translations.of(context).text("alert")),
      content: Text(Translations.of(context).text("remove_bookmark_alert")),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildTypeChip(String model) {
    return ChoiceChip(
      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
      label: Text(
        model,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black12,
      elevation: 0,
      selected: true,
    );
  }
}
