import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:io';
import 'dart:convert';

import 'settings.dart';
import 'dashboard.dart';
import 'dashboardLayout.dart';

void main() => runApp(MyApp());

String URIIP = '192.168.0.10';
int PORT = 35000;

//const String URI = "http://192.168.0.10:35000/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zooommm',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.black87,
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
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
      },
      //  home: MyHomePage(title: 'zooom OBDII'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  FlutterBlue bTooth = FlutterBlue.instance;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
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
      String rec2 = ascii.decode(data);
      // print('------------------');
      //print(rec2);

      setState(() {
        if (rec.contains('>')) {
          ready = true;
        }
        if (_otherDisplay.contains(">")) {
          _otherDisplay = "received \n" + rec;
        } else {
          _otherDisplay += rec;
        }
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
    bluetooth.getBondedDevices().then((dev) {
      print('the devices');
      for (var d in dev) {
        print(d.name);
        //if(d.name == 'UniCarScan')
        if (d.name == 'UniCarScan') {
          device = d;
          setState(() {
            _otherDisplay = "UniCar gefunden";
            ready = true;

            print('unicar gefunden');
            print(d.connected);

            bluetooth.onStateChanged().listen((state) {
              print('state changed');
              print(state);
            });
            btReady = true;
            // Some simplest connection :F
            try {
              BluetoothConnection.toAddress(d.address).then((connection) {
                print('Connected to the device');
                btConnection = connection;

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
        }
      }
    });
    //var scanSubscription = bTooth.state;
    //print(scanSubscription);

    if (false) {
      String uri = URIIP.length > 3 ? URIIP : '192.168.0.10';
      int port = PORT == 0 ? 35000 : PORT;
      Socket.connect(uri, port).then((socket) {
        //socket.write('Hello, World!');
        theSocket = socket;
        theSocket.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler);
        setState(() {
          _otherDisplay = "connected";
          ready = true;
          print('connected');
          _sendOut('AT E0\r');
        });
      });
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

  void _send1() {
    _sendOut('01 05\r');
  }

  void _send2() {
    _sendOut('01 07\r');
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Container(
            //decoration: BoxDecoration(
            // image: DecorationImage(
            //    image: ExactAssetImage('images/motorCroppedDark.png'),
            //   fit: BoxFit.fill,
            // ),
            // ),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Dashboard"),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),

                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    // color: Colors.red,
                    // textColor: Colors.yellow,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // splashColor: Colors.grey,
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
                          // color: Colors.red,
                          // textColor: Colors.yellow,
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
