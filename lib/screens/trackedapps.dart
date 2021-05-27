import 'package:flutter/cupertino.dart';
import 'package:monitoring_app/functions/spin.dart';

import 'to_add_apps.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:typed_data';
import 'package:app_usage/app_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitoring_app/notifications/notificationmanger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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
  NotificationManager notificationManager = NotificationManager();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;




  @override
  void initState() {
   _getApp();
    super.initState();
    flutterLocalNotificationsPlugin= new FlutterLocalNotificationsPlugin();
   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
   var iOS = new IOSInitializationSettings();
   var initSetttings = new InitializationSettings(android: android, iOS: iOS);
   flutterLocalNotificationsPlugin.initialize(initSetttings,
       onSelectNotification: onSelectNotification);


  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    // showDialog(
    //   context: context,
    //   // builder: (_) => new AlertDialog(
    //   //   title: new Text('Notification'),
    //   //   content: new Text('$payload'),
    //   // ),
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _getApp() async{
    preferences = await SharedPreferences.getInstance();
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

       print('final ${app.packageName} $limit');
       var status = " ";
       if( x.usage >= Duration(seconds: limit))
       {
       showNotification(app.appName);
         status= " Limit Reached! ";

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
          body: Center(
            child: listApps.length== null? loading : ListView.builder(
              itemCount: listApps.length,
              itemBuilder: (context, int i) => Column(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)
                        ),
                        side: BorderSide(width: 2, color: Colors.grey)),

                    child: new ListTile(
                      leading: Image.memory(listApps[i].icon),

                      title: new Text(listApps[i].title),
                      subtitle: Row(
                        children: [


                         Expanded(

                             child: new  Text('${_printDuration(listApps[i].usageinfo,

                         )}  /',
                         style: TextStyle(
                             fontSize: 15,

                         ),)),


                         Expanded(

                           child: new Text(_printDuration(listApps[i].time,
                           ),
                           style: TextStyle(
                               fontSize: 15,
                               color: listApps[i].time <= listApps[i].usageinfo ? Colors.red : Colors.green
                           ),),
                         ),
                          Expanded(
                            child:  Text(listApps[i].status,
                              style: TextStyle(fontSize: 9,color: Colors.red,fontWeight: FontWeight.bold),

                          ),)

                        ],
                      ),
                      onTap: (){
                        //  DeviceApps.openApp(listApps[i].package);
                      },
                    ),

                  ),

                ],
              ),
            ),
          ),

          // floatingActionButton: FloatingActionButton(
          //     onPressed: () => Navigator.push(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (context) => AddAppsToTrack()
          //         )
          //
          //     ),
          //     child: new Icon(Icons.add))
      ),



    );
  }
  showNotification(String payload) async {

    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high,importance: Importance.max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Time Exceded', 'You have reached the usage limit for $payload', platform,
        payload: 'You have reached the usage limit for $payload');
   // await flutterLocalNotificationsPlugin.cancelAll();
  }
}
class AppModel{
  final String title;
  final Duration usageinfo;
  final Uint8List icon;
  final Duration time;
  final String status;
  final NotificationManager manger;
  final Color color;



  AppModel({
    this.title,
    this.usageinfo,
    this.icon,
    this.time,
    this.status,
    this.manger,
    this.color
  });
}







