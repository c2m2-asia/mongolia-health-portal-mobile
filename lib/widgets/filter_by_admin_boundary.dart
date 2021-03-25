import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/models/admin_boundary.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class FilterByAdminBoundary extends StatefulWidget {
  @override
  _FilterByAdminBoundaryState createState() => _FilterByAdminBoundaryState();
}

class _FilterByAdminBoundaryState extends State<FilterByAdminBoundary> {
  Division _selectedDistrict;
  AdminBoundary _selectedKhoroo, _selectedProvince;
  List<AdminBoundary> khorooList = [];
  List<AdminBoundary> boundaries = [];
  List<Division> districtList = [];

  @override
  Widget build(BuildContext context) {
    return addDropDown();
  }

  addDropDown() {
    return Consumer(builder: (BuildContext context, watch, Widget child) {
      boundaries = context.read(filterAdminBoundaryProvider).boundaries;
      districtList = context.read(filterAdminBoundaryProvider).districts;
      _selectedProvince = boundaries[0];
      _selectedDistrict = watch(filterAdminBoundaryProvider).selectedDistrict;
      khorooList = watch(filterAdminBoundaryProvider).khoroos;
      _selectedKhoroo = watch(filterAdminBoundaryProvider).selectedKhoroo;
      _selectedKhoroo = watch(filterAdminBoundaryProvider).selectedKhoroo;
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(Translations.of(context).text("select_location")),
            ),
            Row(
              children: [
                addProvinceDropDown(),
                SizedBox(
                  width: 8.0,
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.of(context).text("district"),
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          // color: Colors.cyan,
                          border: Border.all(
                            color: AppColors.primary,
                          )),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        isExpanded: false,
                        value: _selectedDistrict,
                        items: districtList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(Translations.of(context)
                                        .currentLanguage
                                        .toString() ==
                                    "en"
                                ? item.label.en
                                : item.label.mn),
                          );
                        }).toList(),
                        onChanged: (selectedItem) => context
                            .read(filterAdminBoundaryProvider)
                            .toggleDistrict(selectedItem),
                      )),
                    )
                  ],
                )),
              ],
            ),
            if (khorooList.isNotEmpty) addKhorooDropDown(khorooList)
          ],
        ),
      );
    });
  }

  addKhorooDropDown(List<AdminBoundary> districts) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.0,
        ),
        Text(
          Translations.of(context).text("khoroo"),
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 45.0,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              // color: Colors.cyan,
              border: Border.all(
                color: AppColors.primary,
              )),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  isExpanded: false,
                  value: _selectedKhoroo,
                  items: districts.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    );
                  }).toList(),
                  onChanged: (selectedItem) => context
                      .read(filterAdminBoundaryProvider)
                      .toggleKhoroo(selectedItem))),
        ),
      ],
    ));
  }

  addProvinceDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.of(context).text("province"),
          style: TextStyle(color: AppColors.textSecondary),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
            alignment: Alignment.center,
            height: 50.0,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // color: Colors.cyan,
                border: Border.all(
                  color: AppColors.primary,
                )),
            child: Text(_selectedProvince.label)),
      ],
    );
  }
}
