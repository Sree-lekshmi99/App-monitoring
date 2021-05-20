import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:typed_data';

class ListAppsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListAppsBody(),
    );
  }
}

class ListAppsBody extends StatefulWidget {
  @override
  _ListAppBodyState createState() => _ListAppBodyState();
}

class _ListAppBodyState extends State {
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
                usageinfo: x.usage.toString(),
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
    return ListView.builder(
      itemCount: listApps.length,
      itemBuilder: (context, int i) => Column(
        children: [
          new ListTile(
            leading: Image.memory(listApps[i].icon),
            title: new Text(listApps[i].title),
            subtitle: new Text(listApps[i].usageinfo),
            onTap: (){
              //  DeviceApps.openApp(listApps[i].package);
            },
          ),
        ],
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



