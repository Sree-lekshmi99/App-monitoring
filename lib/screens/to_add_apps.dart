import 'package:flutter/material.dart';


class AddAppsToTrack extends StatefulWidget {
  const AddAppsToTrack({Key key}) : super(key: key);



  @override
  _AddAppsToTrackState createState() => _AddAppsToTrackState();
}

class _AddAppsToTrackState extends State<AddAppsToTrack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track ',
        style: TextStyle(
                    color: Colors.black
        ),),
      ),
    );
  }
}
