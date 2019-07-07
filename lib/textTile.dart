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

class TextTile extends StatefulWidget {

  String unit;
  String data;
  TextTile({this.data,this.unit}){}
  @override
  TextTileState createState() => TextTileState(data:data,unit:unit);
}

class TextTileState extends State<TextTile>
{
  TextTileState({this.data,this.unit}){}
  var dtState = new DisplayTileState();
  String unit;
  String data;


  @override
  Widget build(BuildContext context)
  {
    return dtState.buildOuter(getDisplay());
  }


  dynamic getDisplay()
  {
    var row = [Text(
      data,
      style: TextStyle(
          inherit: false, fontSize: 180, color: Colors.black87),
    )];
    if(unit != null)
      {
        row.add(Text(unit,
            style: TextStyle(
                inherit: false, fontSize: 30, color: Colors.black)));
      }


    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
            alignment: Alignment.bottomCenter,
            child: Row(children: row)));
  }
}