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

class PieChartTile extends StatefulWidget {
  PieChartTile() {}

  @override
  PieChartState createState() => PieChartState();
}

class PieChartState extends State<PieChartTile> {
  init() {
    var dataBase = Provider.of<DataBase>(context);
    print(dataBase);

    comboData = dataBase.getCombo();
  }

  var dtState = new DisplayTileState();

  List<ComboDataPiece> comboData;

  @override
  Widget build(BuildContext context) {
    init();

    return dtState.buildOuter(getDisplay());
  }

// events for update??
  dynamic getDisplay() {
    return Consumer<DataBase>(
        builder: (context, dataBase, child) => charts.PieChart([
              new charts.Series<ComboDataPiece, String>(
                // id: 'Battery',
                //colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (ComboDataPiece dat, _) => dat.name ?? 'nuuull',
                measureFn: (ComboDataPiece dat, _) => dat.value,
                data: comboData,
                labelAccessorFn: (ComboDataPiece row, _) =>
                    '${row.name ?? 'meh'}: ${row.value}',
              )
            ],
                defaultRenderer:
                    new charts.ArcRendererConfig(arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                      // labelPosition: charts.ArcLabelPosition.inside
                      )
                ])));
  }
}

class ComboDataPiece {
  String name;
  double value;

  ComboDataPiece(this.name, this.value);
}
