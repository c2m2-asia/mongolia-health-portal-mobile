import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperOne(flip: true),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary])),
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Text(
                      Strings.appName,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                        child: Text(
                      Strings.aboutSubtitle,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          Strings.aboutDescription,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify,
                        )),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(top: 14.0),
                  padding:
                      EdgeInsets.only(left: 36.0, right: 12.0, bottom: 12.0),
                  child: Image.asset('assets/plm.png',
                      width: 270, fit: BoxFit.fill)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 8.0),
                child: Text(Strings.aboutPLM,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 8.0),
                child: Text(Strings.emailPLM,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 8.0),
                child: Text(Strings.websitePLM,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.only(left: 36.0, right: 12.0),
                  child: Image.asset('assets/kll.png',
                      width: 320, fit: BoxFit.fill)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 36.0, right: 8.0),
                child: Text(Strings.aboutKLL,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 36.0, right: 8.0),
                child: Text(Strings.emailKLL,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 36.0, right: 8.0),
                child: Text(Strings.websiteKLL,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .merge(TextStyle(fontSize: 14.0))),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
