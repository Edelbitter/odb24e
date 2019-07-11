import 'displayTiles.dart';
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
import 'database.dart';
import 'package:provider/provider.dart';


class LineChartTile extends StatefulWidget {

  String ident;

  LineChartTile(this.ident){}

  @override
  LineChartState createState() => LineChartState(ident);
}

class LineChartState extends State<LineChartTile>
{
  LineChartState(this.ident){}

  var dtState = new DisplayTileState();
  String ident;
  var data;


  @override
  Widget build(BuildContext context)
  {
    var dataBase = Provider.of<DataBase>(context);
    data = dataBase.rawData[ident];

    return dtState.buildOuter(getDisplay());
  }


  dynamic getDisplay()
  {
    return Consumer<DataBase>(builder: (context,dataBase,child)=>
      charts.TimeSeriesChart(
     [new charts.Series<DoubleData, DateTime>(
      id: 'Battery',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (DoubleData dat, _) => dat.time,
      measureFn: (DoubleData dat, _) => dat.data,
      data: data,
    )]));
  }
}