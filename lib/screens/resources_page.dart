import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/models/resources_response.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  void initState() {
    context.read(resourceProvider).fetchResource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).text("resources_page_title")),
          elevation: 0.0,
        ),
        body: buildListView());
  }

  buildListView() {
    List _resourcesList = <Resource>[];
    return Consumer(builder: (context, watch, child) {
      final provider = watch(resourceProvider);
      if (provider.isLoading)
        return CircularProgressIndicator();
      else {
        if (provider.response != null)
          _resourcesList.addAll(provider.response.data);
        if (_resourcesList.isEmpty)
          return Center(
            child: Text("No resources added!"),
          );
        else
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: _resourcesList.length,
              itemBuilder: (context, index) {
                Resource item = _resourcesList[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          Text(item.title),
                          SizedBox(height: 8.0),
                          Text(
                            item.description,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 8.0),
                          Linkify(
                            onOpen: _onOpen,
                            text: item.link,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
      }
    });
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
