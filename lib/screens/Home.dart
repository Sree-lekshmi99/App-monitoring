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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _getApp() async{
  //  List _apps = await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true, includeSystemApps: true);

    try {
      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, endDate);
      setState(() {
        _infos = infoList;

      });


      for(var x in infoList){
        ApplicationWithIcon   app =    await DeviceApps.getApp(x.packageName,true);
   //     for(var app in _apps){
   //       if(x.packageName.contains(app.packageName)
    //      )
   //       {
            var item = AppModel(
                title: app.appName,
                usageinfo: x.usage,
                icon: app.icon

            );
            listApps.add(item);
        //  }

       // }
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
          Card(
            child: new ListTile(
              leading: Image.memory(listApps[i].icon),
                            
              title: new Text(listApps[i].title),
              subtitle:  new  Text('${_printDuration(listApps[i].usageinfo)}'),
              onTap: (){
                //  DeviceApps.openAvpp(listApps[i].package);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppModel{
  final String title;
  final Duration usageinfo;
  final Uint8List icon;

  AppModel({
    this.title,
    this.usageinfo,
    this.icon
  });
}



