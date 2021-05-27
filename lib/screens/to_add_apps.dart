
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:monitoring_app/functions/spin.dart';
import 'dart:typed_data';
import 'trackedapps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monitoring_app/notifications/notificationmanger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddAppsToTrack extends StatefulWidget {
  const AddAppsToTrack({Key key}) : super(key: key);



  @override
  _AddAppsToTrackState createState() => _AddAppsToTrackState();
}

class _AddAppsToTrackState extends State<AddAppsToTrack> {
  List listApps = [];
  List _infos = [];
  SharedPreferences preferences;


  @override
  void initState() {
    super.initState();
    _getApp();
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

            var item = AppModel(
                title: app.appName,
                //  usageinfo: x.usage.toString(),
                icon: app.icon,
                package: app.packageName
            );
            listApps.add(item);





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
        body: Column(
          children: [
             Expanded(
              child:listApps.length == 0? loading: ListView.builder(
                itemCount: listApps.length,
                itemBuilder: (context, int i) => Column(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)
                          ),
                          side: BorderSide(width: 2, color: Colors.grey.shade100)),
                      child: new ListTile(
                        leading: Image.memory(listApps[i].icon),
                        title: new Text(listApps[i].title),


                        onTap: () {
                          int maxLimitime;
                          DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              backgroundColor: Colors.blueGrey,
                                doneStyle: TextStyle(color: Colors.black),
                                containerHeight: MediaQuery.of(context).size.height * 0.3
                            ),
                            showTitleActions: true,
                            onConfirm: (time) async  {
                            print(' confirm $time');
                            maxLimitime= (time.hour * 60 * 60) + (time.minute * 60);
                            print(' seconds $maxLimitime ${listApps[i].package}');


                            await preferences.setInt(listApps[i].package, maxLimitime);

                            print('saved timed ${preferences.getInt(listApps[i].package)}');







                            },
                            currentTime: DateTime.utc(0),
                            locale: LocaleType.en,
                          );


                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    this.package,


  });
}










