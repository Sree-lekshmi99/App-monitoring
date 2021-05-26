import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:monitoring_app/screens/Home.dart';
import 'package:monitoring_app/screens/trackedapps.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int pageIndex = 0;
  final ListAppsPage _homescreen = ListAppsPage();
  final TrackApps _trackApps = new TrackApps();

  Widget _showscreens = new ListAppsPage();

  Widget _screenchooser(int screen)
  {
    switch(screen)
    {
      case 0:
        return _homescreen;
        break;
      case 1:
        return _trackApps;
        break;
      default:
        return new Container(
            child:new Center(
              child: new Text('No Page Found',
                  style: TextStyle(
                      fontSize: 50
                  )),
            )
        );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        color: Colors.white54 ,


        items: <Widget>[
          Icon(Icons.home_outlined,size: 40, color: Colors.black),
          Icon(Icons.track_changes_outlined,size: 40, color: Colors.black),


        ],
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (int tappedIndex)
        {
          setState(() {
            _showscreens = _screenchooser(tappedIndex);

          });

        },



      ),
      body: Container(
        // color: Color(0xFF020528),
        child: Center(

          child: _showscreens,
        ),
      ),
    );
  }
}
