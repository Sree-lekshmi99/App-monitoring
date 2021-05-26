import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_app/widgets/Navigation.dart';

import 'screens/Home.dart';

import 'screens/to_add_apps.dart';
import 'screens/to_add_apps.dart';
import 'screens/trackedapps.dart';


void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'App Tacker',
      home: Navigation()
  ));
}
