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

class DrivingPage extends StatefulWidget {
  @override
  DrivingState createState() => DrivingState();
}

class DrivingState extends State<DrivingPage> {
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
          title: Text('Driving Data'),
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
              Center(child: Text("Current Consumption")),
           //   Text(''),
              TextTile('consum'),
            //  Text(''),

              Center(child: Text("Speed")),
           //   Text(''),
              TextTile('622003'),
            //  Text(''),

              Center(child: Text("Average Consumption")),
              LineChartTile('623459'),TextTile('623459'),
              Center(child: Text("Remaining Range")),
              LineChartTile('623458'),
              TextTile('623458'),

//              Center(child: Text("Speed")),
//              Center(child: Text("Torque")),
//              Center(child: Text("Distance")),
//
//              TextTile('622003'),
//              TextTile('622243'),
//              TextTile('622006'),
            ],
            staggeredTiles: const <StaggeredTile>[
             // const StaggeredTile.count(12, 1),
              const StaggeredTile.count(4, 4),
              const StaggeredTile.count(8, 4),
            //  const StaggeredTile.count(2, 4),
          //    const StaggeredTile.count(12, 1),
              const StaggeredTile.count(4, 4),
              const StaggeredTile.count(8, 4),
            //  const StaggeredTile.count(2, 4),


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
