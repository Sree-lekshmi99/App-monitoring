import 'package:flutter/material.dart';
import 'dart:typed_data';

class AppModel{
  final String title;
  final String usageinfo;
  final Uint8List icon;

  AppModel({
    this.title,
    this.usageinfo,
    this.icon
  });
}

class AppTime{
  final String package;
  final int time;


  AppTime({
    this.package,
    this.time

  });
}