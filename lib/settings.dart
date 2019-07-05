import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


import 'dart:io';
import 'dart:convert';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {

  List<BluetoothDevice> bondedDevices = [];


  @override
  initState() {
    bluetooth.getBondedDevices().then((dev) {
      setState(() {
        bondedDevices = dev;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('images/gears.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Einstellungen'),
        ),
        body: Container(
          // decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: ExactAssetImage('images/gears.jpg'),
          //   fit: BoxFit.cover,
//
          //    ),
          //  ),
          child: Column(
            children: <Widget>[
              // Port
              Container(
                margin: EdgeInsets.only(top: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text('IP Adresse '),
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        initialValue: '192.168.0.10',
                        textDirection: TextDirection.rtl,
                        onFieldSubmitted: (res) {
                          URIIP = res;
                        },
                        maxLength: 15,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: 'Standard: 192.168.0.10'),
                      ),
                    ),
                  ],
                ),
              ),

              // IP
              Container(
                margin: EdgeInsets.only(top: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text('Port'),
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        initialValue: '35000',
                        textDirection: TextDirection.rtl,
                        onFieldSubmitted: (res) {
                          PORT = int.parse(res);
                        },
                        maxLength: 5,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: 'Standard: 35000'),
                      ),
                    ),
                  ],
                ),
              ),
              DropdownButton<BluetoothDevice>(
                value: theDevice,
                onChanged: (BluetoothDevice newValue) {
                  setState(() {
                    theDevice = newValue;
                  });
                },
                items: bondedDevices
                    .map<DropdownMenuItem<BluetoothDevice>>((BluetoothDevice value) {
                  return DropdownMenuItem<BluetoothDevice>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
