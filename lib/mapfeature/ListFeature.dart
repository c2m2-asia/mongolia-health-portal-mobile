import 'package:flutter/material.dart';
/// The base class for the different types of items the list can contain.
abstract class ListFeature {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}
/// A ListItem that contains data to display a heading.
class HeadingItem implements ListFeature {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListFeature {
  final String key;
  final String value;

  MessageItem(this.key, this.value);

  Widget buildTitle(BuildContext context) => Text(key);

  Widget buildSubtitle(BuildContext context) => Text(value);
}