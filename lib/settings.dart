import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  var bonded;


  @override
  initState() {

  setState(() {
    bonded = capHelp.bondedDevices;
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
                decoration: new BoxDecoration(border: Border.all(color: Colors.white)),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 20,top:15),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text('Bluetooth Device:'),
                      ),
                    ),
                    DropdownButton<BluetoothDevice>(
                      value: theDevice ,
                      hint: Text('select a device'),
                      onChanged: (BluetoothDevice newValue) {
                        setState(() {
                          theDevice = newValue;
                          otherDisplay = theDevice.name + ' *new';
                          capHelp.prefs.setString('btDevice',theDevice.name);
                        });
                      },
                      items: capHelp.bondedDevices
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

              // IP


            ],
          ),
        ),
      ),
    );
  }
}
