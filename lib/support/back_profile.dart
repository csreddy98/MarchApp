import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackProfile extends CustomPainter {
  final cont;
  BackProfile(this.cont);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Theme.of(cont).disabledColor;
    // color: Color.fromRGBO(63, 92, 200, 1),
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width, size.height*0.63, size.width, size.height * 0.63);
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