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

class LineChartTile extends StatefulWidget {

  List data;

  LineChartTile({this.data}){}

  @override
  LineChartState createState() => LineChartState(data:data);
}

class LineChartState extends State<LineChartTile>
{
  LineChartState({this.data}){}

  var dtState = new DisplayTileState();
  List data;


  @override
  Widget build(BuildContext context)
  {
    print('printing data');
    print(data);
    return dtState.buildOuter(getDisplay());
  }


  dynamic getDisplay()
  {
    return charts.TimeSeriesChart(
     [new charts.Series<DoubleData, DateTime>(
      id: 'Battery',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (DoubleData dat, _) => dat.time,
      measureFn: (DoubleData dat, _) => dat.data,
      data: data,
    )]);
  }
}