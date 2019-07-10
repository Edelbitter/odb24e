import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'main.dart';
import 'database.dart';

class CapHelp {
  static int initcount = 0;
  static void connect() {
    print(theDevice.connected);

    bluetooth.onStateChanged().listen((state) {
      print('state changed');
      print(state);
    });

    try {
      BluetoothConnection.toAddress(theDevice.address).then((connection) {
        print('Connected to the device');
        btConnection = connection;
        initcount = 1;
        var dur = new Duration(milliseconds: 800);
        var tt = new Timer(dur, () {
          print('timer start');
          sendOut('atz');
          new Timer(dur, () {
            sendOut('atsp6');
            new Timer(dur, () {
              sendOut('ate0');
              new Timer(dur, () {
                sendOut('ath1');
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

  static void sendOut(String toSend) {
    //ready = false;
    List<int> bytes = utf8.encode(toSend.trim() + '\r');
    // theSocket.add(bytes);
    btConnection.output.add(bytes);
    //bluetooth.writeBytes(bytes);
    //  print(toSend);
    // print('\n');
  }

  static void dataHandler(data) {
    // print(data);
    if (data != null) {
      String rec = (new String.fromCharCodes(data));
      // print('received:');
      //  print(rec);

      // setState(() {
      // if (rec.contains('>')) {
      //  ready = true;
//        switch(initcount)
//        {
//          case 1:{ sendOut('atstff'); print('initializing'); ++initcount; break;}
//          case 2:{ sendOut('atsp6'); ++initcount;break;}
//          case 3:{ sendOut('ath1'); ++initcount; break;}
//          case 4: {sendOut('ate0'); ++initcount; break;}
//          default: initcount=0;
//        }
      // }
      // setState((){});
      if (!otherDisplay.contains(">")) {
        otherDisplay += rec;
      } else {
        print(otherDisplay);

        List<String> recBytes = otherDisplay.trim().split(' ');
        print('split');
        print(recBytes);

        if (recBytes.length > 5 && recBytes[1] == '7EC')
        if(recBytes[2]=='62')
        {
          switch (recBytes[3]) {
            case '20':
              {
                switch (recBytes[4]) {
                  case '01':
                    {
                      print('found batt');
                      dataBase.batteryTemperatures.add(new DoubleData(
                          _convert1Hex(recBytes[5]).toDouble() - 40,
                          DateTime.now()));
                    }
                    break;
                }
              }
              break;
            case '22':
              {}
              break;
          }
        } else if (recBytes[2] == '61') {
          switch (recBytes[3]) {
            case '':
          }
        } else if (recBytes[3] == '7F') {} //
        //  });
        print(dataBase.batteryTemperatures);
        otherDisplay = rec;
      }
    }
  }

  static int _convert1Hex(String hex) {
    print(hex.length);
    List<int> integers;
    int result = 0;
    for (int i = 0; i < hex.length; ++i) {
      result += (_convertHexDigit(
              hex.substring(hex.length - 1 - i, hex.length  - i))) *
          pow(16, i);
    }
    return result;
  }

  static int _convertHexDigit(String hex) {
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
}
