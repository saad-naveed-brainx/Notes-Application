import 'package:flutter/material.dart';
import 'package:notes/core/constants/view_constants.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(ViewConstants.home));
  }
}
