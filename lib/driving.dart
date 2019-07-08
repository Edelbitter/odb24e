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
              Center(child:Text("Power Consumption")),
              LineChartTile(data:dataBase.batteryTemperatures),
              TextTile(data:dataBase.batteryTemperatures.last.data.toString(),unit:'kW'),

              Center(child:Text("Remaining Range")),
              LineChartTile(data:dataBase.soC),
              TextTile(data:dataBase.soC.last.data.toString(),unit: 'km'),

              Center(child:Text("Speed")),
              Center(child:Text("Torque")),
              Center(child:Text("Recuperation")),

              TextTile(data:'50',unit:'km/h'),
              TextTile(data:'400',unit:'Nm'),
              TextTile(data:'1',unit:'A'),


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