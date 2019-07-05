import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'settings.dart';
import 'dashboard.dart';
import 'dashboardLayout.dart';
import 'battery.dart';
import 'database.dart';

void main() => runApp(MyApp());

String URIIP = '192.168.0.10';
int PORT = 35000;
FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
BluetoothDevice theDevice;
DataBase dataBase = new DataBase();

//const String URI = "http://192.168.0.10:35000/";

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
      },
      //  home: MyHomePage(title: 'zooom OBDII'),
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
  String _counter = "";
  String _otherDisplay = "^_^";

  // for connectivity
  var subscription;
  var theSocket;
  String network = "";
  // for sockets

  bool ready = false;

  String speed = '';
  String gasPedal = '';
  String gear = '';

  String userInput;
 // FlutterBlue bTooth = FlutterBlue.instance;

  var device;
  bool btReady = false;
  var btConnection;

  @override
  initState() {
    super.initState();
    ready = true;
    // subscribe to network changes
    if (false)
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        // Got a new connectivity status!
        if (result != null) {
          if (result == ConnectivityResult.mobile)
            this.network = 'mobile';
          else if (result == ConnectivityResult.wifi)
            this.network = 'wifi';
          else
            this.network = 'none';
        }
        setState(() {
          //  this._otherDisplay = result.toString();
        });
      });

    /// Start scanning
    ///
  }

  void dataHandler(data) {
    // print(data);
    if (data != null) {
      String rec = (new String.fromCharCodes(data));
      print(rec);

      setState(() {
        if (rec.contains('>')) {
          ready = true;
        }
        if (_otherDisplay.contains(">")) {
          _otherDisplay = "received \n" + rec;
        } else {
          _otherDisplay += rec;
        }

        List<String> recBytes = rec.split(' ');

        if(recBytes[2] == '62') {
          switch (recBytes[3]) {
            case '20':
              {
                switch(recBytes[3] )
                {
                  case '01':
                    {
                      dataBase.batteryTemperatures.add(new DoubleData(_convert1Hex(recBytes[4]).toDouble()-40, DateTime.now()));
                    }
                    break;
                }
              }
              break;
            case '22':
              {

              }
              break;

          }
        }
        else if(recBytes[2] == '61'){
          switch (recBytes[3]) {
            case '':
          }
        }
        // ???
        else if(recBytes[3] == '7F'){}

//      if(rec.startsWith('41'))
//        {
//          if(rec.startsWith('5A',3))
//            {
//              gasPedal = (int.parse( rec.substring(5,6)) * 100 / 255).toString();
//            }
//          if(rec.startsWith('0D',3))
//          {
//            speed =  rec.substring(5,6);
//          }
//          if(rec.startsWith('5A',3))
//          {
//            gear =  rec.substring(5);
//          }
//        }
      });
    }
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    theSocket.destroy();
  }

  void _connect() {

          setState(() {
            ready = true;
            print(theDevice.connected);

            bluetooth.onStateChanged().listen((state) {
              print('state changed');
              print(state);
            });
            btReady = true;
            // Some simplest connection :F
            try {
              BluetoothConnection.toAddress(theDevice.address).then((connection) {
                print('Connected to the device');
                btConnection = connection;
                _otherDisplay = 'connected';

                _sendOut('atz');
                _sendOut('atsp6');
                _sendOut('ate0');
                _sendOut('ath1');


                connection.input.listen(dataHandler, onError: (err) {
                  print('cannot connect');
                  print(err.toString());
                }
//                        (Uint8List data) {
//                  print('Data incoming: ${ascii.decode(data)}');
//                  connection.output.add(data); // Sending data
//
//                  if (ascii.decode(data).contains('!')) {
//                    connection.finish(); // Closing connection
//                    print('Disconnecting by local host');
//                  }
//                }
                    ).onDone(() {
                  print('Disconnected by remote request');
                });
              });
            } catch (exception) {
              print('Cannot connect, exception occured');
            }

            //bluetooth.write(message)
          });

      //}
   // });
    //var scanSubscription = bTooth.state;
    //print(scanSubscription);


//      String uri = URIIP.length > 3 ? URIIP : '192.168.0.10';
//      int port = PORT == 0 ? 35000 : PORT;
//      Socket.connect(uri, port).then((socket) {
//        //socket.write('Hello, World!');
//        theSocket = socket;
//        theSocket.listen(dataHandler,
//            onError: errorHandler, onDone: doneHandler);
//        setState(() {
//          _otherDisplay = "connected";
//          ready = true;
//          print('connected');
//          _sendOut('AT E0\r');
//        });
//      });

  }

  int _convert1Hex(String hex)
  {
    List<int> integers;
    int result = 0;
    for(int i = 0;i<hex.length; ++i)
      {
        result += (_convertHexDigit( hex.substring(hex.length - 1 - i,hex.length - 1 -i))) * pow(16,i);
      }
    return result;
  }

  int _convertHexDigit(String hex)
  {
    switch(hex){
      case '0': return 0;
      case '1': return 1;
      case '2': return 2;
      case '3': return 3;
      case '4': return 4;
      case '5': return 5;
      case '6': return 6;
      case '7': return 7;
      case '8': return 8;
      case '9': return 9;
      case 'A': return 10;
      case 'B': return 11;
      case 'C': return 12;
      case 'D': return 13;
      case 'E': return 14;
      case 'F': return 5;
    }
  }



// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  // copied from example

  void _sendOut(String toSend) {
    //ready = false;
    List<int> bytes = utf8.encode(toSend);
    // theSocket.add(bytes);
    btConnection.output.add(bytes);
    //bluetooth.writeBytes(bytes);
    print(toSend);
    print('\n');
  }


  // setState(()
  // {
  void _otherFunc() {
    this._counter = "loading...";
    Connectivity().checkConnectivity().then((res) {
      if (res == ConnectivityResult.mobile) {
        setState(() {
          this._counter = "mobile";
        });
      } else if (res == ConnectivityResult.wifi) {
        this._counter = "wifi with SSID ";
        Connectivity().getWifiName().then((name) {
          this._counter += name + " and IP ";
          Connectivity().getWifiIP().then((ip) {
            setState(() {
              this._counter += ip;
            });
          });
        });
      }
    });
    //});
  }

  Future<void> _getDisplay() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      this._counter = "mobil";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      this._counter = "wifi";
    } else {
      this._counter = "nothing?";
    }
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
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Dashboard"),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  RaisedButton(
                    child: Text("Batteriedaten"),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/battery');
                    },
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  Text(
                    this._otherDisplay ?? "horst",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("Kommunikation starten"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: _connect,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // splashColor: Colors.grey,
                        ),
                      ),
                      Text(
                        this.network == 'wifi'
                            ? ''
                            : 'Der OBDII-Stecker ist nicht verbunden',
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: RaisedButton(
                          child: Text("send custom"),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),

                          onPressed: (btReady == true && userInput != null)
                              ? () {
                                  _sendOut(userInput.trim() + '\r');
                                }
                              : null,
                          // color: Colors.red,
                          // textColor: Colors.yellow,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // splashColor: Colors.grey,
                        ),
                      ),
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
