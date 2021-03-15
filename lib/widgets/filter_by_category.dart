import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/screens/filter_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class FilterByCategory extends StatefulWidget {
  @override
  _FilterByCategoryState createState() => _FilterByCategoryState();
}

class _FilterByCategoryState extends State<FilterByCategory> {
  FilterType selectedFilter;
  List<FilterType> categories;

  @override
  Widget build(BuildContext context) {
    return addDropDown();
  }

  addDropDown() {
    return Consumer(builder: (context, watch, child) {
      categories = context.read(filterByCategoryProvider).value;
      selectedFilter = watch(filterByCategoryProvider).selectedChoices;
      return Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Translations.of(context).text(Strings.FILTER_BY_CATEGORY_TITLE)),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // color: Colors.cyan,
                    border: Border.all(
                      color: AppColors.primary,
                    )),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        isExpanded: true,
                        value: selectedFilter,
                        items: categories.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.title),
                          );
                        }).toList(),
                        onChanged: (selectedItem) => context
                            .read(filterByCategoryProvider)
                            .toggle(selectedItem))),
              ),
            ],
          ));
    });
  }
}
