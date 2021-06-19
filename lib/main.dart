import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: CustomCircularProgress(value: 5.6),
        ),
      ),
    );
  }
}

class CustomCircularProgress extends StatelessWidget {
  final double radius;
  final double value;

  const CustomCircularProgress({
    Key? key,
    this.radius = 40,
    this.value = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * radius,
      height: 2 * radius,
      child: CustomPaint(
        painter: CustomCircularProgressPainter(
          radius: radius,
          selectedValue: value,
          totalValue: 10,
          dividerThickness: 2,
          thickness: 8,
          primaryColor: Colors.green,
          dividerColor: Colors.white,
        ),
      ),
    );
  }
}

class CustomCircularProgressPainter extends CustomPainter {
  final double radius;
  final int totalValue;
  final double selectedValue;
  final double thickness;
  final double dividerThickness;
  final Color primaryColor;
  final Color dividerColor;
  final TextStyle? textStyle;

  CustomCircularProgressPainter({
    this.textStyle,
    this.primaryColor = Colors.green,
    this.dividerColor = Colors.white,
    this.radius = 40,
    this.totalValue = 10,
    this.selectedValue = 0,
    this.thickness = 10,
    this.dividerThickness = 2,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint primary = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    Paint secondary = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    Paint divider = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = dividerThickness;

    Offset center = Offset(size.width / 2, size.height / 2);

    // canvas.drawCircle(center, 40, paint);

    Offset _pointOnCircle(double radius, double angle) {
      return Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    canvas.drawCircle(
      center,
      radius - thickness / 2,
      secondary,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        height: radius * 2 - thickness,
        width: radius * 2 - thickness,
      ),
      -pi / 2,
      (2 * pi / totalValue) * selectedValue,
      false,
      primary,
    );

    for (int i = 0; i <= selectedValue; i++) {
      double angle = (2 * pi / totalValue) * i - (pi / 2);
      final startPoint = _pointOnCircle(
        radius - thickness,
        angle,
      );
      final endPoint = _pointOnCircle(
        radius,
        angle,
      );

      canvas.drawLine(
        startPoint,
        endPoint,
        divider,
      );
    }

    //write value
    final textSpan = TextSpan(
      text: '$selectedValue',
      style: textStyle ??
          TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
