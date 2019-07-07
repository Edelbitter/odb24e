

class DataBase
{
  List<DoubleData> batteryTemperatures;
  List<DoubleData> soC;

  DataBase(){}

  factory DataBase.withFakeData(){
    var db = new DataBase();
    db.batteryTemperatures = new List<DoubleData>();
    db.batteryTemperatures.add(new DoubleData(30, new DateTime(2019,1,1,0,0,0)));
    db.batteryTemperatures.add(new DoubleData(33, new DateTime(2019,1,1,0,15,0)));
    db.batteryTemperatures.add(new DoubleData(39, new DateTime(2019,1,1,0,30,0)));
    db.batteryTemperatures.add(new DoubleData(42, new DateTime(2019,1,1,0,45,0)));
    db.batteryTemperatures.add(new DoubleData(47, new DateTime(2019,1,1,1,0,0)));
    db.batteryTemperatures.add(new DoubleData(55, new DateTime(2019,1,1,1,15,0)));
    db.batteryTemperatures.add(new DoubleData(49, new DateTime(2019,1,1,1,30,0)));
    db.batteryTemperatures.add(new DoubleData(41, new DateTime(2019,1,1,1,45,0)));
    db.batteryTemperatures.add(new DoubleData(35, new DateTime(2019,1,1,2,0,0)));
    db.batteryTemperatures.add(new DoubleData(29, new DateTime(2019,1,1,2,15,0)));
    db.batteryTemperatures.add(new DoubleData(24, new DateTime(2019,1,1,2,30,0)));
    db.batteryTemperatures.add(new DoubleData(19, new DateTime(2019,1,1,2,45,0)));
    db.batteryTemperatures.add(new DoubleData(12, new DateTime(2019,1,1,3,0,0)));
    db.soC = new List<DoubleData>();
    db.soC.add(new DoubleData(90, new DateTime(2019,1,1,0,0,0)));
    db.soC.add(new DoubleData(70, new DateTime(2019,1,1,1,0,0)));
    db.soC.add(new DoubleData(40, new DateTime(2019,1,1,2,0,0)));
    return db;
  }
}

class DoubleData
{
  DoubleData(this.data,this.time){}
  double data;
  DateTime time;
}

