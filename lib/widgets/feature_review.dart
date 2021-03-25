import 'package:c2m2_mongolia/localizations/translations.dart';
import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/models/feature_filter_tags.dart' as filter_tags;
import 'package:c2m2_mongolia/models/feature_tags.dart' as feature_tags;
import 'package:c2m2_mongolia/screens/filter_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
import 'package:c2m2_mongolia/ui/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FeatureReview extends StatefulWidget {
  final String serviceId;

  const FeatureReview({Key key, this.serviceId}) : super(key: key);

  @override
  _FeatureReviewState createState() => _FeatureReviewState();
}

class _FeatureReviewState extends State<FeatureReview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isButtonDisabled;
  double rating;
  String userName, serviceReceived;
  String feedback;
  filter_tags.FilterTags filterTags;
  var filterProvider;

  @override
  void initState() {
    // TODO: implement initState
    _isButtonDisabled = true;
    rating = 0;
    userName = "Anonymous";
    loadTags();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Builder(builder: (context) => _reviewView()));
    });
  }

  Widget _reviewView() {
    final TextStyle subtitle =
        TextStyle(fontSize: 16.0, color: AppColors.textSecondary);
    final TextStyle label = TextStyle(
        fontSize: 18.0, color: AppColors.primary, fontWeight: FontWeight.bold);
    return AlertDialog(
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              Translations.of(context).text("rate_this_feature"),
              style: label,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 1.0,
              child: Container(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10.0),
            _buildRatingStar(),
            _buildUserName(),
            SizedBox(height: 12.0),
            Text(
              Translations.of(context).text("review_ratings_helper_text"),
              style: subtitle,
            ),
            SizedBox(height: 20.0),
            _buildServiceViewNew(),
            SizedBox(height: 8.0),
            _buildReview(),
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            Translations.of(context).text("cancel"),
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onPressed: () {
            context.read(filterTypesProvider).removeSelectedChoice();
            Navigator.pop(context);
          },
        ),
        new FlatButton(
          child: new Text(Translations.of(context).text("submit")),
          onPressed: _isButtonDisabled
              ? null
              : () {
                  submit();
                },
        ),
      ],
    );
  }

  void submit() async {
    ReviewsRequest request = new ReviewsRequest(
        osmUsername: userName,
        rating: rating.toInt(),
        comments: feedback,
        service: serviceReceived,
        serviceId: widget.serviceId);
    var reviews = context.read(reviewPublisher);
    await reviews.publishReview(request);

    if (reviews.response != null) {
      _scaffoldKey.currentState.showSnackBar(successSnack());
      Navigator.pop(context);
      print(reviews.response.serviceId);
      var revReReq = context.read(reviewProvider);
      await revReReq.getReview(widget.serviceId);
    } else {
      _scaffoldKey.currentState.showSnackBar(retrySnack(reviews.error));
    }
  }

  SnackBar retrySnack(String error) {
    return SnackBar(
      content: Text('Something went wrong. Please try again later. $error'),
      action: SnackBarAction(
        label: Translations.of(context).text("retry"),
        onPressed: () {
          submit();
        },
      ),
    );
  }

  SnackBar successSnack() {
    return SnackBar(
      content: Text(Translations.of(context).text("review_updated")),
    );
  }

  Widget _buildUserName() {
    if (!_isButtonDisabled)
      return Container(
          margin: EdgeInsets.only(top: 5.0),
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5.0)),
          child: TextField(
            // controller: queryHolder,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Translations.of(context).text("display_name")),
            cursorColor: AppColors.primary,
            onChanged: (text) {
              userName = text.trim().isNotEmpty ? text : "Anonymous";
            },
          ));
    else
      return Container(
        height: 0,
        width: 0,
      );
  }

  Widget _buildServiceViewNew() {
    return Consumer(builder: (context, watch, child) {
      final filterTagsValue = watch(filterTagsProvider);
      List<feature_tags.Selector> selector = <feature_tags.Selector>[];
      if (filterTagsValue.isLoading)
        print("Loading");
      else if (filterTagsValue.response != null &&
          filterTagsValue.response.data != null) {
        for (filter_tags.Datum datum in filterTagsValue.response.data) {
          if (datum.value == "healthService")
            for (feature_tags.EditTag editTag in datum.filterTags)
              if (editTag.osmTag == Strings.filterByType) {
                selector = editTag.selectors;
                break;
              }
        }
      }
      final database = selector.map((e) => e.toJson()).toList();
      database.forEach((element) {
        print("database $element");
        if (Translations.of(context).currentLanguage == "mn") {
          if (element.containsKey("label"))
            element.update("label", (value) => (element.values.last["mn"]));
        }
      });

      String selectedService = watch(filterTypesProvider).selectedService;
      if (selectedService != null) serviceReceived = selectedService;
      return Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: AppColors.primary,
                )),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: new MultiSelectFormField(
                autovalidate: false,
                chipLabelStyle: TextStyle(color: AppColors.primaryButtons),
                chipBackGroundColor: Colors.black12,
                dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(
                  Translations.of(context).text("service_received"),
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: database,
                textField: 'label',
                valueField: 'osm_value',
                okButtonLabel: Translations.of(context).text("ok"),
                cancelButtonLabel: Translations.of(context).text("cancel"),
                onSaved: (value) {
                  context
                      .read(filterTypesProvider)
                      .setSelectedItems([...value]);
                },
              ),
            ),
          ),
        ],
      ));
    });
  }

  Widget _buildRatingStar() {
    return RatingBar.builder(
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.grey.withAlpha(50),
      itemCount: 5,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        this.rating = rating;

        setState(() {
          _isButtonDisabled = !(rating > 0);
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _buildReview() {
    return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5.0)),
        child: TextField(
          // controller: queryHolder,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Translations.of(context).text("write_about_feature")),
          cursorColor: AppColors.primary,
          maxLines: 3,
          onChanged: (text) {
            feedback = text.trim().isNotEmpty ? text : null;
          },
        ));
  }
}
