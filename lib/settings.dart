import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

import 'dart:io';
import 'dart:convert';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettingsState createState() => SettingsState();
}


class SettingsState extends State<SettingsPage>
{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          automaticallyImplyLeading: true,
          leading: IconButton(
            icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context),
          ),
          title: Text('Einstellungen'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('images/gears.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[

              // Port
              Container(
                margin: EdgeInsets.only(top:15,right: 15),
                  child:
                Row(
                  children: <Widget>[
                  Center(child:
                    Container(
                      margin: EdgeInsets.only(left:15,right:20),
                      padding: EdgeInsets.only(bottom: 15),
                      child:
                      Text('IP Adresse '),
                  ),
                ),
                  new Expanded(
                    child:
                    TextField(
                      textDirection: TextDirection.rtl,
                      onSubmitted: (res){URIIP = res;},
                      maxLength: 15,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: 'Standard: 192.168.0.10'
                      ),
                    ),
                  ),
                  ],
                ),
              ),

              // IP
              Container(
                margin: EdgeInsets.only(top:15,right: 15),
                child:
                Row(
                  children: <Widget>[
                    Center(child:
                    Container(
                      margin: EdgeInsets.only(left:15,right:20),
                      padding: EdgeInsets.only(bottom: 15),
                      child:
                      Text('Port'),
                    ),
                    ),
                    new Expanded(
                      child:
                      TextField(
                        textDirection: TextDirection.rtl,
                        onSubmitted: (res){PORT = int.parse(res);},
                        maxLength: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          helperText: 'Standard: 35000'
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          ],
    ),
    ),
    );


  }


}