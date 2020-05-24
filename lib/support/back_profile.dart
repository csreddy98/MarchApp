import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackProfile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromRGBO(63, 92, 200, 1);
    // color: Color.fromRGBO(63, 92, 200, 1),
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width, size.height*0.6, size.width, size.height * 0.58);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    /*path.lineTo(0, size.height - size.height / 5);
    path.lineTo(size.width / 1.2, size.height);
    path.lineTo(size.width, size.height - size.height / 5);
    path.lineTo(size.width, 0);*/
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}