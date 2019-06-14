import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';


import 'dart:io';
import 'dart:convert';
import 'main.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DashboardState createState() => DashboardState();
}


class DashboardState extends State<DashboardPage>
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
        title: Text('Dashboard'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('images/dashboard.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
            CustomPaint(
              painter: ShapesPainter(),
              child: Text('yo')
            )



          ],
        ),
      ),
    );


  }


}
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return null;
  }
}