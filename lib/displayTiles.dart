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

class DisplayTile extends StatefulWidget {
  String initialType;
  String graphType;

  DisplayTile({String initType = 'text', String graphType = 'line'}) {
    initialType = initType;
    this.graphType = graphType;
  }

  @override
  DisplayTileState createState() => DisplayTileState(initialType, graphType);
}

class DisplayTileState extends State<DisplayTile> {
  @override
  initState() {}

  String initialType;
  String graphType;

  DisplayTileState(this.initialType, this.graphType) {
    typeValue = initialType;
  }

  String typeValue; // = 'graph';
  String dataValue = 'Speed';

  _displayDialog(BuildContext context) async {
    print('tapped');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Anzeige festlegen'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<String>(
                  value: dataValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dataValue = newValue;
                    });
                  },
                  items: <String>['SoC', 'Speed', 'temperature', 'range']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: typeValue,
                  onChanged: (String newValue) {
                    setState(() {
                      typeValue = newValue;
                    });
                  },
                  items: <String>['graph', 'text', 'dial']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onLongPress: () => {_displayDialog(context)},
      child: Container(
        margin: const EdgeInsets.all(2.0),
        padding: EdgeInsets.all(3),
        child: _getDisplay(),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.black, width: 2, style: BorderStyle.solid)),
      ),
    );
  }

  dynamic _getDisplay() {
    if (typeValue == 'graph') {
      if (graphType == 'line') {
        return SimpleTimeSeriesChart.withSampleData();
      } else {
        return CustomRoundedBars.withSampleData();
      }
    } else if (typeValue == 'text') {
      return FittedBox(
          fit: BoxFit.fitWidth,
          child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Text(
                  '123',
                  style: TextStyle(
                      inherit: false, fontSize: 180, color: Colors.black87),
                ),
                Text('km/h',
                    style: TextStyle(
                        inherit: false, fontSize: 20, color: Colors.black))
              ])));
    } else {
      return FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'dial',
            style: TextStyle(inherit: false, color: Colors.black87),
          ));
    }
  }
}

class CustomRoundedBars extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CustomRoundedBars(this.seriesList, {this.animate});

  /// Creates a [BarChart] with custom rounded bars.
  factory CustomRoundedBars.withSampleData() {
    return new CustomRoundedBars(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
          // By default, bar renderer will draw rounded bars with a constant
          // radius of 100.
          // To not have any rounded corners, use [NoCornerStrategy]
          // To change the radius of the bars, use [ConstCornerStrategy]
          cornerStrategy: const charts.ConstCornerStrategy(30)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2000, 9, 1,9,45), 5),
      new TimeSeriesSales(new DateTime(2000, 9, 1,10,00), 5),
      new TimeSeriesSales(new DateTime(2000, 9, 1,10,15), 5),
      new TimeSeriesSales(new DateTime(2000, 9, 1,10,30), 25),
      new TimeSeriesSales(new DateTime(2000, 9, 1,10,45), 15),
      new TimeSeriesSales(new DateTime(2000, 9, 1,11,0), 10),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
