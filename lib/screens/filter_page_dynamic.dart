import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/models/admin_boundary.dart';
import 'package:c2m2_mongolia/models/feature_filter_tags.dart' as filter_tags;
import 'package:c2m2_mongolia/models/feature_tags.dart' as feature_tags;
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:c2m2_mongolia/widgets/filter_by_admin_boundary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicFilterPage extends StatefulWidget {
  @override
  _DynamicFilterPageState createState() => _DynamicFilterPageState();
}

class _DynamicFilterPageState extends State<DynamicFilterPage> {
  String _featureTypeValue;
  Division selectedDistrict;
  var filterProvider, selectedFilterProvider, adminBoundaryProvider;
  filter_tags.FilterTags filterTags;
  AdminBoundaryResponse boundaryResponse;

  @override
  void initState() {
    loadAdminBoundaries();
    loadTags();
  }

  loadTags() async {
    filterProvider = context.read(filterTagsProvider);
    if (filterProvider.response == null) {
      await filterProvider.getFilterTags();
      if (filterProvider.error != null) {
      } else {
        filterTags = filterProvider.response;
      }
    }
  }

  loadAdminBoundaries() async {
    adminBoundaryProvider = context.read(filterAdminBoundaryProvider);
    if (adminBoundaryProvider.response == null) {
      await adminBoundaryProvider.fetchAdminBoundary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final filterTagsValue = watch(filterTagsProvider);
      selectedFilterProvider = watch(filterRequestProvider);
      boundaryResponse = watch(filterAdminBoundaryProvider).response;
      selectedDistrict = watch(filterAdminBoundaryProvider).selectedDistrict;
      _featureTypeValue = watch(featureTypeProvider).value;
      return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).text(Strings.FILTER_PAGE_TITLE)),
          actions: <Widget>[
            if (!validateFilters())
              FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    resetFilters();
                  },
                  child: Text("RESET",
                      style: TextStyle(
                        fontSize: 18.0,
                      ))),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: addDescription(
                      _featureTypeValue == Strings.featureHealthServices
                          ? Strings.filterHealthServicesDescription
                          : Strings.filterPharmacyDescription)),
              if (boundaryResponse != null)
                SliverToBoxAdapter(
                  child: FilterByAdminBoundary(),
                ),
              SliverToBoxAdapter(child: addVerticalSpace(10.0)),
              if (filterTagsValue.isLoading)
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: LinearProgressIndicator(),
                  ),
                )
              else if (filterTagsValue.error == null)
                buildWidgetByType(filterTagsValue.response)
              else
                SliverToBoxAdapter(
                  child: Text(filterTagsValue.error),
                )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () async {
                var filterProvider = context.read(filterResponseProvider);
                await filterProvider.addFilter();
                if (filterProvider.error != null) {
                  // show error
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(filterProvider.error)));
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(primary: AppColors.primary),
              child: Text('APPLY FILTERS'),
            ),
          ),
        ),
      );
    });
  }

  buildMultiSelectWidget(feature_tags.EditTag editTag) {
    return Consumer(builder: (context, watch, child) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: <Widget>[
              for (feature_tags.Selector model in editTag.selectors)
                buildTypeChip(editTag.osmTag, model)
            ],
          ));
    });
  }

  Widget buildTypeChip(String osmTag, feature_tags.Selector model) {
    return ChoiceChip(
      labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
      label: Text(
        model.label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black12,
      elevation: 1.0,
      selected: model.isChecked,
      onSelected: (selected) {
        setState(() {
          model.isChecked = selected;
        });
        context
            .read(filterRequestProvider)
            .addMultiSelectableFilter(osmTag, model);
      },
    );
  }

  addDescription(String desc) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          desc,
          style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.normal,
              height: 1.5),
        ));
  }

  addHeader(String header) {
    return SizedBox(
      height: 20.0,
      child: Container(
          child: Text(
        header,
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }

  addVerticalSpace(double d) {
    return SizedBox(
      height: d,
    );
  }

  bool validateFilters() {
    String selectedDistrictLabel = "";
    if (selectedDistrict != null)
      selectedDistrictLabel = selectedDistrict.label.en;

    return (selectedDistrictLabel == "All" || selectedDistrictLabel.isEmpty) &&
        context
            .read(filterRequestProvider)
            .checkIfTheMultiSelectableFiltersAreEmpty() &&
        context
            .read(filterRequestProvider)
            .checkIfTheSingleSelectableFiltersAreEmpty();
  }

  void resetFilters() {
    context.read(filterAdminBoundaryProvider).removeAll();
    context.read(filterRequestProvider).resetFilters();
  }

  buildWidgetByType(filter_tags.FilterTags filterTags) {
    print("buildWidget");
    List<Widget> widgets = <Widget>[];
    if (filterTags != null)
      for (filter_tags.Datum datum in filterTags.data) {
        String value = Strings.filterFeatures[_featureTypeValue];
        if (value == datum.value) {
          widgets = buildFilterWidgets(datum.filterTags);
          return SliverList(
            delegate: SliverChildListDelegate(
                List<Widget>.generate(widgets.length, (int i) {
              final item = widgets[i];
              return item;
            })),
          );
        }
      }
  }

  List<Widget> buildFilterWidgets(List<feature_tags.EditTag> filterTags) {
    List<Widget> widgets = <Widget>[];
    for (feature_tags.EditTag editTag in filterTags)
      switch (editTag.type) {
        case feature_tags.Type.SINGLE_SELECT:
          if (editTag.selectors.isNotEmpty &&
              editTag.selectors.first.label != "Any")
            editTag.selectors
                .insert(0, new feature_tags.Selector(label: "Any"));
          widgets.add(buildSingleSelectWidget(editTag));
          break;
        case feature_tags.Type.MULTI_SELECT:
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: addHeader(editTag.label),
          ));
          widgets.add(buildMultiSelectWidget(editTag));
          break;
      }
    return widgets;
  }

  Widget buildSingleSelectWidget(feature_tags.EditTag editTag) {
    if (editTag.selectors.isNotEmpty) {
      var _selectedItem = editTag.selectors.first;
      Map<String, feature_tags.Selector> selectedFilter;
      context
          .read(filterRequestProvider)
          .setInitialValue(editTag.osmTag, _selectedItem);
      return Consumer(
        builder: (context, watch, child) {
          selectedFilter =
              watch(filterRequestProvider).singleTypeSelectedFilters;
          feature_tags.Selector selector = selectedFilter[editTag.osmTag];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addHeader(
                  editTag.label,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: 45.0,
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      // color: Colors.cyan,
                      border: Border.all(
                        color: AppColors.primary,
                      )),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: selectedFilter[editTag.osmTag],
                          items: editTag.selectors.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            );
                          }).toList(),
                          onChanged: (selectedItem) => {
                                context
                                    .read(filterRequestProvider)
                                    .addSingleSelectableFilter(
                                        editTag.osmTag, selectedItem)
                              })),
                ),
              ],
            ),
          );
        },
      );
    } else
      return Container();
  }
}
