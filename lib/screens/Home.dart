import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:monitoring_app/functions/spin.dart';
import 'package:monitoring_app/functions/calc.dart';
import 'dart:developer';


class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, double> _infos;
  List<ApplicationWithIcon> _deviceApps = [];
  List<Application> apps;



  void getUsageStats() async {



     apps = await DeviceApps.getInstalledApplications();
   // apps = await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeSystemApps: true);
    bool isInstalled = await DeviceApps.isAppInstalled('com.example.monitoring_app.app');
   // await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true).then((apps) {
      //_deviceApps = apps ; log('deviceapps:$_deviceApps');



    AppUsage appUsage = new AppUsage();

    try {

      DateTime endDate = new DateTime.now();
      DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      Map<String, double> infoList;
      await AppUsage.getAppUsage(startDate, endDate).then((value) => log('loge: $value')); //as Map<String, double>;
      infoList.removeWhere((key,val) => val == 0);
      setState(() {
        _infos = infoList;
        _deviceApps = _deviceApps.where((app) => _infos.keys.toList().contains(app.packageName)).toList();
      });

      for (var info in infoList.keys) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState(){
    super.initState();
    getUsageStats();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _deviceApps.length == 0 || _infos == null ? loading : Padding(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index){
            return Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Row(
                  children: <Widget>[
                    // Expanded(
                    //     flex: 1,
                    //     child: Image.memory(apps[index].icon, scale: 8,)
                    // ),
                    SizedBox(width: 20,),
                    Expanded(
                      flex: 8,
                      child: Text('${apps[index].appName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${_infos[apps[index].packageName]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<ApplicationWithIcon>('applicationWithIcon', applicationWithIcon));
  // }
}
