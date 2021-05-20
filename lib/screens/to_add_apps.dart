import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:typed_data';
import 'trackedapps.dart';

class AddAppsToTrack extends StatefulWidget {
  const AddAppsToTrack({Key key}) : super(key: key);



  @override
  _AddAppsToTrackState createState() => _AddAppsToTrackState();
}

class _AddAppsToTrackState extends State<AddAppsToTrack> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text("No apps added to track"),

          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => TrackApps())),
              child: new Icon(Icons.add))
      ),



    );



  }
}


