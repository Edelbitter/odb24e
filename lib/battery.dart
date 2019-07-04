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

class BatteryPage extends StatefulWidget {
  @override
  BatteryState createState() => BatteryState();
}

class BatteryState extends State<BatteryPage> {
  @override
  initState() {}


  @override
  Widget build(BuildContext context) {


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
            crossAxisCount: 3,
            // mainAxisSpacing: 2.0,
            // crossAxisSpacing: 2.0,
            children: <Widget>[
              DisplayTile(initType: 'graph'),
              DisplayTile(),

              DisplayTile(initType: 'graph'),
              DisplayTile(),

              DisplayTile(initType: 'graph'),
              DisplayTile(),

              DisplayTile(initType: 'graph'),
              DisplayTile(),
            ],
            staggeredTiles: const <StaggeredTile>[
              const StaggeredTile.count(2, 1),
              const StaggeredTile.count(1, 1),
              const StaggeredTile.count(2, 1),
              const StaggeredTile.count(1, 1),
              const StaggeredTile.count(2, 1),
              const StaggeredTile.count(1, 1),
              const StaggeredTile.count(2, 1),
              const StaggeredTile.count(1, 1),
            ],
          ),
        ));
  }
}