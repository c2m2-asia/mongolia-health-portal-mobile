import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/state/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String radioItem = '';

  @override
  Widget build(BuildContext context) {
    radioItem = Translations.of(context).currentLanguage.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text("Language Settings"),
          elevation: 0.0,
        ),
        body: addRadioButton());
  }

  addRadioButton() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Select your preferred language"),
              SizedBox(
                height: 8.0,
              ),
              RadioListTile(
                groupValue: radioItem,
                title: Text('English'),
                value: 'en',
                onChanged: (val) {
                  setState(() {
                    radioItem = val;
                  });
                  application.onLocaleChanged(new Locale(val, ''));
                },
              ),
              RadioListTile(
                groupValue: radioItem,
                title: Text('Mongolia'),
                value: 'mn',
                onChanged: (val) {
                  setState(() {
                    radioItem = val;
                  });
                  application.onLocaleChanged(new Locale(val, ''));
                },
              ),
            ]));
  }
}
