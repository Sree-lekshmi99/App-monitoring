import 'to_add_apps.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:typed_data';
import 'package:app_usage/app_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'to_add_apps.dart';


class TrackApps extends StatelessWidget {
  const TrackApps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrackingApps(),
    );
  }
}

class TrackingApps extends StatefulWidget {
  const TrackingApps({Key key}) : super(key: key);

  @override
  _TrackingAppsState createState() => _TrackingAppsState();
}

class _TrackingAppsState extends State<TrackingApps> {
  List listApps = [];
  List _infos = [];


  @override
  void initState() {
    super.initState();
    _getApp();
  }

  void _getApp() async{
    List _apps = await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true, includeSystemApps: true);

    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos = infoList;

      });


      for(var x in infoList){
        for(var app in _apps){
          if(x.packageName.contains(app.packageName)
          )
          {
            var item = AppModel(
                title: app.appName,
                //  usageinfo: x.usage.toString(),
                icon: app.icon

            );
            listApps.add(item);
          }

        }
      }



    } on AppUsageException catch (exception) {
      print(exception);
    }



    //reloading state
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Text("No apps added to track"),

          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => AddAppsToTrack())),
              child: new Icon(Icons.add))
      ),



    );
  }
}
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