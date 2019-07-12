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
import 'textTile.dart';
import 'lineChartTile.dart';

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
          title: Text('Battery Data'),
        ),
        body: Container(
          constraints: BoxConstraints.tight(MediaQuery.of(context).size),
          margin: EdgeInsets.only(bottom: 15),
          child: new StaggeredGridView.count(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),

            primary: true,
            crossAxisCount: 12,
            // mainAxisSpacing: 2.0,
            // crossAxisSpacing: 2.0,
            children: <Widget>[
              Center(child:Text("Battery Temperature")),
              LineChartTile('622001'),
              TextTile('622001'),

              Center(child:Text("State of Charge")),
              LineChartTile('622002'),
              TextTile('622002'),

              Center(child:Text("Battery Health")),
              Center(child:Text("Battery Voltage")),
              Center(child:Text("Battery Current")),

              TextTile('623206'),
              TextTile('623203'),
              TextTile('623204'),


            ],
            staggeredTiles: const <StaggeredTile>[
              const StaggeredTile.count(12, 1),
              const StaggeredTile.count(8, 3),
              const StaggeredTile.count(4, 3),
              const StaggeredTile.count(12, 1),
              const StaggeredTile.count(8, 3),
              const StaggeredTile.count(4, 3),
              const StaggeredTile.count(4, 1),
              const StaggeredTile.count(4, 1),
              const StaggeredTile.count(4, 1),
              const StaggeredTile.count(4, 3),
              const StaggeredTile.count(4, 3),
              const StaggeredTile.count(4, 3),



            ],
          ),
        ));
  }
}