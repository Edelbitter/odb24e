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

class PieChartTile extends StatefulWidget {

  List<List> data;

  PieChartTile({this.data}){}

  @override
  PieChartState createState() => PieChartState(data:data);
}

class PieChartState extends State<PieChartTile>
{
  PieChartState({this.data})
  {
    comboData = new List<ComboDataPiece>();

    comboData.add(new ComboDataPiece('AC',this.data[1][0].data));
    comboData.add(new ComboDataPiece('12V',this.data[0][0].data));
    comboData.add(new ComboDataPiece('Heat',this.data[2][0].data));
    comboData.add(new ComboDataPiece('Drive',this.data[3][0].data));
  }

  var dtState = new DisplayTileState();
  List<List> data;
  List<ComboDataPiece> comboData;


  @override
  Widget build(BuildContext context)
  {
    print('printing data');
    print(data);
    return dtState.buildOuter(getDisplay());
  }

// events for update??
  dynamic getDisplay()
  {
    return charts.PieChart(
        [new charts.Series<ComboDataPiece, String>(
         // id: 'Battery',
          //colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (ComboDataPiece dat, _) => dat.name,
          measureFn: (ComboDataPiece dat, _) => dat.value,
          data: comboData,
          labelAccessorFn: (ComboDataPiece row, _) => '${row.name}: ${row.value}',
        )],defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
      new charts.ArcLabelDecorator(
         // labelPosition: charts.ArcLabelPosition.inside
      )
    ]));
  }
}

class ComboDataPiece
{
  String name;
  double value;

  ComboDataPiece(this.name,this.value);
}