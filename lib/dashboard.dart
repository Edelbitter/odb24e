import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:math';

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
        child: Center(
          child:
            Column(
            children: <Widget>[
              Padding(
               padding: EdgeInsets.only(top:15),
              ),
            Expanded(child:
                Container(margin:EdgeInsets.only(left:20,right:20,top:20,bottom: 40),child:
              CustomPaint(
              painter: ShapesPainter(),
                child:
                Container(),
              ),
            ),
            ),
              Text('yo'),


          ],
          ),
        ),
      ),
    );


  }


}
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
    // set the color property of the paint
    ..color = Colors.white
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;


    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.width / 2);
   // var rect = const Offset(0, 0) & const Size(300, 250);
    var rect = Rect.fromLTWH(0, 0, size.width, size.width);
    // draw the circle on centre of canvas having radius 75.0
   // canvas.drawCircle(center, 175.0, paint);
    canvas.drawArc(rect,pi*7/8 , pi*10/8, false, paint);
    canvas.drawLine(Offset(11,11), center, paint);
    paint.strokeWidth=15;
    for(int i = 0;i<38;++i) {
      canvas.drawArc(rect, pi * 7 / 8 + pi*i/30, pi   / 200, false, paint);
    }

   // canvas.drawRect(rect, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}