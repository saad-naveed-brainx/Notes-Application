import 'package:flutter/material.dart';

class AppRouter {
  static void moveBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
