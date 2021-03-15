import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/models/search_response.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class SearchData extends StatefulWidget {
  @override
  _SearchDataState createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  List<SearchItem> tempList = <SearchItem>[];
  bool isLoading = false;
  String queryText = "";
  final queryHolder = TextEditingController();

  clearTextInput() {
    queryHolder.clear();
    queryText = "";
    context.read(searchResponseProvider).clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).text(Strings.SEARCH_PAGE_TITLE)),
          elevation: 0.0,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchBar(),
              Expanded(
                flex: 1,
                child: _mainData(),
              )
            ],
          ),
        ));
  }

  Widget _searchBar() {
    return Consumer(builder: (context, watch, child) {
      tempList = watch(searchResponseProvider).response;
      return Container(
          padding: EdgeInsets.all(12.0),
          color: Theme.of(context).primaryColor,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: TextField(
              autofocus: true,
              controller: queryHolder,
              cursorColor: Theme.of(context).primaryColor,
              onChanged: (text) {
                queryText = text.trim();
                if (text.trim().isEmpty)
                  clearTextInput();
                else
                  _searchData(text);
              },
              decoration: InputDecoration(
                hintText: "your query here...",
                hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                prefixIcon: Material(
                  elevation: 0.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Icon(Icons.search),
                ),
                suffixIcon: queryText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            clearTextInput();
                          });
                        },
                        icon: Icon(
                          Icons.close,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13),
              ),
            ),
          ));
    });
  }

  Widget _mainData() {
    return Consumer(builder: (context, watch, child) {
      tempList = watch(searchResponseProvider).response;
      return Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.separated(
                  itemCount: tempList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (context, index) {
                    print("search rsponse");
                    print(tempList[index].toString());
                    return buildListTile(tempList[index]);
                  }));
    });
  }

  _searchData(String query) async {
    var searchProvider = context.read(searchResponseProvider);
    await searchProvider.searchData(query);

    if (searchProvider.error != null) {
      // show error
      print(searchProvider.error);
    } else {
      tempList = context.read(searchResponseProvider).response;
    }
  }

  Widget buildListTile(SearchItem searchResponse) {
    String subtitle = "";
    List<String> subtitles = [];
    if (searchResponse.service.isNotEmpty)
      subtitle = searchResponse.service[0] + " available here ";
    else if (searchResponse.category.isNotEmpty)
      subtitles.addAll(searchResponse.category);
    else if (searchResponse.speciality.isNotEmpty)
      subtitles.addAll(searchResponse.speciality);
    else
      subtitle = searchResponse.geometries.properties.tags.addrCity == null
          ? searchResponse.geometries.properties.tags.amenity
          : searchResponse.geometries.properties.tags.addrCity;

    return ListTile(
      title: Text(
        searchResponse.geometries.properties.tags.name == null
            ? searchResponse.geometries.properties.tags.nameMn == null
                ? searchResponse.id.toString()
                : searchResponse.geometries.properties.tags.nameMn
            : searchResponse.geometries.properties.tags.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle.isEmpty
          ? buildFilterByTypeWidget(subtitles)
          : Text(subtitle),
      leading: Icon(Icons.location_pin),
      onTap: () {
        context.read(selectedSearchFeatureProvider).toggle(searchResponse);
        Navigator.pop(context);
      },
    );
  }

  buildFilterByTypeWidget(List<String> subtitles) {
    return Container(
        child: Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[for (String model in subtitles) buildTypeChip(model)],
    ));
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
