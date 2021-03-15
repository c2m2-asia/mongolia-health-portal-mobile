import 'package:c2m2_mongolia/mapfeature/detail_feature.dart';
import 'package:c2m2_mongolia/screens/filter_page.dart';
import 'package:c2m2_mongolia/state/app_state.dart';
import 'package:c2m2_mongolia/ui/app_colors.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    _isButtonDisabled = true;
    rating = 0;
    userName = "Anonymous";
    super.initState();
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
              'Rate this feature',
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
              "To add a review, please rate, mention the service received and write a comment below and click on the submit button.",
              style: subtitle,
            ),
            SizedBox(height: 20.0),
            _buildServiceView(),
            SizedBox(height: 8.0),
            _buildReview(),
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text(
            "Cancel",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          onPressed: () {
            context.read(filterTypesProvider).removeSelectedChoice();
            Navigator.pop(context);
          },
        ),
        new FlatButton(
          child: new Text("Submit"),
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
        label: 'Retry',
        onPressed: () {
          submit();
        },
      ),
    );
  }

  SnackBar successSnack() {
    return SnackBar(
      content: Text('Review updated successfully.'),
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
                hintText: "Your display name (Optional)"),
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

  Widget _buildServiceView() {
    return Consumer(builder: (context, watch, child) {
      List<FilterType> categories = context.read(filterTypesProvider).value;
      final database = categories.map((e) => e.toJson()).toList();
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
                  "Service Received",
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: database,
                textField: 'title',
                valueField: 'title',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                onSaved: (value) {
                  context
                      .read(filterTypesProvider)
                      .setSelectedItems([...value]);
                },
              ),
            ),
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: DropdownButtonHideUnderline(
            //       child: DropdownButton(
            //           isExpanded: true,
            //           value: selectedFilter,
            //           items: categories.map((item) {
            //             return DropdownMenuItem(
            //               value: item,
            //               child: Text(item.title),
            //             );
            //           }).toList(),
            //           onChanged: (selectedItem) => context
            //               .read(filterTypesProvider)
            //               .toggle(selectedItem))),
            // ),
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
              hintText: 'Write what you think about this feature...'),
          cursorColor: AppColors.primary,
          maxLines: 3,
          onChanged: (text) {
            feedback = text.trim().isNotEmpty ? text : null;
          },
        ));
  }
}
