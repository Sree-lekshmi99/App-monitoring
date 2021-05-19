// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import 'package:app_usage/app_usage.dart';
// import 'package:monitoring_app/functions/spin.dart';
// import 'package:monitoring_app/functions/calc.dart';
// import 'package:monitoring_app/main.dart';
//
//
// class Home extends StatefulWidget {
//
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   List<AppUsageInfo> _infos = [];
//   List<ApplicationWithIcon> _installedApps = [];
//
//
//   void getUsageStats() async {
//
//     await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true).then((apps) {
//       _installedApps = apps;
//     });
//
//
//     try {
//       DateTime endDate = new DateTime.now();
//       DateTime startDate = endDate.subtract(Duration(hours: 1));
//       List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, endDate);
//       setState(() {
//         _infos = infoList;
//         //    _installedApps = _installedApps.where((app) => _infos.toList().contains(app.packageName)).toList();
//       });
//
//       // for (var info in infoList) {
//       //   print(info.toString());
//       // }
//     } on AppUsageException catch (exception) {
//       print(exception);
//     }
//
//   }
//   @override
//   void initState(){
//     super.initState();
//     getUsageStats();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('App Usage Example'),
//           backgroundColor: Colors.green,
//         ),
//         body: ListView.builder(
//             itemCount: _installedApps.length,
//             itemBuilder: (context, index) {
//               return Container(
//                   child: Row(
//                     children: [
//                       Expanded(
//                           child: Image.memory(_installedApps[index].icon,)
//                         // leading: _installedApps is ApplicationWithIcon
//                         // ? CircleAvatar(
//                         //     backgroundImage: MemoryImage(_installedApps[index].icon),
//                         // backgroundColor: Colors.white,
//                       ),
//
//                       Expanded(child: Text(_installedApps[index].appName)),
//                       Expanded(child: Text(_infos[index].usage.toString())
//                       ),
//                     ],
//                   )
//               );
//
//
//             }
//         ),
//         // floatingActionButton: FloatingActionButton(
//         // onPressed: getUsageStats, child: Icon(Icons.file_download)),
//       ),
//
//     );
//
//   }
// }
