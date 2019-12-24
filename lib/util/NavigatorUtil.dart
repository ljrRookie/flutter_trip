import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil{
  static push(BuildContext context,Widget page) async{
    final result = await Navigator.push(
      context,
    MaterialPageRoute(builder: (context) => page));
    return result;

  }
}