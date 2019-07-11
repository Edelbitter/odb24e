import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:obd24e/pieChartTile.dart';

class DataBase extends ChangeNotifier {

Map<String,List<DoubleData>> rawData ={
  // battery temperature
'622001':  new List<DoubleData>(),
  // SoC
'622002':new List<DoubleData>(),
'622003':new List<DoubleData>(),
'622006':new List<DoubleData>(),
'62200E':new List<DoubleData>(),
'622051':new List<DoubleData>(),
'623307':new List<DoubleData>(),
'6234CF':new List<DoubleData>(),
'623478':new List<DoubleData>(),
'623459':new List<DoubleData>(),
'623457':new List<DoubleData>(),
'623456':new List<DoubleData>(),
'623455':new List<DoubleData>(),
'623454':new List<DoubleData>(),
'623454':new List<DoubleData>(),
'623451':new List<DoubleData>(),
'623458':new List<DoubleData>(),
'6233A7':new List<DoubleData>(),
'623414':new List<DoubleData>(),
};
  List<DoubleData> batteryTemperatures = new List<DoubleData>();
  List<DoubleData> soC = new List<DoubleData>();

  List<DoubleData> consumAirCon = new List<DoubleData>();
  List<DoubleData> consumDrive = new List<DoubleData>();
  List<DoubleData> consumHeat = new List<DoubleData>();
  List<DoubleData> consum12V = new List<DoubleData>();

  List<ComboDataPiece> getCombo() {
    var comboData = new List<ComboDataPiece>();

    if (consumHeat.length > 0)
      comboData.add(new ComboDataPiece('AC', consumHeat.last.data ?? 0));
    if (consumAirCon.length > 0)
      comboData.add(new ComboDataPiece('12V', consumAirCon.last.data ?? 0));
    if (consum12V.length > 0)
      comboData.add(new ComboDataPiece('Heat', consum12V.last.data ?? 0));
    if (consumDrive.length > 0)
      comboData.add(new ComboDataPiece('Drive', consumDrive.last.data ?? 0));
  }

  DataBase() ;

  void add(String ident,DoubleData data)
  {

    rawData[ident].add(data);
    //print(rawData[ident].map((ff) => ff.data));
    notifyListeners();
  }

  factory DataBase.withFakeData() {
    var db = new DataBase();
    db.batteryTemperatures = new List<DoubleData>();
//    db.batteryTemperatures.add(new DoubleData(30, new DateTime(2019,1,1,0,0,0)));
//    db.batteryTemperatures.add(new DoubleData(33, new DateTime(2019,1,1,0,15,0)));
//    db.batteryTemperatures.add(new DoubleData(39, new DateTime(2019,1,1,0,30,0)));
//    db.batteryTemperatures.add(new DoubleData(42, new DateTime(2019,1,1,0,45,0)));
//    db.batteryTemperatures.add(new DoubleData(47, new DateTime(2019,1,1,1,0,0)));
//    db.batteryTemperatures.add(new DoubleData(55, new DateTime(2019,1,1,1,15,0)));
//    db.batteryTemperatures.add(new DoubleData(49, new DateTime(2019,1,1,1,30,0)));
//    db.batteryTemperatures.add(new DoubleData(41, new DateTime(2019,1,1,1,45,0)));
//    db.batteryTemperatures.add(new DoubleData(35, new DateTime(2019,1,1,2,0,0)));
//    db.batteryTemperatures.add(new DoubleData(29, new DateTime(2019,1,1,2,15,0)));
//    db.batteryTemperatures.add(new DoubleData(24, new DateTime(2019,1,1,2,30,0)));
//    db.batteryTemperatures.add(new DoubleData(19, new DateTime(2019,1,1,2,45,0)));
//    db.batteryTemperatures.add(new DoubleData(12, new DateTime(2019,1,1,3,0,0)));
    db.soC = new List<DoubleData>();
    db.soC.add(new DoubleData(90, new DateTime(2019, 1, 1, 0, 0, 0)));
    db.soC.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
    db.soC.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
    db.consum12V = new List<DoubleData>();
    db.consumAirCon = new List<DoubleData>();
    db.consumHeat = new List<DoubleData>();
    db.consumDrive = new List<DoubleData>();
    db.consum12V.add(new DoubleData(40, new DateTime(2019, 1, 1, 0, 0, 0)));
    db.consum12V.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
    db.consum12V.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
    db.consumAirCon.add(new DoubleData(110, new DateTime(2019, 1, 1, 0, 0, 0)));
    db.consumAirCon.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
    db.consumAirCon.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
    db.consumHeat.add(new DoubleData(20, new DateTime(2019, 1, 1, 0, 0, 0)));
    db.consumHeat.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
    db.consumHeat.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
    db.consumDrive.add(new DoubleData(300, new DateTime(2019, 1, 1, 0, 0, 0)));
    db.consumDrive.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
    db.consumDrive.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
    return db;
  }
}

class DoubleData {
  DoubleData(this.data, this.time) {}
  double data;
  DateTime time;
}
