import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'main.dart';
import 'database.dart';
import 'allRequests.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'settings.dart';
import 'dashboard.dart';
import 'dashboardLayout.dart';
import 'battery.dart';
import 'database.dart';
import 'connectionAndParsingHelpers.dart';
import 'driving.dart';
import 'consumption.dart';

class CapHelp {
  CapHelp(this.theContext);

  int initcount = 0;
  Function dataUpdated;
  BuildContext theContext;
  bool ready = true;
  String recData = '';

  void connect(Function callback) {
    print(theDevice.connected);

    bluetooth.onStateChanged().listen((state) {
      print('state changed');
      print(state);
    });

    try {
      BluetoothConnection.toAddress(theDevice.address).then((connection) {
        print('Connected to the device');
        callback();
        btConnection = connection;
        initcount = 1;
        var dur = new Duration(milliseconds: 800);
        var tt = new Timer(dur, () {
          print('timer start');
          sendOut('atz'); // reset ELM327
          new Timer(dur, () {
            sendOut('atsp6'); // set to protocol 6 (11 bit CAN with 500 kbit)
            new Timer(dur, () {
              sendOut('ate0'); // echo off
              new Timer(dur, () {
                sendOut('ath1'); // headers on
                new Timer(dur, () {
                  sendOut('ats0'); // spaces off
                  new Timer(dur, startRequests);
                });
              });
            });
          });
        });

        connection.input.listen(dataHandler, onError: (err) {
          print('cannot connect');
          print(err.toString());
        }).onDone(() {
          print('Disconnected by remote request');
        });
        // sendOut('atz');
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  void sendOut(String toSend) {
    //ready = false;
    List<int> bytes = utf8.encode(toSend.trim() + '\r');
    // theSocket.add(bytes);
    btConnection.output.add(bytes);
    //bluetooth.writeBytes(bytes);
    //  print(toSend);
    // print('\n');
  }

  void startRequests() {
    var dur = new Duration(milliseconds: 300);
    for (int i = 0; i < allRequests.length; ++i) {
      if (ready) {
        ready = false;
        new Timer(dur, () => sendOut(allRequests[i][7]));
      } else {
        --i;
      }
    }
  }

  void dataHandler(data) {
     print(data);
    if (data != null) {
      String rec = (new String.fromCharCodes(data));

      if (rec.contains('>')) ready = true;

      if (!recData.contains(">")) {
        recData += rec.trim();
      } else {
        print(recData);

        if (recData.length > 5 &&
            recData.substring(0, 3) ==
                '7EC') if (recData.substring(5, 7) == '7F')
          return;
        else if (recData.substring(5, 7) == '62') {
          parseReceived(recData.substring(5, 11), recData);
        }
        recData = rec.trim();
      }
    }
  }

  void parseReceived(String ident, String rec) {
    var dataBase = Provider.of<DataBase>(theContext);
    var def = allRequests[ident];
    int from = (int.parse(def[1]) ~/ 8)+8;
    int to = ((int.parse(def[2]) + 1) ~/ 8)+8;

    var valueString = rec.substring(from, to+1);
    double value = _convert1Hex(valueString).toDouble();
    print(value);
    value = value * double.parse(def[3]);
    value = value - double.parse(def[4]);

    dataBase.add(ident,new DoubleData(value, DateTime.now()));
    //dataBase.notifyListeners();
  }

  int _convert1Hex(String hex) {
    print(hex);
    List<int> integers;
    int result = 0;
    for (int i = 0; i < hex.length; ++i) {
      result += (_convertHexDigit(
              hex.substring(hex.length - 1 - i, hex.length - i))) *
          pow(16, i);
    }
    return result;
  }

  int _convertHexDigit(String hex) {
    switch (hex) {
      case '0':
        return 0;
      case '1':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      case '6':
        return 6;
      case '7':
        return 7;
      case '8':
        return 8;
      case '9':
        return 9;
      case 'A':
        return 10;
      case 'B':
        return 11;
      case 'C':
        return 12;
      case 'D':
        return 13;
      case 'E':
        return 14;
      case 'F':
        return 5;
    }
  }

  sendTestData(String testData)
  {
    dataHandler(utf8.encode(testData));
  }
}
