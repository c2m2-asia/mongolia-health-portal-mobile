import 'dart:collection';

import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/main.dart';
import 'package:c2m2_mongolia/mapfeature/FeatureHelper.dart';
import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/mapfeature/homescreenwidgets/DetailTop.dart';
import 'package:c2m2_mongolia/mapfeature/osm_oauth2.dart';
import 'package:c2m2_mongolia/models/feature_tags.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:xml/xml.dart';

class EditPage extends StatefulWidget {
  final TitleDetail titleDetail;
  final InfoDetail infoDetail;
  final List<FeaturePair> list;
  final LatLng myPosition;
  Function(OSMUser) fromEdit;

  EditPage(this.titleDetail, this.infoDetail, this.list, this.fromEdit,
      this.myPosition);

  @override
  _EditPage createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  List<EditTag> tags;
  var _myValues = new HashMap<String, List<String>>();

  List<Selector> tagsOnSave = [];
  OSMClient osmClient = new OSMClient();

  List<EditTag> prepareTag(OsmTags osmTags) {
    List<EditTag> tag = [];
    switch (widget.titleDetail.featureType) {
      case FeatureType.HEALTH_SERVICES:
        final allTag = osmTags.data
            .firstWhere((element) => element.value == "healthService")
            .editTags;
        allTag.forEach((element) {
          if (element.type != null) {
            tag.add(element);
          }
        });
        break;
      case FeatureType.PHARMACY:
        final allTag = osmTags.data
            .firstWhere((element) => element.value == "pharmacy")
            .editTags;
        allTag.forEach((element) {
          if (element.type != null) {
            tag.add(element);
          }
        });
        break;
    }
    return tag;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var provider = watch(tagProvider);
      if (provider.response != null) {
        tags = prepareTag(provider.response);
        widget.list.forEach((element) {
          tagsOnSave.add(new Selector(
              label: element.key, osmValue: element.value.toString()));
        });
      }
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(bottom: 10),
            color: AppColors.background,
            child: (tags != null && tags.length > 0)
                ? new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      DetailTop(
                          widget.titleDetail,
                          widget.infoDetail,
                          widget.list,
                          false,
                          widget.fromEdit,
                          widget.myPosition),
                      if (provider.isLoading) CircularProgressIndicator(),
                      if (tags != null && tags.length > 0)
                        Expanded(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Container(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 12, top: 12, right: 0, bottom: 12),
                                ),
                              ),
                              if (tags != null && tags.length > 0)
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                      List<Widget>.generate(tags.length,
                                          (int i) {
                                    final item = tags[i];
                                    return editItem(item);
                                  })),
                                ),
                              SliverToBoxAdapter(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: RaisedButton.icon(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () async {
                                          onEdit();
                                        },
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(4.0),
                                        ),
                                        label: Text("Apply Edit"),
                                        textColor: Colors.white,
                                        icon: Icon(
                                          Icons.edit_attributes_outlined,
                                          color: Colors.white,
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                    ],
                  )
                : null,
          ));
    });
  }

  void showToast(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER // also possible "TOP" and "CENTER"
        );
  }

  onEdit() async {
    showToast("Please wait! You will be notified when changes are uploaded.");
    XmlDocument xmlDocument =
        await osmClient.loadOsmFeature(widget.infoDetail.osmID);
    final type = widget.infoDetail.osmID.split("/")[0];
    final cleanedDocument = await osmClient.cleanseData(xmlDocument, type);
    String changeset = await osmClient.requestChangeset("#public-lab-mongolia");
    final changes = await osmClient.appendChanges(
        cleanedDocument, _myValues, changeset, type);
    print(changes.toXmlString(pretty: true, indent: '\t'));
    final res = await osmClient.requestEdit(changes, widget.infoDetail.osmID);
    var n = int.tryParse(res) ?? -1;
    if (n == -1) {
      showToast("Something went wrong try again later.");
    } else {
      showToast(
          "Successfully applied changes to OSM. Changes will be reflected within 24 hour.");
    }
  }

  Widget editItem(EditTag featurePair) {
    final featureValue =
        widget.list.where((element) => element.key == featurePair.osmTag);
    var value = featureValue.isNotEmpty ? featureValue.first.value : null;

    List<String> multiValue = [];
    if (featureValue != null && value != null)
      multiValue = value.toString().split(';');
    List<Selector> selectors = featurePair.selectors;
    multiValue.forEach((element) {
      if (selectors != null &&
          selectors.where((des) => des.osmValue == element).isEmpty)
        selectors.add(new Selector(label: element, osmValue: element));
    });

    bool isEditable = featurePair.isEditable == IsEditable.TRUE ? true : false;
    if (_myValues[featurePair.osmTag] == null &&
        featurePair.type == Type.MULTI_SELECT)
      _myValues[featurePair.osmTag] = multiValue;
    else if (_myValues[featurePair.osmTag] == null)
      _myValues[featurePair.osmTag] = [value];

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
            featurePair.osmTag,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          if (featurePair.type == Type.TEXT)
            editText(isEditable, featurePair.osmTag),
          if (featurePair.type == Type.SINGLE_SELECT)
            editSingle(featurePair.selectors, featurePair.osmTag),
          if (featurePair.type == Type.MULTI_SELECT)
            editMultiple(
                featurePair.selectors, featurePair.label, featurePair.osmTag),
        ],
      ),
    );
  }

  Widget editText(bool isEditable, String tag) {
    return TextFormField(
      keyboardType: FeatureHelper.getInputTextType(tag),
      textInputAction: TextInputAction.done,
      initialValue: _myValues[tag].first,
      enabled: isEditable,
      cursorColor: AppColors.primary,
      maxLines: null,
      onChanged: (text) {
        var value = text.trim().isNotEmpty ? text : null;
        setState(() {
          _myValues[tag] = [value];
        });
      },
    );
  }

  Widget editMultiple(List<Selector> selector, String title, String tag) {
    final database = selector.map((e) => e.toJson()).toList();
    database.forEach((element) {
      if (Translations.of(context).currentLanguage == "mn") {
        if (element.containsKey("label"))
          element.update("label", (value) => (element.values.last["mn"]));
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new MultiSelectFormField(
        autovalidate: false,
        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
        dialogShapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        initialValue: _myValues[tag],
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        dataSource: database,
        textField: 'label',
        valueField: 'osm_value',
        okButtonLabel: 'OK',
        cancelButtonLabel: 'CANCEL',
        onSaved: (value) {
          setState(() {
            _myValues[tag] = [...value];
          });
        },
      ),
    );
  }

  Widget editSingle(List<Selector> selector, String tag) {
    return DropdownButton<String>(
      isExpanded: true,
      value: _myValues[tag].first,
      icon: Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (newValue) {
        setState(() {
          _myValues[tag] = [newValue];
        });
      },
      items: <Selector>[...selector]
          .map<DropdownMenuItem<String>>((Selector value) {
        String label = value.labelLocale != null
            ? Translations.of(context).currentLanguage.toString() == "en"
                ? value.labelLocale.en
                : value.labelLocale.mn != null
                    ? value.labelLocale.mn
                    : value.label
            : value.label;
        return DropdownMenuItem<String>(
          value: value.osmValue,
          child: Text(label),
        );
      }).toList(),
    );
  }
}
