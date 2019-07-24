import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:obd24e/pieChartTile.dart';

import 'allRequests.dart';

class DataBase extends ChangeNotifier {

  int bufferSize = 10;

Map<String,Queue<DoubleData>> rawData;
DataBase()
{
  initRaw();
}

void initRaw(){
  rawData = new Map<String,Queue<DoubleData>>();

  for(var key in allRequests.keys){
    rawData[key]= new Queue<DoubleData>();
  }


//  rawData ={
//    // battery temperature
//    '622001':  new Queue<DoubleData>(),
//    // SoC
//    '622002':new Queue<DoubleData>(),
//    '622003':new Queue<DoubleData>(),
//    // distance
//    '622006':new Queue<DoubleData>(),
//    '62200E':new Queue<DoubleData>(),
//    '622051':new Queue<DoubleData>(),
//    '623307':new Queue<DoubleData>(),
//    '6234CF':new Queue<DoubleData>(),
//    '623478':new Queue<DoubleData>(),
//    '623459':new Queue<DoubleData>(),
//    '623457':new Queue<DoubleData>(),
//    '623456':new Queue<DoubleData>(),
//    '623455':new Queue<DoubleData>(),
//    '623454':new Queue<DoubleData>(),
//    '623454':new Queue<DoubleData>(),
//    '623451':new Queue<DoubleData>(),
//    '623458':new Queue<DoubleData>(),
//    '6233A7':new Queue<DoubleData>(),
//    '623414':new Queue<DoubleData>(),
//    // SoH
//    '623206': new Queue<DoubleData>(),
//    // voltage?
//    '622004': new Queue<DoubleData>(),
//    // voltage?
//    '623203':new Queue<DoubleData>(),
//    // current?
//    '623204':new Queue<DoubleData>(),
//    // torque?
//    '622243': new Queue<DoubleData>(),
//    // power available for climate
//    '6234C8': new Queue<DoubleData>(),
//    // DCDC On/off
//    '623022': new Queue<DoubleData>(),
//    // 14V
//    '622005': new Queue<DoubleData>(),
//  };
}


  List<DoubleData> batteryTemperatures = new List<DoubleData>();
  List<DoubleData> soC = new List<DoubleData>();

  List<DoubleData> consumAirCon;// = rawData['2233A7'].toList();
  //List<DoubleData> consumDrive = new List<DoubleData>();
 // List<DoubleData> consumHeat = new List<DoubleData>();
  List<DoubleData> consum12V = new List<DoubleData>();

  double getConsumption()
  {
    if(rawData['623204'].length>0 && rawData['623203'].length>0)
      return -1 * rawData['623204'].last.data * rawData['623203'].last.data / 1000;
    return 0;
  }

  List<ComboDataPiece> getCombo() {
    var comboData = new List<ComboDataPiece>();
    consumAirCon = rawData['6233A7'].toList();
    double consumDrive = getConsumption()> 0 ? (getConsumption()-consumAirCon.last.data > 0 ? getConsumption()-consumAirCon.last.data :0) : 0;

  //  if (consumHeat.length > 0)
  //    comboData.add(new ComboDataPiece('AC', consumHeat.last.data ?? 0));
 //   else
 //     comboData.add(new ComboDataPiece('AC', 111));
    if (consumAirCon.length > 0)
      comboData.add(new ComboDataPiece('AC', consumAirCon.last.data ?? 0));
    else
      comboData.add(new ComboDataPiece('AC', 0));
   // if (consum12V.length > 0)
   //   comboData.add(new ComboDataPiece('Heat', consum12V.last.data ?? 0));
   // else
   //   comboData.add(new ComboDataPiece('Heat', 111));
   // if (consumDrive.length > 0)
      comboData.add(new ComboDataPiece('Drive', consumDrive));
   // else
    //  comboData.add(new ComboDataPiece('Drive', 0));

    return comboData;
  }

//  DataBase() ;

  void add(String ident,DoubleData data)
  {

    rawData[ident].add(data);
    if(rawData[ident].length>bufferSize)
      rawData[ident].removeFirst();
    //print(rawData[ident].map((ff) => ff.data));
    notifyListeners();
  }

  void clear(){

    initRaw();

    notifyListeners();
  }

//  factory DataBase.withFakeData() {
//    var db = new DataBase();
//    db.batteryTemperatures = new List<DoubleData>();
////    db.batteryTemperatures.add(new DoubleData(30, new DateTime(2019,1,1,0,0,0)));
////    db.batteryTemperatures.add(new DoubleData(33, new DateTime(2019,1,1,0,15,0)));
////    db.batteryTemperatures.add(new DoubleData(39, new DateTime(2019,1,1,0,30,0)));
////    db.batteryTemperatures.add(new DoubleData(42, new DateTime(2019,1,1,0,45,0)));
////    db.batteryTemperatures.add(new DoubleData(47, new DateTime(2019,1,1,1,0,0)));
////    db.batteryTemperatures.add(new DoubleData(55, new DateTime(2019,1,1,1,15,0)));
////    db.batteryTemperatures.add(new DoubleData(49, new DateTime(2019,1,1,1,30,0)));
////    db.batteryTemperatures.add(new DoubleData(41, new DateTime(2019,1,1,1,45,0)));
////    db.batteryTemperatures.add(new DoubleData(35, new DateTime(2019,1,1,2,0,0)));
////    db.batteryTemperatures.add(new DoubleData(29, new DateTime(2019,1,1,2,15,0)));
////    db.batteryTemperatures.add(new DoubleData(24, new DateTime(2019,1,1,2,30,0)));
////    db.batteryTemperatures.add(new DoubleData(19, new DateTime(2019,1,1,2,45,0)));
////    db.batteryTemperatures.add(new DoubleData(12, new DateTime(2019,1,1,3,0,0)));
//    db.soC = new List<DoubleData>();
//    db.soC.add(new DoubleData(90, new DateTime(2019, 1, 1, 0, 0, 0)));
//    db.soC.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
//    db.soC.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
//    db.consum12V = new List<DoubleData>();
//    db.consumAirCon = new List<DoubleData>();
//
//    db.consumDrive = new List<DoubleData>();
//    db.consum12V.add(new DoubleData(40, new DateTime(2019, 1, 1, 0, 0, 0)));
//    db.consum12V.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
//    db.consum12V.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
//    db.consumAirCon.add(new DoubleData(110, new DateTime(2019, 1, 1, 0, 0, 0)));
//    db.consumAirCon.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
//    db.consumAirCon.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
//
//    db.consumDrive.add(new DoubleData(300, new DateTime(2019, 1, 1, 0, 0, 0)));
//    db.consumDrive.add(new DoubleData(70, new DateTime(2019, 1, 1, 1, 0, 0)));
//    db.consumDrive.add(new DoubleData(40, new DateTime(2019, 1, 1, 2, 0, 0)));
//    return db;
//  }
}

class DoubleData {
  DoubleData(this.data, this.time) {}
  double data;
  DateTime time;
}
