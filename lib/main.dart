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

FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
var btConnection;
BluetoothDevice theDevice;
//DataBase dataBase = new DataBase.withFakeData();
String otherDisplay;
var capHelp;

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

  var rand = new Random();

  @override
  initState() {
    super.initState();
    capHelp = new CapHelp(context);
    capHelp.initBT(callback: () {
      setState(() {
        otherDisplay =
            theDevice == null ? 'no Bluetooth device selected' : theDevice.name;
      });
    });
    // initBt();
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void _connect() {
    capHelp.connect(() {
      setState(() {
        otherDisplay += ' connected';
      });
    });
  }

  void send() {
    new Timer(new Duration(milliseconds: 500), () {
      var nextIndex =
          allRequests.keys.toList()[rand.nextInt(allRequests.length)];
      print(nextIndex);
      print('sending');
      String nextData = '7EC03' +
          nextIndex +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          rand.nextInt(10).toString() +
          '>';
      print(nextData);
      capHelp.sendTestData(nextData);
      send();
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
          ),
          body: Container(
            child: Center(
              child: Column(
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      onFieldSubmitted: (res) {
                        userInput = res;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Dashboard"),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      child: Text("Battery Data"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/battery');
                      },
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                    VerticalDivider(),
                    RaisedButton(
                      child: Text("Driving Data"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/drive');
                      },
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                    VerticalDivider(),
                    RaisedButton(
                      child: Text("Consumption"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/consum');
                      },
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                  ]),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("Start Communication"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: _connect,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // splashColor: Colors.grey,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("send custom"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: (userInput != null)
                              ? () {
                                  capHelp.sendOut(userInput.trim());
                                }
                              : null,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("ready request list"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),

                          onPressed: capHelp.initList,
                          // color: Colors.red,
                          // textColor: Colors.yellow,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // splashColor: Colors.grey,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("send test data"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),

                          onPressed: send,
                          // color: Colors.red,
                          // textColor: Colors.yellow,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // splashColor: Colors.grey,
                        ),
                      ),
                      Text(
                        otherDisplay ?? "horst",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            //  onPressed: await  _getDisplay(),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Einstellungen',
            child: Icon(Icons.settings),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
