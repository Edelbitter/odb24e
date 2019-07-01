import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'main.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'displayTiles.dart';

class DashboardLayoutPage extends StatefulWidget {
  DashboardLayoutPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DashboardLayoutState createState() => DashboardLayoutState();
}

class DashboardLayoutState extends State<DashboardLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Text('DashboardLayout'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Image.asset('images/motorCropped.png'),
              title: Text('4 kästen'),
              onTap: () => {
                    Navigator.pushNamed(context, '/layoutDetails', arguments: 4)
                  },
            ),
            Divider(),
            ListTile(
              leading: Image.asset('images/motorCropped.png'),
              title: Text('5 boxen'),
              onTap: () => {
                    Navigator.pushNamed(context, '/layoutDetails', arguments: 5)
                  },
            ),
            Divider(),
            ListTile(
              leading: Image.asset('images/motorCropped.png'),
              title: Text('6 felder'),
              onTap: () => {
                    Navigator.pushNamed(context, '/layoutDetails', arguments: 6)
                  },
            ),
          ],
        ));
  }
}

class DashboardDetailsPage extends StatefulWidget {
  DashboardDetailsPage({Key key, String title}) : super(key: key);

  @override
  DashboardDetailsState createState() => DashboardDetailsState();
}

class DashboardDetailsState extends State<DashboardDetailsPage> {
  int boxNumber;

  @override
  Widget build(BuildContext context) {
    boxNumber = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Text('DashboardDetails'),
        ),
        body: Container(
          constraints: BoxConstraints.tight(MediaQuery.of(context).size),
          margin: EdgeInsets.only(bottom: 15),
          child: new StaggeredGridView.count(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),

            primary: true,
            crossAxisCount: 4,
            // mainAxisSpacing: 2.0,
            // crossAxisSpacing: 2.0,
            children: <Widget>[
              DisplayTile(),
              DisplayTile(),
              DisplayTile(),
              DisplayTile(),
              DisplayTile(),
            ],
            staggeredTiles: const <StaggeredTile>[
              const StaggeredTile.count(4, 2),
              const StaggeredTile.count(2, 2),
              const StaggeredTile.count(2, 2),
              const StaggeredTile.count(2, 2),
              const StaggeredTile.count(2, 2),
            ],
          ),
        ));
  }
}
