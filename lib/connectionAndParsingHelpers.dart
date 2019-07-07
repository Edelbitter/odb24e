import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'main.dart';
import 'database.dart';

class CapHelp {
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

        // initialize ELM327
        sendOut('atz');
        sendOut('atsp6');
        sendOut('ate0');
        sendOut('ath1');

        connection.input.listen(dataHandler, onError: (err) {
          print('cannot connect');
          print(err.toString());
        }).onDone(() {
          print('Disconnected by remote request');
        });
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  static void sendOut(String toSend) {
    //ready = false;
    List<int> bytes = utf8.encode(toSend);
    // theSocket.add(bytes);
    btConnection.output.add(bytes);
    //bluetooth.writeBytes(bytes);
    print(toSend);
    print('\n');
  }

  static void dataHandler(data) {
    // print(data);
    if (data != null) {
      String rec = (new String.fromCharCodes(data));
      print(rec);

      // setState(() {
      if (rec.contains('>')) {
        //  ready = true;
      }
//        if (_otherDisplay.contains(">")) {
//          _otherDisplay = "received \n" + rec;
//        } else {
//          _otherDisplay += rec;
//        }

      List<String> recBytes = rec.split(' ');

      if (recBytes[2] == '62') {
        switch (recBytes[3]) {
          case '20':
            {
              switch (recBytes[3]) {
                case '01':
                  {
                    dataBase.batteryTemperatures.add(new DoubleData(
                        _convert1Hex(recBytes[4]).toDouble() - 40,
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
    }
  }

  static int _convert1Hex(String hex) {
    List<int> integers;
    int result = 0;
    for (int i = 0; i < hex.length; ++i) {
      result += (_convertHexDigit(
              hex.substring(hex.length - 1 - i, hex.length - 1 - i))) *
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
