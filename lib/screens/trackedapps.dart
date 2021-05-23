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
  SharedPreferences preferences;


  @override
  void initState() {
   _getApp();
    super.initState();

  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _getApp() async{
    preferences = await SharedPreferences.getInstance();
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



          var limit = preferences.getInt(app.packageName);
          if(x.packageName.contains(app.packageName)&& limit!=null)
          {

     //       var limit =
       print('final ${app.packageName} $limit');
       var status = " ";
       if( x.usage > Duration(seconds: limit))
       {

         status= "Limit Reached";
       }
            var item = AppModel(
                title: app.appName,
                usageinfo: x.usage,
                icon: app.icon,
                time:  Duration(seconds: limit),
                status: status

            );

            listApps.add(item);

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
                  subtitle: Row(
                    children: [


                     new  Text('${_printDuration(listApps[i].usageinfo)}  /  '),

                     new Text(_printDuration(listApps[i].time)),
                      new Text(listApps[i].status)

                    ],
                  ),
                  onTap: (){
                    //  DeviceApps.openApp(listApps[i].package);
                  },
                ),
              ],
            ),
          ),

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
  final Duration usageinfo;
  final Uint8List icon;
  final Duration time;
  final String status;

  AppModel({
    this.title,
    this.usageinfo,
    this.icon,
    this.time,
    this.status
  });
}