import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/models/admin_boundary.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:c2m2_mongolia/widgets/filter_by_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<FilterType> typeList, categoryList;
  String _featureTypeValue;
  FilterType _featureCategoryValue;
  Division selectedDistrict;
  int _wheelchairValue;
  bool _wheelchairVisibilityValue,
      _opening24HoursVisibilityValue,
      _operatorStatusVisibilityValue;
  int _opening24HoursValue;
  int _operatorStatusValue;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      _featureTypeValue = watch(featureTypeProvider).value;
      _featureCategoryValue =
          watch(filterByCategoryProvider).selectedCategoryValue;
      typeList = watch(filterTypesProvider).value;
      _wheelchairVisibilityValue = watch(wheelchairVisibilityProvider).value;
      selectedDistrict = watch(filterAdminBoundaryProvider).selectedDistrict;
      _opening24HoursVisibilityValue =
          watch(openingHoursVisibilityProvider).value;
      _operatorStatusVisibilityValue =
          watch(operatorStatusVisibilityProvider).value;
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: addDescription(
                      _featureTypeValue == Strings.featureHealthServices
                          ? Strings.filterHealthServicesDescription
                          : Strings.filterPharmacyDescription)),
              SliverToBoxAdapter(child: addHeader("Select Location")),
              SliverToBoxAdapter(child: addVerticalSpace(8.0)),
              // SliverToBoxAdapter(
              //   child: buildFilterByAdminBoundary(),
              // ),
              SliverToBoxAdapter(child: addVerticalSpace(10.0)),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(child: addHeader("Type")),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(
                  child: buildFilterByTypeWidget(),
                ),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(
                  child: buildFilterByCategoryWidget(),
                ),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(child: addVerticalSpace(20.0)),
              SliverToBoxAdapter(child: buildWheelchairVisibilityView()),
              SliverToBoxAdapter(child: buildWheelchairView()),
              SliverToBoxAdapter(child: addVerticalSpace(16.0)),
              SliverToBoxAdapter(child: buildOpeningHoursVisibilityView()),
              SliverToBoxAdapter(child: buildOpeningHoursView()),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(child: addVerticalSpace(16.0)),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(child: buildOperatorStatusVisibilityView()),
              if (_featureTypeValue == Strings.featureHealthServices)
                SliverToBoxAdapter(child: buildOperatorStatusView()),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Container(
            height: 50.0,
            child: RaisedButton(
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
              color: Colors.white,
              textColor: AppColors.accent,
              child: Text('APPLY FILTERS'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: AppColors.accent)),
            ),
          ),
        ),
      );
    });
  }

  buildFilterByTypeWidget() {
    return Consumer(builder: (context, watch, child) {
      typeList = watch(filterTypesProvider).value;
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: <Widget>[
              for (FilterType model in typeList) buildTypeChip(model)
            ],
          ));
    });
  }

  buildFilterByCategoryWidget() {
    return FilterByCategory();
  }

  Widget buildTypeChip(FilterType model) {
    return ChoiceChip(
      labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
      label: Text(
        model.title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black12,
      elevation: 1.0,
      selected: model.isCheck,
      onSelected: (selected) {
        context.read(filterTypesProvider).add(model);
      },
    );
  }

  Widget buildCategoryChip(FilterType model) {
    return ChoiceChip(
      labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
      label: Text(
        model.title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.black12,
      elevation: 1.0,
      selected: model.isCheck,
      onSelected: (selected) {
        // context.read(filterByCategoryProvider).add(model);
      },
    );
  }

  Widget buildTypeCheckbox(FilterType type) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.accent,
      title: Text(
        type.title,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      value: type.isCheck,
      onChanged: (val) {
        setState(() {
          type.isCheck = val;
        });
      },
    );
  }

  addDescription(String desc) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }

  addHeaderWithImage(String text, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: <Widget>[
        Icon(
          icon,
          color: Colors.black,
        ),
        SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ]),
    );
  }

  addVerticalSpace(double d) {
    return SizedBox(
      height: d,
    );
  }

  buildOperatorStatusVisibilityView() {
    return Consumer(
      builder: (context, watch, child) {
        _operatorStatusVisibilityValue =
            watch(operatorStatusVisibilityProvider).value;
        return SwitchListTile(
          title: Text(
            "Operated by",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          secondary: const Icon(
            Icons.business,
            color: Colors.black,
          ),
          value: _operatorStatusVisibilityValue,
          onChanged: (val) {
            context.read(operatorStatusVisibilityProvider).toggle(val);
          },
        );
      },
    );
  }

  buildOperatorStatusView() {
    return Consumer(builder: (context, watch, child) {
      _operatorStatusValue = watch(operatorStatusProvider).value;
      _operatorStatusVisibilityValue =
          watch(operatorStatusVisibilityProvider).value;
      return Visibility(
        visible: _operatorStatusVisibilityValue == true,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read(operatorStatusProvider).toggle(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _operatorStatusValue == 0
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _operatorStatusValue == 0
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 56,
                          // width: _width,
                          child: Center(
                              child: Text(
                            "Public",
                            style: TextStyle(
                                color: _operatorStatusValue == 0
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    ),
                    // SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read(operatorStatusProvider).toggle(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _operatorStatusValue == 1
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _operatorStatusValue == 1
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 56,
                          child: Center(
                              child: Text(
                            "Private",
                            style: TextStyle(
                                color: _operatorStatusValue == 1
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read(operatorStatusProvider).toggle(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _operatorStatusValue == 2
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _operatorStatusValue == 2
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 56,
                          child: Center(
                              child: Text(
                            "Public Owned, Private Operated",
                            style: TextStyle(
                                color: _operatorStatusValue == 2
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ),
                    )
                  ],
                ))),
      );
    });
  }

  buildWheelchairVisibilityView() {
    return Consumer(
      builder: (context, watch, child) {
        _wheelchairVisibilityValue = watch(wheelchairVisibilityProvider).value;
        return SwitchListTile(
          title: Text(
            "Wheelchair Access",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: _wheelchairVisibilityValue,
          secondary: const Icon(
            Icons.wheelchair_pickup,
            color: Colors.black,
          ),
          onChanged: (val) {
            context.read(wheelchairVisibilityProvider).toggle(val);
          },
        );
      },
    );
  }

  buildWheelchairView() {
    return Consumer(builder: (context, watch, child) {
      _wheelchairValue = watch(wheelchairProvider).value;
      _wheelchairVisibilityValue = watch(wheelchairVisibilityProvider).value;
      return Visibility(
        visible: _wheelchairVisibilityValue == true,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            // setState(() => _wheelchairValue = 0),
                            context.read(wheelchairProvider).toggle(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _wheelchairValue == 0
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _wheelchairValue == 0
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 45,
                          // width: _width,
                          child: Center(
                              child: Text(
                            "Accessible",
                            style: TextStyle(
                                color: _wheelchairValue == 0
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    ),
                    // SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            // setState(() => _wheelchairValue = 1),
                            context.read(wheelchairProvider).toggle(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _wheelchairValue == 1
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _wheelchairValue == 1
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 45,
                          child: Center(
                              child: Text(
                            "Limited",
                            style: TextStyle(
                                color: _wheelchairValue == 1
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    )
                  ],
                ))),
      );
    });
  }

  buildOpeningHoursVisibilityView() {
    return Consumer(
      builder: (context, watch, child) {
        _opening24HoursVisibilityValue =
            watch(openingHoursVisibilityProvider).value;
        return SwitchListTile(
          title: Text(
            "Operating hours",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: _opening24HoursVisibilityValue,
          secondary: const Icon(
            Icons.watch_later_outlined,
            color: Colors.black,
          ),
          onChanged: (val) {
            context.read(openingHoursVisibilityProvider).toggle(val);
          },
        );
      },
    );
  }

  buildOpeningHoursView() {
    return Consumer(builder: (context, watch, child) {
      _opening24HoursValue = watch(openingHoursProvider).value;
      _opening24HoursVisibilityValue =
          watch(openingHoursVisibilityProvider).value;
      return Visibility(
        visible: _opening24HoursVisibilityValue == true,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read(openingHoursProvider).toggle(0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _opening24HoursValue == 0
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _opening24HoursValue == 0
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 45,
                          // width: _width,
                          child: Center(
                              child: Text(
                            "Open 24 hours",
                            style: TextStyle(
                                color: _opening24HoursValue == 0
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    ),
                    // SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            context.read(openingHoursProvider).toggle(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _opening24HoursValue == 1
                                ? AppColors.accent
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: _opening24HoursValue == 1
                                      ? AppColors.accent
                                      : Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  // shadow direction: bottom right
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0)
                            ],
                          ),
                          height: 45,
                          child: Center(
                              child: Text(
                            "Emergency Only",
                            style: TextStyle(
                                color: _opening24HoursValue == 1
                                    ? Colors.white
                                    : Colors.black),
                          )),
                        ),
                      ),
                    )
                  ],
                ))),
      );
    });
  }

  bool validateFilters() {
    String selectedDistrictLabel = "";
    if (selectedDistrict != null)
      selectedDistrictLabel = selectedDistrict.label.en;

    return context.read(filterTypesProvider).getSelected().isEmpty &&
        _featureCategoryValue.title == "Any" &&
        (selectedDistrictLabel == "All" || selectedDistrictLabel.isEmpty) &&
        context.read(wheelchairVisibilityProvider).value == false &&
        context.read(openingHoursVisibilityProvider).value == false &&
        context.read(operatorStatusVisibilityProvider).value == false;
  }

  void resetFilters() {
    context.read(filterTypesProvider).removeAll();
    context.read(filterByCategoryProvider).removeAll();
    context.read(filterAdminBoundaryProvider).removeAll();
    context.read(wheelchairVisibilityProvider).toggle(false);
    context.read(openingHoursVisibilityProvider).toggle(false);
    context.read(operatorStatusVisibilityProvider).toggle(false);
    context.read(wheelchairProvider).toggle(0);
    context.read(openingHoursProvider).toggle(0);
    context.read(operatorStatusProvider).toggle(0);
  }
}

class FilterType {
  String title;
  bool isCheck;
  String filterTag;

  FilterType({this.title, this.isCheck, this.filterTag});

  Map<String, dynamic> toJson() => {"title": title};

  int get hashCode => title.hashCode;

  bool operator ==(Object other) => other is FilterType && other.title == title;
}
