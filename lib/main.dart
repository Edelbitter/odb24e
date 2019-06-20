import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

import 'dart:io';
import 'dart:convert';

import 'settings.dart';
import 'dashboard.dart';


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
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'zooom OBDII'),
        '/settings': (context) => SettingsPage(),
        '/dashboard':(context) => DashboardPage(),
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
  String network ="";
  // for sockets

  bool ready = false;


  @override
  initState() {
    super.initState();
  ready = true;
    // subscribe to network changes
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if(result != null)
        {
          if(result == ConnectivityResult.mobile)this.network = 'mobile';
          else if(result == ConnectivityResult.wifi) this.network = 'wifi';
          else this.network = 'none';
        }
      setState(()
      {
      //  this._otherDisplay = result.toString();
      });
    });



  }
  void dataHandler(data){
   // print(data);
    String rec= (new String.fromCharCodes(data).trim());
    print(rec);

    setState(()
    {
      _otherDisplay = "received \n" + rec;
    });
    if(rec.contains('>'))
    {
      ready = true;
    }
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    theSocket.destroy();
  }

  void _connect()
  {
    String uri = URIIP.length>3 ? URIIP : '192.168.0.10';
    int port = PORT == 0 ? 35000 : PORT;
    Socket.connect(uri, port).then((socket) {
      //socket.write('Hello, World!');
      theSocket = socket;
      theSocket.listen(dataHandler,onError: errorHandler,onDone:doneHandler);
      setState(()
      {
        _otherDisplay = "connected";
        ready=true;
        print('connected');
      });
    });
  }
// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  // copied from example




void _send1() {
  //theSocket.write('hello server<EOF>');
  ready = false;
  print('sending');
  String foo = '01 05\r';
  List<int> bytes = utf8.encode(foo);
  theSocket.add(bytes);
 // print('button pressed');
 // print(theSocket.port.toString());
}

  void _send2() {
    ready = false;
    //theSocket.write('hello server<EOF>');
    String foo = '01 07\r';
    List<int> bytes = utf8.encode(foo);
    theSocket.add(bytes);
    // print('button pressed');
    // print(theSocket.port.toString());
  }

 // setState(()
 // {
  void _otherFunc()
  {
    this._counter=
    "loading...";
    Connectivity().checkConnectivity().then((res)
    {
      if(res == ConnectivityResult.mobile)
        {
          setState(()
          {
            this._counter= "mobile";
          });
        }

      else if(res == ConnectivityResult.wifi)
        {
          this._counter = "wifi with SSID ";
          Connectivity().getWifiName().then((name)
          {
            this._counter += name + " and IP ";
            Connectivity().getWifiIP().then((ip)
            {
              setState(()
              {
                this._counter += ip;
              });
            });
          });
        }
    });
  //});
}

  Future<void> _getDisplay()  async
  {

    var connectivityResult = await  Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      this._counter = "mobil";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
     this._counter = "wifi";
    }
    else{
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('images/motorCroppedDark.png'),
          fit: BoxFit.fill,
      ),
      ),
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
              child:  Text("Dashboard"),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

              onPressed: (){Navigator.pushNamed( context, '/dashboard');},
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
                  margin: EdgeInsets.only(left:15,right: 15),
                  child:   RaisedButton(
                    child:  Text("Kommunikation starten"),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

                  onPressed: (this.network == 'wifi') ? _connect : null,
                 // color: Colors.red,
                 // textColor: Colors.yellow,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                 // splashColor: Colors.grey,
                ),
                ),
                Text(
                  this.network == 'wifi' ? '' : 'Der OBDII-Stecker ist nicht verbunden',

                ),
                Container(
                  margin: EdgeInsets.only(left:15,right: 15),
                  child:   RaisedButton(
                    child:  Text("send 1"),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

                    onPressed: (this.network == 'wifi' && ready==true) ? _send1 : null,
                    // color: Colors.red,
                    // textColor: Colors.yellow,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // splashColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:15,right: 15),
                  child:   RaisedButton(
                    child:  Text("send 2"),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

                    onPressed: (this.network == 'wifi' && ready==true) ? _send2 : null,
                    // color: Colors.red,
                    // textColor: Colors.yellow,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // splashColor: Colors.grey,
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
        onPressed: (){
          Navigator.pushNamed( context, '/settings');
        },
        tooltip: 'Einstellungen',
        child: Icon(Icons.settings),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
