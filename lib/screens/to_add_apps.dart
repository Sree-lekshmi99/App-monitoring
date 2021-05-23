
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:typed_data';
import 'trackedapps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddAppsToTrack extends StatefulWidget {
  const AddAppsToTrack({Key key}) : super(key: key);



  @override
  _AddAppsToTrackState createState() => _AddAppsToTrackState();
}

class _AddAppsToTrackState extends State<AddAppsToTrack> {
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
                icon: app.icon,
                package: app.packageName

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
        body: ListView.builder(
          itemCount: listApps.length,
          itemBuilder: (context, int i) => Column(
            children: [
              new ListTile(
                leading: Image.memory(listApps[i].icon),
                title: new Text(listApps[i].title),
                //   subtitle: new Text(listApps[i].usageinfo),

                onTap: () async{
                  DatePicker.showTimePicker(context,
                    theme: DatePickerTheme(
                        doneStyle: TextStyle(color: Colors.black),
                        containerHeight: MediaQuery.of(context).size.height * 0.3
                    ),
                    showTitleActions: true,
                    onConfirm: (time)  {
                    print(' confirm $time');


                    },
                    currentTime: DateTime.utc(0),
                    locale: LocaleType.en,
                  );

                   // DeviceApps.openApp(listApps[i].package);
                },
              ),
            ],
          ),
        ),

      ),
    );



  }
}

class AppModel{
  final String title;
  final String usageinfo;
  final Uint8List icon;
  final String package;

  AppModel({
    this.title,
    this.usageinfo,
    this.icon,
    this.package
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








