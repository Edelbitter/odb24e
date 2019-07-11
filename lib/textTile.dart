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
import 'package:provider/provider.dart';
import 'database.dart';
import 'allRequests.dart';


class TextTile extends StatefulWidget {

  String ident;

  TextTile(this.ident){}
  @override
  TextTileState createState() => TextTileState(ident);
}

class TextTileState extends State<TextTile>
{
  TextTileState(this.ident){}
  var dtState = new DisplayTileState();
  String ident;// = 'AAA';
  String data = 'tescht';
  String unit;


  @override
  Widget build(BuildContext context)
  {
    var dataBase = Provider.of<DataBase>(context);

    if(dataBase.rawData[ident].length>0)
    data = dataBase.rawData[ident].last.data.toString();
    unit = allRequests[ident][6];
    return dtState.buildOuter(getDisplay());
  }


  dynamic getDisplay()
  {
    var row = [Text(
      data ?? 'null',
      style: TextStyle(
          inherit: false, fontSize: 180, color: Colors.black87),
    )];
    if(unit != null)
      {
        row.add(Text(unit,
            style: TextStyle(
                inherit: false, fontSize: 30, color: Colors.black)));
      }


    return Consumer<DataBase>(builder: (context,dataBase,child)=>
      FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
            alignment: Alignment.bottomCenter,
            child: Row(children: row))));
  }
}