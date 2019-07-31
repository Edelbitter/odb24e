import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'settings.dart';
import 'dashboard.dart';
import 'dashboardLayout.dart';
import 'battery.dart';
import 'database.dart';
import 'connectionAndParsingHelpers.dart';
import 'driving.dart';
import 'consumption.dart';
import 'allRequests.dart';

void main() => runApp(ChangeNotifierProvider(
      builder: (context) => DataBase(),
      child: MyApp(),
    ));

////////// GLOBALS /////////////////

//DataBase dataBase = new DataBase.withFakeData();
String otherDisplay;

////////////////////////////////////

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zooommm',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'zooom OBDII'),
        '/settings': (context) => SettingsPage(),
        '/dashboard': (context) => DashboardPage(),
        '/dashboardLayout': (context) => DashboardLayoutPage(),
        '/layoutDetails': (context) => DashboardDetailsPage(),
        '/battery': (context) => BatteryPage(),
        '/drive': (context) => DrivingPage(),
        '/consum': (context) => ConsumptionPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userInput;
  var capHelp;
  int connected = 0;

  var rand = new Random();

  @override
  initState() {
    super.initState();
    capHelp = new CapHelp(context);
    capHelp.initBT(callback: () {
      setState(() {
        otherDisplay = capHelp.theDevice == null
            ? 'No Bluetooth Device Selected'
            : capHelp.theDevice.name;
      });
    });
    // initBt();
    //  var dataBase = Provider.of<DataBase>(context);
    //  if(dataBase==null)
    // dataBase.initRaw();
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void _connect() {
    capHelp.connect(() {
      setState(() {
        otherDisplay = capHelp.theDevice.name + ' connected';
        connected = 1;
      });
    }, () {
      setState(() {
        connected = 0;
        otherDisplay = capHelp.theDevice.name;
      });
    }, () {
      setState(() {
        connected = 2;
        otherDisplay = capHelp.theDevice.name + ' connecting...';
      });
    });
  }

//  void dataHandler(data) {
//    capHelp.dataHandler(Provider.of<DataBase>(context),data);
//  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('images/motorCroppedDark.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              connected == 1
                  ? Icon(
                      Icons.bluetooth_connected,
                      color: Colors.green,
                    )
                  : connected == 0
                      ? Icon(Icons.bluetooth_searching, color: Colors.red)
                      : Icon(
                          Icons.bluetooth_searching,
                          color: Colors.yellow,
                        ),
              VerticalDivider(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.bluetooth),
                        onPressed: () {},
                      ),
                      Text(otherDisplay ?? ''),
                      //  IconButton(icon: Icon(Icons.search), onPressed: () {},),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings',
                          arguments: capHelp);
                    },
                  ),
                  //    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                ]),
          ),

          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Center(
                child: Column(children: <Widget>[
              Divider(),
              Divider(),

//              Container(
//                child: TextFormField(
//                  textDirection: TextDirection.ltr,
//                  onFieldSubmitted: (res) {
//                    userInput = res;
//                  },
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(),
//                  ),
//                ),
//              ),
//                  RaisedButton(
//                    child: Text("Dashboard"),
//                    shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(10.0)),
//                    onPressed: () {
//                      Navigator.pushNamed(context, '/dashboard');
//                    },
//                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                  ),

              RaisedButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.battery_charging_full),
                  //  VerticalDivider(),
                  Text(' Battery Data')
                ]),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.pushNamed(context, '/battery');
                },
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              Divider(),
              RaisedButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.directions_car),
                  // VerticalDivider(),
                  Text(' Driving Data')
                ]),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.pushNamed(context, '/drive');
                },
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              Divider(),
              RaisedButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.ev_station),
                  // VerticalDivider(),
                  Text(' Consumption Data')
                ]),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  Navigator.pushNamed(context, '/consum');
                },
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),

//              Container(
//                margin: EdgeInsets.only(left: 15, right: 15),
//                child: RaisedButton(
//                  child: Text("send custom"),
//                  shape: new RoundedRectangleBorder(
//                      borderRadius: new BorderRadius.circular(10.0)),
//                  onPressed: (userInput != null)
//                      ? () {
//                          capHelp.sendOut(userInput.trim());
//
//                        }
//                      : null,
//                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                ),
//              ),
//                      Container(
//                        margin: EdgeInsets.only(left: 15, right: 15),
//                        child: RaisedButton(
//                          child: Text("ready request list"),
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(10.0)),
//
//                          onPressed: capHelp.initList,
//                          // color: Colors.red,
//                          // textColor: Colors.yellow,
//                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                          // splashColor: Colors.grey,
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(left: 15, right: 15),
//                        child: RaisedButton(
//                          child: Text("send startup commands"),
//                          shape: new RoundedRectangleBorder(
//                              borderRadius: new BorderRadius.circular(10.0)),
//
//                          onPressed: capHelp.sendStartupCommands,
//                          // color: Colors.red,
//                          // textColor: Colors.yellow,
//                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                          // splashColor: Colors.grey,
//                        ),
//                      ),
//                      Text(
//                        otherDisplay ?? "No Bluetooth Device Selected",
//                        style: Theme.of(context).textTheme.display1,
//                      ),

              new Expanded(
                child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  child: Icon(Icons.play_circle_outline),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  onPressed: _connect,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  // splashColor: Colors.grey,
                                ),
                                VerticalDivider(),
                                RaisedButton(
                                  child: Icon(Icons.accessible_forward),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  onPressed: capHelp.send,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  // splashColor: Colors.grey,
                                ),
                              ]),
                          Divider(),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                          RaisedButton(
                            child: Icon(Icons.clear),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            onPressed: () {
                              capHelp.stop = true;
                              var dataBase = Provider.of<DataBase>(context);
                              dataBase.clear();
                            },
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            // splashColor: Colors.grey,
                          ),
                            VerticalDivider(),
                            RaisedButton(
                              child: Icon(Icons.receipt),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0)),
                              onPressed: () {
                                capHelp.log();
                              },
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              // splashColor: Colors.grey,
                            ),
                          ]),
                          Divider(),
                        ])),
              ),
            ])),
          ),

          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
