import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';



void main() => runApp(MyApp());

const String URI = "http://192.168.0.10:35000/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _otherDisplay = "init";

  // for connectivity
  var subscription;

  // for sockets
  List<String> toPrint = ["trying to conenct"];
  SocketIOManager manager;
  SocketIO socket;
  bool isProbablyConnected = false;

  @override
  initState() {
    super.initState();

    // subscribe to network changes
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      setState(()
      {
        this._otherDisplay = "loading";
      });

      if(result != null)
      setState(()
      {
        this._otherDisplay = result.toString();
      });
    });

    // start socket things
    manager = SocketIOManager();
    initSocket();

  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  // copied from example
  initSocket() async {
    setState(() => isProbablyConnected = true);
    socket = await manager.createInstance(
      //Socket IO server URI
        URI,
        //Query params - can be used for authentication
        query: {
          "auth": "--SOME AUTH STRING---",
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
      //  transports: [Transports.WEB_SOCKET, Transports.POLLING] //Enable required transport
    );
    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
//      socket.emit("message", ["Hello world!"]);
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.on("news", (data) {
      pprint("news");
      pprint(data);
    });
    socket.on(eventName, listener)
    socket.connect();
  }

// copied from example
  disconnect() async {
    await manager.clearInstance(socket);
    setState(() => isProbablyConnected = false);
  }


  pprint(data) {
    setState(() {
      if (data is Map) {
      //  data = json.encode(data);
      }
      print(data);
      toPrint.add(data);
    });
  }

void _getDisplaySync()
{
 // setState(()
 // {
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
      body: Center(
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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
               this._otherDisplay ?? "horst",
              style: Theme.of(context).textTheme.display1,


            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
      //  onPressed: await  _getDisplay(),
        onPressed: _getDisplaySync,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
