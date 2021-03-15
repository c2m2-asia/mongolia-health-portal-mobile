import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailBottom extends StatefulWidget {
  _DetailBottom createState() => _DetailBottom();
}
class _DetailBottom extends State<DetailBottom> {
  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      color: Colors.grey[800],
      onPressed: () {
      },
      child: Text(
        'EDIT',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}