import 'package:flutter/material.dart';


class CirclePainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Circle

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(101, 163, 209, 207)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_1 = Path();
    path_1.moveTo(size.width*0.4734667,size.height*0.1145607);
    path_1.cubicTo(size.width*0.7483250,size.height*0.1145607,size.width*1.1475167,size.height*0.3619859,size.width*1.1475167,size.height*0.7224087);
    path_1.cubicTo(size.width*1.1698083,size.height*1.0759571,size.width*0.9439917,size.height*1.0106122,size.width*0.4486000,size.height*1.0022000);
    path_1.cubicTo(size.width*0.1698250,size.height*0.9832724,size.width*-0.2573917,size.height*1.1023286,size.width*-0.2267583,size.height*0.7224087);
    path_1.cubicTo(size.width*-0.2267583,size.height*0.5221762,size.width*-0.0075333,size.height*0.1145607,size.width*0.4734667,size.height*0.1145607);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);


    // Circle

    Paint paint_stroke_1 = Paint()
      ..color = const Color.fromARGB(75, 163, 209, 207)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_1, paint_stroke_1);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
