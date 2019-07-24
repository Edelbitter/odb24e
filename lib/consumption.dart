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
import 'pieChartTile.dart';

class ConsumptionPage extends StatefulWidget {
  @override
  ConsumptionState createState() => ConsumptionState();
}

class ConsumptionState extends State<ConsumptionPage> {
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
          title: Text('Consumption Data'),
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
              Center(child:Text("Recuperation")),
           //   LineChartTile('623459'),
              TextTile('consum'),
              TextTile('recup'),


              Center(child:Text("Distribution")),
              Text(''),
              PieChartTile(),
              Text(''),


//              Center(child:Text("Battery Health")),
//              Center(child:Text("Battery Voltage")),
//              Center(child:Text("Battery Current")),
//
//              TextTile(data:'90',unit:'%'),
//              TextTile(data:'399',unit:'V'),
//              TextTile(data:'123',unit:'A'),


            ],
            staggeredTiles: const <StaggeredTile>[
              const StaggeredTile.count(6, 1),
              const StaggeredTile.count(6, 1),
              const StaggeredTile.count(6, 4),
              const StaggeredTile.count(6, 4),

              const StaggeredTile.count(12, 1),
              const StaggeredTile.count(1, 10),

              const StaggeredTile.count(10, 10),
              const StaggeredTile.count(1, 10),



            ],
          ),
        ));
  }
}